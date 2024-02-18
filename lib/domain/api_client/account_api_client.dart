import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';

class AccountApiClient extends ApiClient {
  // final _sessionDataProvider = SessionDataProvider();
  // static String _sessionId = "";

  Future<AccountSate> getAccountState() async {
    // if(_sessionId.isEmpty) {
    //   final sessionId = await _sessionDataProvider.getSessionId();
    //   if(sessionId != null) {
    //     _sessionId = sessionId;
    //   }
    // }
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/account",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final accountSateResponse = AccountSate.fromJson(json);
    return accountSateResponse;
  }
}