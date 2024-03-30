import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/movie/details/movie_details.dart';
import 'package:the_movie_app/domain/entity/movie/movie_list/movie_list.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';

class MovieApiClient extends ApiClient {
  Future<MovieResponse> getDiscoverMovie(int page) async {

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

    final movieResponse = MovieResponse.fromJson(json);
    return movieResponse;
  }

  Future<MovieResponse> searchMovie(int page, String query) async {
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

    final movieResponse = MovieResponse.fromJson(json);
    return movieResponse;
  }

  Future<MovieDetails> getMovieById(int movieId) async {
    final url = makeUri(
      "/movie/$movieId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "release_dates,credits,videos",
        // "language": "uk-UA"
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieDetailsResponse = MovieDetails.fromJson(json);
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

  Future<MovieResponse> getTrendingMovie({required int page, required String timeToggle}) async {

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

    final movieResponse = MovieResponse.fromJson(json);
    return movieResponse;
  }
}