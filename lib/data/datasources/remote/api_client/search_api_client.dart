import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';

class SearchApiClient extends ApiClient {

  Future<CollectionsList> getSearchMediaCollections({required String query, required int page}) async {
    final url = makeUri(
      "/search/collection",
      <String, dynamic>{
        "api_key": apiKey,
        "query": query,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final mediaCollections = CollectionsList.fromJson(json);
    return mediaCollections;
  }

  Future<MediaListResponse> getSearchMovies({required String query, required int page}) async {
    final url = makeUri(
      "/search/movie",
      <String, dynamic>{
        "api_key": apiKey,
        "query": query,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieResponse = MediaListResponse.fromJson(json);
    return movieResponse;
  }

  Future<MediaListResponse> getSearchTvs({required String query, required int page}) async {
    final url = makeUri(
      "/search/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "query": query,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvResponse = MediaListResponse.fromJson(json);
    return tvResponse;
  }

  Future<TrendingPerson> getSearchPersons({required String query, required int page}) async {
    final url = makeUri(
      "/search/person",
      <String, dynamic>{
        "api_key": apiKey,
        "query": query,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final personResponse = TrendingPerson.fromJson(json);
    return personResponse;
  }

  Future<MediaListResponse> getSearchMulti({required String query, required int page}) async {
    final url = makeUri(
      "/search/multi",
      <String, dynamic>{
        "api_key": apiKey,
        "query": query,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final mediaResponse = MediaListResponse.fromJson(json);
    return mediaResponse;
  }
}