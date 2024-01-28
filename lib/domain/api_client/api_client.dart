import 'dart:convert';
import 'dart:io';

class ApiClient {
  final _client = HttpClient();
  static const _host = "https://api.themoviedb.org/3";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";
  static const _apiKey = "772a84be1e646a7870931e64417537cb";

  Future<String> auth({required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(username: username, password: password, requestToken: token);
    final sessionId = _makeSession(requestToken: validToken);

    return sessionId;
  }

  Future<String> _makeToken() async {
    final url = Uri.parse("$_host/authentication/token/new?api_key=$_apiKey");
    final request = await _client.getUrl(url);
    final response = await request.close();

    final json = (await response.jsonDecode()) as Map<String, dynamic>;
    // final json = await response
    //   .transform(utf8.decoder)
    //   .toList()
    //   .then((value) => value.join())
    //   .then((value) => jsonDecode(value) as Map<String, dynamic>);

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
    // final json = await response
    //     .transform(utf8.decoder)
    //     .toList()
    //     .then((value) => value.join())
    //     .then((value) => jsonDecode(value) as Map<String, dynamic>);

    final sessionId = json["session_id"] as String;

    return sessionId;
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