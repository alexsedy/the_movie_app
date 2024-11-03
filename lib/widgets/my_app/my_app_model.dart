import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';

class MyAppModel{
  Locale? _locale;
  final _apiClient = ApiClient();

  Locale? get locale => _locale;

  void initLocaleForAPI() {
    _apiClient.initLocale(_locale);
  }

  Future<void> getCurrentLocale() async {
    Locale? userLocale = await AccountManager.getUserLocale();
    _locale = userLocale;
    initLocaleForAPI();
  }

  Future<void> setCurrentLocale(Locale locale) async {
    _locale = locale;
    _apiClient.initLocale(locale);
    await AccountManager.setUserLocale(locale);
  }
}