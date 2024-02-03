import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/entity/movie_response/movie_response.dart';

enum ApiClientExceptionType {
  Network, Auth, Other
}

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = "https://api.themoviedb.org/3";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";
  static const _apiKey = "772a84be1e646a7870931e64417537cb";

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth({required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(username: username, password: password, requestToken: token);
    final sessionId = _makeSession(requestToken: validToken);

    return sessionId;
  }

  Future<MovieResponse> getDiscoverMovie(int page) async {

    final url = _makeUri(
      "/discover/movie",
      <String, dynamic>{
        "api_key": _apiKey,
        "page": page.toString()
      },
    );
    final request = await _client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final movieResponse = MovieResponse.fromJson(json);
    return movieResponse;
  }

  Future<String> _makeToken() async {
    final url = Uri.parse("$_host/authentication/token/new?api_key=$_apiKey");
    // final request = await _client.getUrl(url);
    // final response = await request.close();
    // final json = (await response.jsonDecode()) as Map<String, dynamic>;
    // final token = json["request_token"] as String;
    // return token;
    // _client.connectionTimeout = Duration.zero;
    final request = await _client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final token = json["request_token"] as String;
    return token;
  }

  Future<String> _validateUser(
      {required String username, required String password, required String requestToken}) async {
    final url = Uri.parse("$_host/authentication/token/validate_with_login?api_key=$_apiKey");
    final parameters = <String, dynamic>{
      "username": username,
      "password": password,
      "request_token": requestToken
    };

    final request = await _client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;
    // final json = await response
    //     .transform(utf8.decoder)
    //     .toList()
    //     .then((value) => value.join())
    //     .then((value) => jsonDecode(value) as Map<String, dynamic>);
    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 30) {
        throw ApiClientException(ApiClientExceptionType.Auth);
      }
    }

    final token = json["request_token"] as String;
    return token;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final url = Uri.parse("$_host/authentication/session/new?api_key=$_apiKey");
    final parameters = <String, dynamic>{
      "request_token": requestToken
    };

    final request = await _client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 17) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final sessionId = json["session_id"] as String;
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
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