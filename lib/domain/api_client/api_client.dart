import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';

enum ApiClientExceptionType {
  network, auth, other, incorrectRequest, sessionExpired, loginNotApproved, notFound
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

  ///Validate error for API requests
  ///statusCode 401:
  ///status_code == 7 - Invalid API key: You must be granted a valid key.
  ///status_code == 3 - sessionId expired or null, Authentication failed: You do not have permissions to access the service.
  ///
  /// statusCode 404:
  /// status_code = 6 - error in request
  ///
  /// statusCode == 400:
  /// status_code = 22 - error in request
  /// status_code = 5 - error in request
  void validateError(HttpClientResponse response, Map<String, dynamic> json) {
    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.other);
      } else if (responseCode == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else if (responseCode == 41) {
        throw ApiClientException(ApiClientExceptionType.loginNotApproved);
      }
    } else if (response.statusCode == 404) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 6) {
        throw ApiClientException(ApiClientExceptionType.incorrectRequest);
      } else if (responseCode == 34) {
        throw  ApiClientException(ApiClientExceptionType.notFound);
      }
    } else if (response.statusCode == 400) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 22) {
        throw ApiClientException(ApiClientExceptionType.incorrectRequest);
      } else if (responseCode == 5) {
        throw ApiClientException(ApiClientExceptionType.incorrectRequest);
      }
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