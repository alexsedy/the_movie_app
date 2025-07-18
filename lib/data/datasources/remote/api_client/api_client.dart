import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum ApiClientExceptionType {
  network,
  auth,
  other,
  incorrectRequest,
  sessionExpired,
  loginNotApproved,
  notFound,
}

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final client = HttpClient();
  static const _host = "https://api.themoviedb.org/3";
  static const _hostFour = "https://api.themoviedb.org/4";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";
  static const _apiKey = String.fromEnvironment('API_KEY');
  static String _languageCode = "en";
  static String _countryCode = "US";

  String get apiKey => _apiKey;
  String get host => _host;
  String get hostFour => _hostFour;
  String get reqLocale => "$_languageCode-$_countryCode";
  String get languageCode => _languageCode;
  String get countryCode => _countryCode;

  static String getImageByUrl(String path) => _imageUrl + path;

  Uri makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Uri makeUriFour(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_hostFour$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  void initLocale(Locale? locale)  {
    if(locale != null) {
      _languageCode = locale.languageCode;
      final countryCode = locale.countryCode;
      if(countryCode != null) {
        _countryCode = countryCode;
      }
    }
  }

  Future<T> safeRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on TimeoutException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on HttpException {
      throw ApiClientException(ApiClientExceptionType.other);
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  void validateError(HttpClientResponse response, Map<String, dynamic> json) {
    final statusCode = response.statusCode;
    final responseCode = json["status_code"] as int?;

    final errorMap = <int, Map<int, ApiClientExceptionType>>{
      401: {
        3: ApiClientExceptionType.sessionExpired,
        7: ApiClientExceptionType.other,
        41: ApiClientExceptionType.loginNotApproved,
      },
      404: {
        6: ApiClientExceptionType.incorrectRequest,
        34: ApiClientExceptionType.notFound,
      },
      400: {
        5: ApiClientExceptionType.incorrectRequest,
        22: ApiClientExceptionType.incorrectRequest,
      },
    };

    final type = errorMap[statusCode]?[responseCode];
    if (type != null) {
      throw ApiClientException(type);
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse{
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
      .toList()
      .then((value) => value.join())
      .then<dynamic>((value) => json.decode(value));
  }
}