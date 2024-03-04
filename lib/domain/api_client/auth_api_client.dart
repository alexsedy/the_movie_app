import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';

class AuthApiClient extends ApiClient {

  Future<String> getGuestSession() async {
    final token = await _getMakeToken();

    final url = makeUri(
      "/authentication/guest_session/new",
      <String, dynamic>{
        "api_key": apiKey,
        "request_token": token
      },
    );

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final guestSessionId = json["guest_session_id"] as String;
    return guestSessionId;
  }

  Future<void> deleteSession() async {
    final token = await _getMakeToken();
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/authentication/session",
      <String, dynamic>{
        "api_key": apiKey,
        "request_token": token,
      },
    );
    final parameters = <String, dynamic>{
      "session_id": sessionId
    };
    final request = await client.deleteUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<String> auth({required String username, required String password}) async {
    final token = await _getMakeToken();
    final validToken = await _postValidateUser(username: username, password: password, requestToken: token);
    final sessionId = await _postMakeSession(requestToken: validToken);

    return sessionId;
  }

  Future<String> _postMakeSession({required String requestToken}) async {
    final url = Uri.parse("$host/authentication/session/new?api_key=$apiKey");

    final parameters = <String, dynamic>{
      "request_token": requestToken
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final sessionId = json["session_id"] as String;
    return sessionId;
  }

  Future<String> _postValidateUser(
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

    validateError(response, json);

    final token = json["request_token"] as String;
    return token;
  }

  Future<String> _getMakeToken() async {
    final url = Uri.parse("$host/authentication/token/new?api_key=$apiKey");

    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final token = json["request_token"] as String;
    return token;
  }
}