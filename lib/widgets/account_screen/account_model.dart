import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/api_client/auth_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';

class AccountModel extends ChangeNotifier {
  final _apiClientAuth = AuthApiClient();
  final _apiClient = AccountApiClient();
  AccountSate? _accountSate;
  final _sessionDataProvider = SessionDataProvider();
  var _isLoggedIn = false;

  AccountSate? get accountSate => _accountSate;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isLoggedIn = sessionId != null;

    if(_isLoggedIn) {
      _getAccountState();
    }

    notifyListeners();
  }

  Future<void> makeLogout() async {
    // await _apiClientAuth.deleteSession();
    await AccountManager.resetAccountData();
    await _sessionDataProvider.setSessionId(null);
    notifyListeners();
  }

  Future<void> _getAccountState() async {
    _accountSate = await AccountManager.getAccountData();
    notifyListeners();
  }
}