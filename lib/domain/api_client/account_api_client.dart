import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';

class AccountApiClient extends ApiClient {

  Future<AccountSate> getAccountState() async {
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

    validateError(response, json);

    final accountSateResponse = AccountSate.fromJson(json);
    return accountSateResponse;
  }
}