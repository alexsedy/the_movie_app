import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/auth_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/user_profile/firebase_user_profile.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/widgets/list_screens/default_list/default_lists_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';


class AccountModel extends ChangeNotifier {
  final _apiClientAuth = AuthApiClient();
  AccountSate? _accountSate;
  var _isLoggedIn = false;
  var _isLinked = false;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountSate? get accountSate => _accountSate;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLinked => _isLinked;

  Future<void> checkLinkingStatus({String? tmdbAccountId = null}) async {
    tmdbAccountId = tmdbAccountId == null
        ? await AccountManager.getAccountId()
        : tmdbAccountId;
    try {
      final user = _auth.currentUser;

      if (user != null && tmdbAccountId != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        _isLinked = userDoc.exists &&
            userDoc.data()?['tmdb_account_id'] == tmdbAccountId;
      } else {
        _isLinked = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error checking linking status: $e');
      _isLinked = false;
      notifyListeners();
    }
  }

  Future<void> linkAccountWithGoogle(BuildContext context) async {
    try {
      final tmdbAccountId = await AccountManager.getAccountId();
      final tmdbUsername = _accountSate?.username;
      if (tmdbAccountId == null && tmdbUsername == null) {
        throw Exception('No TMDB account found');
      }

      final userCredential = await _auth.signInWithProvider(GoogleAuthProvider());
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Google authentication failed');
      }

      final existingUserDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (existingUserDoc.exists) {
        final existingTmdbUsername = existingUserDoc.data()?["tmdb_username"];
        if (existingTmdbUsername != tmdbUsername) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("This account is already linked to the \"$existingTmdbUsername\" TMDb account."),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
          return;
        }
      }

      final userProfile = FirebaseUserProfile(
        firebaseUid: user.uid,
        tmdbAccountId: tmdbAccountId,
        email: user.email,
        tmdbUsername: tmdbUsername,
        linkedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson(), SetOptions(merge: true));

      _isLinked = true;
      notifyListeners();
    } catch (e) {
      print('Error linking account: $e');
    }
  }

  Future<void> unlinkAccount() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user');
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'tmdb_account_id': FieldValue.delete(),
        'linked_at': FieldValue.delete(),
      });

      _isLinked = false;
      notifyListeners();
    } catch (e) {
      print('Error unlinking account: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    final sessionId = await SessionDataProvider.getSessionId();
    _isLoggedIn = sessionId != null;

    if (_isLoggedIn && _accountSate == null) {
      _getAccountState();
    }

    notifyListeners();
  }

  Future<void> makeLogout(BuildContext context) async {
    await _apiClientAuth.deleteSession();
    await _apiClientAuth.logout();
    await AccountManager.resetAccountData();
    _accountSate = null;
    await AccountManager.resetAccountId();
    await SessionDataProvider.setSessionId(null);
    await SessionDataProvider.setAccessToken(null);

    _isLoggedIn = false;

    notifyListeners();
  }

  Future<void> makeLogin(BuildContext context) async {
    final requestToken = await _apiClientAuth.createRequestToken();
    await _launchAuthPage(requestToken: requestToken);
    await _handleAuthDeepLink(requestToken, context);
  }

  Future<void> _launchAuthPage({required String requestToken}) async {
    final Uri url = Uri.parse('https://www.themoviedb.org/auth/access?request_token=$requestToken');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
              await SessionDataProvider.setAccessToken(accessToken);
              await AccountManager.setAccountId(accountId);
              final sessionId = await _apiClientAuth.createSession(accessToken);
              await SessionDataProvider.setSessionId(sessionId);

              await checkLinkingStatus(tmdbAccountId: accountId);

              await _getAccountState();

              _isLoggedIn = true;

              notifyListeners();
            }
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          context.l10n.unknownErrorPleaseTryAgainLater,
          style: const TextStyle(fontSize: 20),),
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