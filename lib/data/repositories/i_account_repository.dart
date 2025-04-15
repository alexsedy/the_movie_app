import 'package:the_movie_app/data/models/account/account_state/account_state.dart';
import 'package:the_movie_app/data/models/account/items_to_delete/remove_items.dart';
import 'package:the_movie_app/data/models/account/user_list_details/user_list_details.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

abstract class IAccountRepository {
  Future<AccountSate> getAccountState();
  Future<UserLists> getUserLists(int page);
  Future<UserListDetails> getUserListDetails({required int listId, required int page});
  Future<void> addNewList({required String? description, required String name, required bool public});
  Future<void> addItemListToList({required int listId, required MediaType mediaType, required int mediaId});
  Future<bool> isAddedToListToList({required int listId, required MediaType mediaType, required int mediaId});
  Future<MediaListResponse> getDefaultMovieLists({required int page, required ListType listType});
  Future<MediaListResponse> getDefaultTvShowLists({required int page, required ListType listType});
  Future<bool> removeItems(int listId, ListOfItemsToRemove listOfItemsToRemove);
  Future<bool> removeList(int listId);
  Future<bool> updateList({required String? description, required String name, required bool public, required int listId});
}