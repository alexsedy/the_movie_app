import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/data/datasources/local/data_providers/session_data_provider.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/auth/auth.dart';

class AuthApiClient extends ApiClient {
  static const _apiAccessToken = String.fromEnvironment('ACCESS_TOKEN');

  Future<void> deleteSession() async {
    return safeRequest(() async {
      final sessionId = await SessionDataProvider.getSessionId();

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
    });
  }

  Future<void> logout() async {
    return safeRequest(() async {
      final accessToken = await SessionDataProvider.getAccessToken();

      final url = makeUriFour(
        "/auth/access_token",
        <String, dynamic>{
          "api_key": apiKey,
        },
      );
      final parameters = <String, dynamic>{
        "access_token": accessToken
      };

      final request = await client.deleteUrl(url);
      request.headers.contentType = ContentType.json;
      request.headers.add("Authorization", "Bearer $accessToken");
      request.write(jsonEncode(parameters));
      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;

      validateError(response, json);
    });
  }

  Future<String> createSession(String accessToken) async {
    return safeRequest(() async {
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
    });
  }

  Future<String> createRequestToken() async {
    return safeRequest(() async {
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
      request.headers.add("Authorization", "Bearer $_apiAccessToken");
      request.write(jsonEncode(parameters));

      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      validateError(response, json);

      final requestToken = json["request_token"] as String;
      return requestToken;
    });
  }

  Future<AuthData> createAccessToken({required String requestToken}) async {
    return safeRequest(() async {
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
      request.headers.add("Authorization", "Bearer $_apiAccessToken");
      request.write(jsonEncode(parameters));

      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;

      validateError(response, json);

      final authData = AuthData.fromJson(json);
      return authData;
    });
  }
}
