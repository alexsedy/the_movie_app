import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/auth/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthApiClient extends ApiClient {

  Future<void> deleteSession() async {
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/authentication/session",
      <String, dynamic>{
        "api_key": apiKey,
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

  Future<String> auth() async {
    final requestToken = await _createRequestToken();
    await _launchAuthPage(requestToken: requestToken);

    return requestToken;
  }

  Future<String> createSession(String accessToken) async {
    final url = makeUri(
      "/authentication/session/convert/4",
      <String, dynamic>{
        "api_key": apiKey,
      },
    );

    final parameters = <String, dynamic>{
      "access_token": accessToken
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

  Future<String> _createRequestToken() async {
    final url = makeUriFour(
      "/auth/request_token",
      <String, dynamic>{
        "api_key": apiKey,
      },
    );

    final parameters = <String, dynamic>{
      "redirect_to": "app://the_movie_app/auth_approve"
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", accessToken);
    request.write(jsonEncode(parameters));

    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;
    validateError(response, json);

    final requestToken = json["request_token"] as String;
    return requestToken;
  }

  Future<void> _launchAuthPage({required String requestToken}) async {
    final Uri url = Uri.parse('https://www.themoviedb.org/auth/access?request_token=$requestToken');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<AuthData> createAccessToken({required String requestToken}) async {
    final url = makeUriFour(
      "/auth/access_token",
      <String, dynamic>{
        "api_key": apiKey,
      },
    );
    final parameters = <String, dynamic>{
      "request_token": requestToken,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", accessToken);
    request.write(jsonEncode(parameters));

    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final authData = AuthData.fromJson(json);
    return authData;
  }

  // @Deprecated("Deprecated method")
  // Future<String> authOld({required String username, required String password}) async {
  //   final token = await _getMakeToken();
  //   final validToken = await _postValidateUser(username: username, password: password, requestToken: token);
  //   final sessionId = await _postMakeSession(requestToken: validToken);
  //
  //   return sessionId;
  // }

  // @Deprecated("Deprecated method")
  // Future<String> _postMakeSession({required String requestToken}) async {
  //   final url = Uri.parse("$host/authentication/session/new?api_key=$apiKey");
  //
  //   final parameters = <String, dynamic>{
  //     "request_token": requestToken
  //   };
  //
  //   final request = await client.postUrl(url);
  //   request.headers.contentType = ContentType.json;
  //   request.write(jsonEncode(parameters));
  //   final response = await request.close();
  //   final json = (await response.jsonDecode()) as Map<String, dynamic>;
  //
  //   validateError(response, json);
  //
  //   final sessionId = json["session_id"] as String;
  //   return sessionId;
  // }

  // @Deprecated("Deprecated method")
  // Future<String> _postValidateUser(
  //     {required String username, required String password, required String requestToken}) async {
  //   final url = Uri.parse("$host/authentication/token/validate_with_login?api_key=$apiKey");
  //   final parameters = <String, dynamic>{
  //     "username": username,
  //     "password": password,
  //     "request_token": requestToken
  //   };
  //
  //   final request = await client.postUrl(url);
  //   request.headers.contentType = ContentType.json;
  //   request.write(jsonEncode(parameters));
  //   final response = await request.close();
  //   final json = (await response.jsonDecode()) as Map<String, dynamic>;
  //
  //   validateError(response, json);
  //
  //   final token = json["request_token"] as String;
  //   return token;
  // }

  // @Deprecated("Deprecated method")
  // Future<String> _getMakeToken() async {
  //   final url = Uri.parse("$host/authentication/token/new?api_key=$apiKey");
  //
  //   final request = await client.getUrl(url);
  //   final response = await request.close();
  //   final json = (await response.jsonDecode()) as Map<String, dynamic>;
  //
  //   validateError(response, json);
  //
  //   final token = json["request_token"] as String;
  //   return token;
  // }
}