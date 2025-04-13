import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/data/datasources/firebase/firebase_auth_service.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/account_management.dart';
import 'package:the_movie_app/data/datasources/local/data_providers/session_data_provider.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/account/account_state/account_state.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/data/repositories/i_auth_repository.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;
  final IAccountRepository _accountRepository;
  final FirebaseAuthService _firebaseAuthService;

  AccountSate? _accountSate;
  bool _isLoggedIn = false;
  bool _isLinked = false;
  StreamSubscription<Uri>? _sub;
  bool _isLoading = false;
  bool _isAuthProcess = false;
  bool _isLinkProcess = false;

  AccountSate? get accountSate => _accountSate;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLinked => _isLinked;
  bool get isLoading => _isLoading;
  bool get isAuthProcess => _isAuthProcess;
  bool get isLinkProcess => _isLinkProcess;


  AccountViewModel(
      this._authRepository,
      this._accountRepository,
      this._firebaseAuthService,
      ) {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();
    await checkLoginStatus();
    if (_isLoggedIn) {
      await checkLinkingStatus();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final sessionId = await SessionDataProvider.getSessionId();
    final wasLoggedIn = _isLoggedIn;
    _isLoggedIn = sessionId != null;
    if (_isLoggedIn && _accountSate == null) {
      await _getAccountState();
    }
    if (wasLoggedIn != _isLoggedIn) {
      notifyListeners();
    }
  }

  Future<void> _getAccountState() async {
    try {
      _accountSate = await _accountRepository.getAccountState();
      // Сохраняем в кеш (если AccountManager еще не делает этого)
      // await AccountManager.setAccountData(_accountSate); // Пример
    } catch (e) {
      print("Error getting account state: $e");
      // Возможно, сбросить сессию, если ошибка связана с ней
      if (e is ApiClientException && e.type == ApiClientExceptionType.sessionExpired) {
        await _forceLogout();
      }
    }
  }

  Future<void> checkLinkingStatus({String? tmdbAccountId}) async {
    tmdbAccountId = tmdbAccountId ?? await AccountManager.getAccountId();
    try {
      _isLinked = await _firebaseAuthService.checkLinkStatus(tmdbAccountId);
      await AccountManager.setFBLinkStatus(_isLinked);
    } catch (e) {
      print('Error checking linking status: $e');
      _isLinked = false;
      await AccountManager.resetFBLinkStatus();
    }
    notifyListeners();
  }

  Future<void> linkAccountWithGoogle(BuildContext context) async {
    _isLinkProcess = true;
    notifyListeners();
    try {
      final tmdbAccountId = await AccountManager.getAccountId();
      final tmdbUsername = _accountSate?.username;
      if (tmdbAccountId == null || tmdbUsername == null) {
        throw Exception('No TMDB account found');
      }

      await _firebaseAuthService.linkAccount(tmdbAccountId, tmdbUsername);
      _isLinked = true;
      await AccountManager.setFBLinkStatus(_isLinked);
    } on Exception catch (e) {
      _showLinkErrorDialog(context, e);
    } catch (e) {
      print('Error linking account: $e');
      _showGenericErrorDialog(context);
    } finally {
      _isLinkProcess = false;
      notifyListeners();
    }
  }

  Future<void> unlinkAccount(BuildContext context) async {
    _isLinkProcess = true;
    notifyListeners();
    try {
      await _firebaseAuthService.unlinkUser();
      _isLinked = false;
      await AccountManager.resetFBLinkStatus();
    } catch (e) {
      print('Error unlinking account: $e');
      _showGenericErrorDialog(context);
    } finally {
      _isLinkProcess = false;
      notifyListeners();
    }
  }

  Future<void> makeLogout(BuildContext context) async {
    _isAuthProcess = true;
    notifyListeners();
    try {
      await _authRepository.deleteSession();
      await _authRepository.logout();
      await _clearLocalAuthData();
    } catch (e) {
      print("Logout error: $e");
      _showGenericErrorDialog(context);
      await _clearLocalAuthData();
    } finally {
      _isAuthProcess = false;
      notifyListeners();
    }
  }

  Future<void> _forceLogout() async {
    try {
      await _authRepository.deleteSession();
      await _authRepository.logout();
    } catch (_) {
    }
    await _clearLocalAuthData();
    notifyListeners();
  }


  Future<void> _clearLocalAuthData() async {
    await AccountManager.resetAccountData();
    await AccountManager.resetAccountId();
    await AccountManager.resetFBLinkStatus();
    await SessionDataProvider.setSessionId(null);
    await SessionDataProvider.setAccessToken(null);
    _accountSate = null;
    _isLoggedIn = false;
    _isLinked = false;
  }

  Future<void> makeLogin(BuildContext context) async {
    _isAuthProcess = true;
    notifyListeners();
    try {
      final requestToken = await _authRepository.createRequestToken();
      final url = Uri.parse('https://www.themoviedb.org/auth/access?request_token=$requestToken');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
      _handleAuthDeepLink(requestToken, context); // Этот метод нужно будет адаптировать
    } catch (e) {
      print("Login error: $e");
      _showGenericErrorDialog(context);
      _isAuthProcess = false;
      notifyListeners();
    }
  }

  Future<void> completeLogin(String requestToken, BuildContext context) async {
    try {
      final authData = await _authRepository.createAccessToken(requestToken: requestToken);
      final accountId = authData.accountId;
      final accessToken = authData.accessToken;

      if (accountId != null && accessToken != null) {
        await SessionDataProvider.setAccessToken(accessToken);
        await AccountManager.setAccountId(accountId);
        final sessionId = await _authRepository.createSession(accessToken);
        await SessionDataProvider.setSessionId(sessionId);

        _isLoggedIn = true;
        await _getAccountState();
        await checkLinkingStatus(tmdbAccountId: accountId);
        print("Login successful!");
      } else {
        throw Exception("Failed to get access token or account ID");
      }
    } catch (e) {
      print("Login completion error: $e");
      _showGenericErrorDialog(context);
      // При ошибке здесь тоже можно почистить локальные данные, если нужно
      // await _clearLocalAuthData();
    } finally {
      _isAuthProcess = false;
      notifyListeners();
      _sub?.cancel();
      _sub = null;
    }
  }

  void _handleAuthDeepLink(String requestToken, BuildContext context) {
    _sub?.cancel();
    final appLinks = AppLinks();
    _sub = appLinks.uriLinkStream.listen((Uri? uri) {
      print("Received URI: $uri");
      if (uri != null && uri.host == 'the_movie_app' && uri.path == '/auth_approve') {
        completeLogin(requestToken, context);
      } else {
        // Ссылка не та, или null - возможно, пользователь закрыл вкладку
        // Можно сбросить флаг загрузки через таймер, если ответ не пришел
        // _isAuthProcess = false;
        // notifyListeners();
      }
    }, onError: (err) {
      print("Error listening to deep links: $err");
      _isAuthProcess = false;
      notifyListeners();
      _showGenericErrorDialog(context);
    });
  }

  void _showLinkErrorDialog(BuildContext context, Exception e) {
    String errorMessage = context.l10n.anErrorHasOccurredTryAgainLater;
    if (e.toString().contains('Account already linked to TMDb username:')) {
      final linkedUsername = e.toString().split(':').last.trim();
      errorMessage = "This Google account is already linked to the \"$linkedUsername\" TMDb account."; // TODO: Localize
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Error"), // TODO: Localize
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showGenericErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Error"), // TODO: Localize
        content: Text(context.l10n.anErrorHasOccurredTryAgainLater),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }


  void onFavoriteList(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.favorites);
  void onWatchlistList(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.watchlist);
  void onRatedList(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.rated);
  void onRecommendationList(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.recommendations);
  void onUserLists(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.userLists);
  void onAIFeatureScreen(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.aiFeatureStart);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}