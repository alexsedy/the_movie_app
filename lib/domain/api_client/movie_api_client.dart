import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/state/item_state.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';

class MovieApiClient extends ApiClient {
  Future<MediaListResponse> getDiscoverMovie(int page) async {

    final url = makeUri(
      "/discover/movie",
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

    final movieResponse = MediaListResponse.fromJson(json);
    return movieResponse;
  }

  Future<MediaListResponse> getMovieWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  }) async {

    final url = makeUri(
      "/discover/movie",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        if(releaseDateStart != null && releaseDateStart.isNotEmpty)
          "release_date.gte": releaseDateStart,
        if(releaseDateEnd != null && releaseDateEnd.isNotEmpty)
          "release_date.lte": releaseDateEnd,
        if(sortBy != null && sortBy.isNotEmpty)
          "sort_by": sortBy,
        // if(voteStart != null)
          "vote_average.gte": voteStart.toString(),
        // if(voteEnd != null)
          "vote_average.lte": voteEnd.toString(),
        if(genres != null && genres.isNotEmpty)
          "with_genres": genres,
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieResponse = MediaListResponse.fromJson(json);
    return movieResponse;
  }

  Future<MediaListResponse> searchMovie(int page, String query) async {
    final url = makeUri(
      "/search/movie",
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

    final movieResponse = MediaListResponse.fromJson(json);
    return movieResponse;
  }

  Future<MediaDetails> getMovieById(int movieId) async {
    final url = makeUri(
      "/movie/$movieId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "release_dates,credits,videos,recommendations",
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieDetailsResponse = MediaDetails.fromJson(json);
    return movieDetailsResponse;
  }

  Future<ItemState?> getMovieState(int movieId) async {
    final sessionId = await sessionDataProvider.getSessionId();

    if(sessionId == null) {
      return null;
    }

    final url = makeUri(
      "/movie/$movieId/account_states",
      <String, dynamic>{
        "api_key": apiKey,
        "session_id": sessionId,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieStateResponse = ItemState.fromJson(json);
    return movieStateResponse;
  }

  Future<void> addToFavorite({required int movieId, required bool isFavorite}) async {
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
      "media_type": "movie",
      "media_id": movieId,
      "favorite": isFavorite,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<Credits> getCredits(int movieId) async {

    final url = makeUri(
      "/movie/$movieId/credits",
      <String, dynamic>{
        "api_key": apiKey,
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieCredits = Credits.fromJson(json);
    return movieCredits;
  }

  Future<void> addToWatchlist({required int movieId, required bool isWatched}) async {
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
      "media_type": "movie",
      "media_id": movieId,
      "watchlist": isWatched,
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<void> addRating({required int movieId, required double rate}) async {
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/movie/$movieId/rating",
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

  Future<void> deleteRating({required int movieId}) async {
    final sessionId = await sessionDataProvider.getSessionId();

    final url = makeUri(
      "/movie/$movieId/rating",
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

  Future<MediaListResponse> getTrendingMovie({required int page, required String timeToggle}) async {

    final url = makeUri(
      "/trending/movie/$timeToggle",
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

    final movieResponse = MediaListResponse.fromJson(json);
    return movieResponse;
  }

  Future<MediaCollections> getMediaCollections(int collectionId) async {

    final url = makeUri(
      "/collection/$collectionId",
      <String, dynamic>{
        "api_key": apiKey,
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final mediaCollections = MediaCollections.fromJson(json);
    return mediaCollections;
  }
}