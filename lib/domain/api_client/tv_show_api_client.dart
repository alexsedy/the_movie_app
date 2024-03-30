import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';
import 'package:the_movie_app/domain/entity/tv_show/details/tv_show_details.dart';
import 'package:the_movie_app/domain/entity/tv_show/tv_show_list/tv_show_list.dart';

class TvShowApiClient extends ApiClient {
  Future<TvShowResponse> getDiscoverTvShow(int page) async {
    final url = makeUri(
      "/discover/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = TvShowResponse.fromJson(json);
    return tvShowResponse;
  }

  Future<TvShowResponse> searchTvShow(int page, String query) async {
    final url = makeUri(
      "/search/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        "query": query
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = TvShowResponse.fromJson(json);
    return tvShowResponse;
  }

  Future<TvShowDetails> getTvShowById(int seriesId) async {
    final url = makeUri(
      "/tv/$seriesId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "credits,videos,content_ratings",
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowDetailsResponse = TvShowDetails.fromJson(json);
    return tvShowDetailsResponse;
  }

  Future<ItemState?> getTvShowState(int seriesId) async {
    final sessionId = await sessionDataProvider.getSessionId();

    if (sessionId == null) {
      return null;
    }

    final url = makeUri(
      "/tv/$seriesId/account_states",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    if (response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if (responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }

    final tvShowStateResponse = ItemState.fromJson(json);
    return tvShowStateResponse;
  }

  Future<void> makeFavorite(
      {required int tvShowId, required bool isFavorite}) async {
    final accountSate = await AccountManager.getAccountData();
    final accountId = accountSate.id;

    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/account/$accountId/favorite",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );

    final parameters = <String, dynamic>{
      "media_type": "tv",
      "media_id": tvShowId,
      "favorite": isFavorite,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<void> addToWatchlist(
      {required int tvShowId, required bool isWatched}) async {
    final accountSate = await AccountManager.getAccountData();
    final accountId = accountSate.id;

    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/account/$accountId/watchlist",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );

    final parameters = <String, dynamic>{
      "media_type": "tv",
      "media_id": tvShowId,
      "watchlist": isWatched,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<void> addRating({required int tvShowId, required double rate}) async {
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/tv/$tvShowId/rating",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );

    final parameters = <String, dynamic>{
      "value": rate,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<void> deleteRating({required int tvShowId}) async {
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/tv/$tvShowId/rating",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );

    final request = await client.deleteUrl(url);
    request.headers.contentType = ContentType.json;
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<TvShowResponse> getTrendingTv(
      {required int page, required String timeToggle}) async {
    final url = makeUri(
      "/trending/tv/$timeToggle",
      <String, dynamic>{
        "api_key": apiKey,
        // "page": page.toString(),
        "language": "en-US"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = TvShowResponse.fromJson(json);
    return tvShowResponse;
  }
}