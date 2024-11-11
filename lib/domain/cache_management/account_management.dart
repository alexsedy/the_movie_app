import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';

class AccountManager {
  static const String _cachedAccountKey = 'cached_account';
  static const String _accountIdKey = 'account_id';
  static const String _languageCodeKey = 'language';
  static const String _countryCodeKey = 'country';

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
      prefs.setString(_accountIdKey, value);
    }
  }

  static Future<void> resetAccountId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_accountIdKey);
  }

  static Future<Locale?> getUserLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageCodeKey);
    String? countryCode = prefs.getString(_countryCodeKey);
    if (languageCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  static Future<void> setUserLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
    await prefs.setString(_countryCodeKey, locale.countryCode ?? '');
  }

  static Future<void> resetUserLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageCodeKey);
    await prefs.remove(_countryCodeKey);
  }

  // static Future<String?> getUserLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_languageCodeKey);
  // }
  //
  // static Future<void> setUserLanguage(String? value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (value != null) {
  //     prefs.setString(_languageCodeKey, value);
  //   }
  // }
  //
  // static Future<void> resetUserLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(_languageCodeKey);
  // }
  //
  // static Future<String?> getUserCountry() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_countryCodeKey);
  // }
  //
  // static Future<void> setUserCountry(String? value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (value != null) {
  //     prefs.setString(_countryCodeKey, value);
  //   }
  // }
  //
  // static Future<void> resetUserCountry() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(_countryCodeKey);
  // }
}