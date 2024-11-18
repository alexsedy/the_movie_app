import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/domain/entity/media/state/item_state.dart';

class TvShowApiClient extends ApiClient {
  Future<MediaListResponse> getDiscoverTvShow(int page) async {
    final url = makeUri(
      "/discover/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = MediaListResponse.fromJson(json);
    return tvShowResponse;
  }

  @deprecated
  Future<MediaListResponse> searchTvShow(int page, String query) async {
    final url = makeUri(
      "/search/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        "query": query,
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = MediaListResponse.fromJson(json);
    return tvShowResponse;
  }

  Future<MediaListResponse> getTvShowWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  }) async {

    final url = makeUri(
      "/discover/tv",
      <String, dynamic>{
        "api_key": apiKey,
        "page": page.toString(),
        if(releaseDateStart != null && releaseDateStart.isNotEmpty)
          "release_date.gte": releaseDateStart,
        if(releaseDateEnd != null && releaseDateEnd.isNotEmpty)
          "release_date.lte": releaseDateEnd,
        if(sortBy != null && sortBy.isNotEmpty)
          "sort_by": sortBy,
        "vote_average.gte": voteStart.toString(),
        "vote_average.lte": voteEnd.toString(),
        if(genres != null && genres.isNotEmpty)
          "with_genres": genres,
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

  Future<MediaDetails> getTvShowById(int seriesId) async {
    final url = makeUri(
      "/tv/$seriesId",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response": "credits,videos,content_ratings,recommendations",
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowDetailsResponse = MediaDetails.fromJson(json);
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

  Future<MediaListResponse> getTrendingTv(
      {required int page, required String timeToggle}) async {
    final url = makeUri(
      "/trending/tv/$timeToggle",
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

    final tvShowResponse = MediaListResponse.fromJson(json);
    return tvShowResponse;
  }

  Future<Season> getSeason(int seriesId, int seasonNumber) async {
    final url = makeUri(
      "/tv/$seriesId/season/$seasonNumber",
      <String, dynamic>{
        "api_key": apiKey,
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final season = Season.fromJson(json);
    return season;
  }

  Future<MediaDetails> getSeriesDetails(int seriesId, int seasonNumber, int episodeNumber) async {
    final url = makeUri(
      "/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber",
      <String, dynamic>{
        "api_key": apiKey,
        "append_to_response" : "account_states,credits,videos",
        "language": reqLocale,
      },
    );
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final seriesDetails = MediaDetails.fromJson(json);
    return seriesDetails;
  }
}