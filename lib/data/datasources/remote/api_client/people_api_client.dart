import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/person/details/person_details.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';

class PeopleApiClient extends ApiClient {
  Future<PersonDetails> getPersonById(int personId) async {
    final url = makeUri(
      "/person/$personId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "external_ids,images,movie_credits,tv_credits",
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final personDetailsResponse = PersonDetails.fromJson(json);
    return personDetailsResponse;
  }

  Future<TrendingPerson> getTrendingPerson(
      {required int page, required String timeToggle}) async {
    final url = makeUri(
      "/trending/person/$timeToggle",
      <String, dynamic>{
        "api_key": apiKey,
        // "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final trendingPerson = TrendingPerson.fromJson(json);
    return trendingPerson;
  }
}
