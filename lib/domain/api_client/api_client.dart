import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';

enum ApiClientExceptionType {
  network, auth, other, incorrectRequest, sessionExpired
}

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final client = HttpClient();
  final sessionDataProvider = SessionDataProvider();
  static const _host = "https://api.themoviedb.org/3";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";
  static const _apiKey = "772a84be1e646a7870931e64417537cb";

  String get apiKey => _apiKey;
  String get host => _host;

  static String getImageByUrl(String path) => _imageUrl + path;

  Uri makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
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
      }
    } else if (response.statusCode == 404) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 6) {
        throw ApiClientException(ApiClientExceptionType.incorrectRequest);
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