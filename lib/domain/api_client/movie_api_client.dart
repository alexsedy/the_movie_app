import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
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

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

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

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

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

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final movieDetailsResponse = MovieDetails.fromJson(json);
    return movieDetailsResponse;
  }

  Future<ItemState> getMovieState(int movieId) async {
    final sessionId = await sessionDataProvider.getSessionId();

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

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final movieStateResponse = ItemState.fromJson(json);
    return movieStateResponse;
  }

  Future<void> makeFavorite({required int accountId, required int movieId, required bool isFavorite}) async {
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

    if(response.statusCode == 400) {
      // final responseCode = json["status_code"] as int;
      // if(responseCode == 5) {
        throw ApiClientException(ApiClientExceptionType.Other);
      // }
    }
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

    if(response.statusCode == 401) {
      final responseCode = json["status_code"] as int;
      if(responseCode == 7) {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }

    final movieCredits = Credits.fromJson(json);
    return movieCredits;
  }
}