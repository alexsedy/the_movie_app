import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';

enum ApiClientExceptionType {
  Network, Auth, Other
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
}

extension HttpClientResponseJsonDecode on HttpClientResponse{
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
      .toList()
      .then((value) => value.join())
      .then<dynamic>((value) => json.decode(value));
  }
}