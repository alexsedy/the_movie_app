import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/person/details/person_details.dart';

class PeopleApiClient extends ApiClient {
  Future<PersonDetails> getPersonById(int personId) async {
    final url = makeUri(
      "/person/$personId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "external_ids,images,movie_credits,tv_credits",
        // "language": "uk-UA"
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

    final personDetailsResponse = PersonDetails.fromJson(json);
    return personDetailsResponse;
  }
}