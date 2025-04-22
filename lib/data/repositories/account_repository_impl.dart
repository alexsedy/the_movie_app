import 'package:the_movie_app/data/datasources/remote/api_client/account_api_client.dart';
import 'package:the_movie_app/data/models/account/account_state/account_state.dart';
import 'package:the_movie_app/data/models/account/items_to_delete/remove_items.dart';
import 'package:the_movie_app/data/models/account/user_list_details/user_list_details.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final AccountApiClient _apiClient;

  AccountRepositoryImpl(this._apiClient);

  @override
  Future<AccountSate> getAccountState() => _apiClient.getAccountState();

  @override
  Future<UserLists> getUserLists(int page) => _apiClient.getUserLists(page);

  @override
  Future<UserListDetails> getUserListDetails({required int listId, required int page}) =>
      _apiClient.getUserListDetails(listId: listId, page: page);

  @override
  Future<void> addNewList({required String? description, required String name, required bool public}) =>
      _apiClient.addNewList(description: description, name: name, public: public);

  @override
  Future<void> addItemListToList({required int listId, required MediaType mediaType, required int mediaId}) =>
      _apiClient.addItemListToList(listId: listId, mediaType: mediaType, mediaId: mediaId);

  @override
  Future<bool> isAddedToListToList({required int listId, required MediaType mediaType, required int mediaId}) =>
      _apiClient.isAddedToListToList(listId: listId, mediaType: mediaType, mediaId: mediaId);

  @override
  Future<MediaListResponse> getDefaultMovieLists({required int page, required ListType listType}) =>
      _apiClient.getDefaultMovieLists(page: page, listType: listType);

  @override
  Future<MediaListResponse> getDefaultTvShowLists({required int page, required ListType listType}) =>
      _apiClient.getDefaultTvShowLists(page: page, listType: listType);

  @override
  Future<bool> removeItems(int listId, ListOfItemsToRemove listOfItemsToRemove) =>
      _apiClient.removeItems(listId, listOfItemsToRemove);

  @override
  Future<bool> removeList(int listId) => _apiClient.removeList(listId);

  @override
  Future<bool> updateList({required String? description, required String name, required bool public, required int listId}) =>
      _apiClient.updateList(description: description, name: name, public: public, listId: listId);
}
