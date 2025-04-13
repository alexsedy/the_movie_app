// import 'package:flutter/cupertino.dart';
// import 'package:the_movie_app/core/helpers/event_helper.dart';
// import 'package:the_movie_app/data/datasources/remote/api_client/account_api_client.dart';
// import 'package:the_movie_app/data/models/account/items_to_delete/remove_items.dart';
// import 'package:the_movie_app/data/models/account/user_list_details/user_list_details.dart';
// import 'package:the_movie_app/presentation/features/list_screens/user_list/list_update_event_bus.dart';
// import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
//
// class DetailsUserListsModel extends ChangeNotifier {
//   final ScrollController _scrollController = ScrollController();
//   final int listId;
//   final _accountApiClient = AccountApiClient();
//   final _listOfUserListDetails = <UserListResult>[];
//   UserListDetails? _userListDetails;
//   int _currentUserListPage = 0;
//   int _totalUserListPage = 1;
//   var _isListLoadingInProgress = false;
//   Set<int> _selectedIndexes = {};
//   final _listOfItemsToDelete = ListOfItemsToRemove([]);
//
//   DetailsUserListsModel({required this.listId});
//
//   ScrollController get scrollController => _scrollController;
//   List<UserListResult> get listOfUserListDetails => List.unmodifiable(_listOfUserListDetails);
//   UserListDetails? get userListDetails => _userListDetails;
//   Set<int> get selectedIndexes => _selectedIndexes;
//
//   set selectedIndexes(Set<int> value) {
//     _selectedIndexes = value;
//     notifyListeners();
//   }
//
//   Future<void> loadContent() async {
//     if (_isListLoadingInProgress || _currentUserListPage >= _totalUserListPage) return;
//     _isListLoadingInProgress = true;
//     final nextPage = _currentUserListPage + 1;
//
//     try {
//       final userListDetails = await _accountApiClient.getUserListDetails(listId: listId, page: nextPage);
//
//       _userListDetails = userListDetails;
//
//       _listOfUserListDetails.addAll(userListDetails.results);
//       _currentUserListPage = userListDetails.page;
//       _totalUserListPage = userListDetails.totalPages;
//       _isListLoadingInProgress = false;
//
//       notifyListeners();
//     } catch (e) {
//       _isListLoadingInProgress = false;
//     }
//   }
//
//   void resetList() {
//     _currentUserListPage = 0;
//     _totalUserListPage = 1;
//     _listOfUserListDetails.clear();
//   }
//
//   void onMediaDetailsScreen(BuildContext context, UserListResult userListResults) {
//     if(userListResults.mediaType == "movie") {
//       Navigator.of(context).pushNamed(
//           MainNavigationRouteNames.movieDetails,
//           arguments: userListResults.id
//       );
//     } else {
//       Navigator.of(context).pushNamed(
//           MainNavigationRouteNames.tvShowDetails,
//           arguments: userListResults.id
//       );
//     }
//   }
//
//   void addItemToQueue(UserListResult userListResults) {
//     _listOfItemsToDelete.items.add(ItemToRemove(
//         userListResults.mediaType,
//         userListResults.id)
//     );
//   }
//
//   void removeItemFromQueue(UserListResult userListResults) {
//     _listOfItemsToDelete.items.removeWhere((e) =>
//     e.mediaId == userListResults.id && e.mediaType == userListResults.mediaType);
//   }
//
//   Future<void> removeItems() async {
//     await _accountApiClient.removeItems(listId, _listOfItemsToDelete);
//     _listOfItemsToDelete.items.clear();
//     _selectedIndexes.clear();
//     resetList();
//     await loadContent();
//     EventHelper.eventBus.fire(ListUpdateEvent(
//         listId,
//         userListDetails?.itemCount ?? 0
//     ));
//
//     notifyListeners();
//   }
// }
