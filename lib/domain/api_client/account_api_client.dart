import 'dart:convert';
import 'dart:io';

import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/account/user_list_details/user_list_details.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/widgets/list_screens/default_lists_model.dart';

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

  Future<UserLists> getUserLists(int page) async {
    final accountObjectId = await AccountManager.getAccountId();

    final url = makeUriFour(
      "/account/$accountObjectId/lists",
      <String, dynamic>{
        "page": page.toString(),
      },
    );
    final request = await client.getUrl(url);
    request.headers.add("Authorization", accessToken);
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final userLists = UserLists.fromJson(json);
    return userLists;
  }

  Future<UserListDetails> getUserListDetails({required int listId, required int page}) async {
    final accessToken = await sessionDataProvider.getAccessToken();

    final url = makeUriFour(
      "/list/$listId",
      <String, dynamic>{
        "page": page.toString(),
      },
    );
    final request = await client.getUrl(url);
    request.headers.add("Authorization", "Bearer $accessToken");
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final userListDetails = UserListDetails.fromJson(json);
    return userListDetails;
  }

  Future<void> addNewList({required String? description, required String name, required bool public}) async {
    final accessToken = await sessionDataProvider.getAccessToken();

    final url = makeUriFour(
      "/list",
      <String, dynamic>{
      },
    );

    final parameters = <String, dynamic>{
      "description": description,
      "name": name,
      "iso_3166_1": "US",
      "iso_639_1": "en",
      "public": public.toString(),
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", "Bearer $accessToken");
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<void> addItemListToList({required int listId, required MediaType mediaType, required int mediaId}) async {
    final accessToken = await sessionDataProvider.getAccessToken();

    final url = makeUriFour(
      "/list/$listId/items",
      <String, dynamic>{
      },
    );

    final mediaTypeString = mediaType == MediaType.movie ? "movie" : "tv";

    final parameters = <String, dynamic>{
      "items": <Map<String, dynamic>>[{
          "media_type": mediaTypeString,
          "media_id": mediaId
        }]
    };

    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", "Bearer $accessToken");
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);
  }

  Future<bool> isAddedToListToList({required int listId, required MediaType mediaType, required int mediaId}) async {
    final accessToken = await sessionDataProvider.getAccessToken();

    final mediaTypeString = mediaType == MediaType.movie ? "movie" : "tv_show";

    final url = makeUriFour(
      "/list/$listId/item_status",
      <String, dynamic>{
        "media_type": mediaTypeString,
        "media_id": mediaId.toString()
      },
    );

    final request = await client.getUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", "Bearer $accessToken");
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    final success = json["success"] as bool;
    return success;
  }

  Future<ListResponse> getDefaultMovieLists({required int page, required ListType listType}) async {
    final accessToken = await sessionDataProvider.getAccessToken();
    final accountObjectId = await AccountManager.getAccountId();

    String list;

    switch(listType) {
      case ListType.favorites:
        list = "favorites";
      case ListType.watchlist:
        list = "watchlist";
      case ListType.rated:
        list = "rated";
      case ListType.recommendations:
        list = "recommendations";
    }

    final url = makeUriFour(
      "/account/$accountObjectId/movie/$list",
      <String, dynamic>{
        "language": "en-US",
        "page": page.toString(),
      },
    );

    final request = await client.getUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", "Bearer $accessToken");
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final movieResponse = ListResponse.fromJson(json);
    return movieResponse;
  }

  Future<ListResponse> getDefaultTvShowLists({required int page, required ListType listType}) async {
    final accessToken = await sessionDataProvider.getAccessToken();
    final accountObjectId = await AccountManager.getAccountId();

    String list;

    switch(listType) {
      case ListType.favorites:
        list = "favorites";
      case ListType.watchlist:
        list = "watchlist";
      case ListType.rated:
        list = "rated";
      case ListType.recommendations:
        list = "recommendations";
    }

    final url = makeUriFour(
      "/account/$accountObjectId/tv/$list",
      <String, dynamic>{
        "language": "en-US",
        "page": page.toString(),
      },
    );

    final request = await client.getUrl(url);
    request.headers.contentType = ContentType.json;
    request.headers.add("Authorization", "Bearer $accessToken");
    final response = await request.close();
    final json = (await response.jsonDecode()) as Map<String, dynamic>;

    validateError(response, json);

    final tvShowResponse = ListResponse.fromJson(json);
    return tvShowResponse;
  }
}

enum MediaType {
  movie, tvShow
}