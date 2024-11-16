import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/auth_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/widgets/list_screens/default_list/default_lists_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';


class AccountModel extends ChangeNotifier {
  final _apiClientAuth = AuthApiClient();
  AccountSate? _accountSate;
  final _sessionDataProvider = SessionDataProvider();
  var _isLoggedIn = false;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  AccountSate? get accountSate => _accountSate;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isLoggedIn = sessionId != null;

    if (_isLoggedIn && _accountSate == null) {
      _getAccountState();
    }

    notifyListeners();
  }

  Future<void> makeLogout(BuildContext context) async {
    await _apiClientAuth.deleteSession();
    await AccountManager.resetAccountData();
    _accountSate = null;
    await AccountManager.resetAccountId();
    await _sessionDataProvider.setSessionId(null);
    await _sessionDataProvider.setAccessToken(null);

    _isLoggedIn = false;

    notifyListeners();
  }

  Future<void> makeLogin(BuildContext context) async {
    final requestToken = await _apiClientAuth.auth();
    await _handleAuthDeepLink(requestToken, context);
  }

  Future<void> _handleAuthDeepLink(String requestToken, BuildContext context) async {
    try {
      // Uri? initialUri = await getInitialUri();
      // if (initialUri != null) {
      //   _handleAuthDeepLink(initialUri);
      // }
      _appLinks = AppLinks();
      _sub = _appLinks.uriLinkStream.listen((Uri? uri) async {
        if (uri != null) {
          if(uri.toString() == "app://the_movie_app/auth_approve") {
            final authData = await _apiClientAuth.createAccessToken(requestToken: requestToken);
            final accountId = authData.accountId;
            final accessToken = authData.accessToken;
            _sub?.cancel();

            if(accountId != null && accessToken != null) {
              await _sessionDataProvider.setAccessToken(accessToken);
              await AccountManager.setAccountId(accountId);
              final sessionId = await _apiClientAuth.createSession(accessToken);
              _sessionDataProvider.setSessionId(sessionId);

              await _getAccountState();

              _isLoggedIn = true;

              notifyListeners();
            }
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Unknown error. Please try again later.",
          style: TextStyle(fontSize: 20),),
      ));
    }
  }

  Future<void> _getAccountState() async {
    _accountSate = await AccountManager.getAccountData();
  }

  void onFavoriteList(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.favorites);
  }

  void onWatchlistList(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.watchlist);
  }

  void onRatedList(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.rated);
  }

  void onRecommendationList(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.defaultList, arguments: ListType.recommendations);
  }

  void onUserLists(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.userLists);
  }

  void onAIFeatureScreen(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.aiFeatureStart);
  }


  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}