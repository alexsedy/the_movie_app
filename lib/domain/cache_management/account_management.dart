import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';

class AccountManager {
  static const String _cachedAccountKey = 'cached_account';
  static const String _accountIdKey = 'account_id';

  static Future<AccountSate> getAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cachedAccountState = prefs.getString(_cachedAccountKey);
    if (cachedAccountState != null) {
      final decodedAccount = jsonDecode(cachedAccountState);

      return AccountSate.fromJson(decodedAccount);
    } else {
      final accountApiClient = AccountApiClient();
      final accountResponseState = await accountApiClient.getAccountState();
      await prefs.setString(_cachedAccountKey, jsonEncode(accountResponseState.toJson()));

      return accountResponseState;
    }
  }

  static Future<void> resetAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_cachedAccountKey);
  }

  static Future<String?> getAccountId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accountIdKey);
  }

  static Future<void> setAccountId(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      prefs.getString(value);
    }
  }

  static Future<void> resetAccountId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_accountIdKey);
  }
}