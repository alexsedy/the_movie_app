import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';

class AuthApiClient extends ApiClient {

  Future<String> auth({required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(username: username, password: password, requestToken: token);
    final sessionId = _makeSession(requestToken: validToken);

    return sessionId;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final url = Uri.parse("$host/authentication/session/new?api_key=$apiKey");
    final parameters = <String, dynamic>{
      "request_token": requestToken
    };

    final request = await client.postUrl(url);
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

  Future<String> _validateUser(
      {required String username, required String password, required String requestToken}) async {
    final url = Uri.parse("$host/authentication/token/validate_with_login?api_key=$apiKey");
    final parameters = <String, dynamic>{
      "username": username,
      "password": password,
      "request_token": requestToken
    };

    final request = await client.postUrl(url);
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

  Future<String> _makeToken() async {
    final url = Uri.parse("$host/authentication/token/new?api_key=$apiKey");
    // final request = await _client.getUrl(url);
    // final response = await request.close();
    // final json = (await response.jsonDecode()) as Map<String, dynamic>;
    // final token = json["request_token"] as String;
    // return token;
    // _client.connectionTimeout = Duration.zero;
    final request = await client.getUrl(url);
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
}