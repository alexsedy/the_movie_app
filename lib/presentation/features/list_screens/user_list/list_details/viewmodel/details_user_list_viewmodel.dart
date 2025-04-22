import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/account/items_to_delete/remove_items.dart';
import 'package:the_movie_app/data/models/account/user_list_details/user_list_details.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_update_event_bus.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class DetailsUserListViewModel extends ChangeNotifier {
  final int _listId;
  final IAccountRepository _accountRepository;

  final _scrollController = ScrollController();
  final _listOfUserListDetails = <UserListResult>[];
  UserListDetails? _userListDetails;
  int _currentUserListPage = 0;
  int _totalUserListPage = 1;
  bool _isListLoadingInProgress = false;
  bool _isInitialLoading = true;
  String? _error;
  Set<int> _selectedIndexes = {};
  final ListOfItemsToRemove _listOfItemsToDelete = ListOfItemsToRemove([]);

  ScrollController get scrollController => _scrollController;
  List<UserListResult> get listOfUserListDetails => List.unmodifiable(_listOfUserListDetails);
  UserListDetails? get userListDetails => _userListDetails;
  bool get isInitialLoading => _isInitialLoading;
  bool get isListLoadingInProgress => _isListLoadingInProgress;
  String? get error => _error;
  Set<int> get selectedIndexes => _selectedIndexes;

  set selectedIndexes(Set<int> value) {
    _selectedIndexes = value;
    notifyListeners();
  }

  DetailsUserListViewModel(this._listId, this._accountRepository) {
    _initialize();
  }

  void _initialize() {
    loadContent();
  }

  Future<void> loadContent({bool refresh = false}) async {
    if (_isListLoadingInProgress || (!refresh && _currentUserListPage >= _totalUserListPage)) return;

    if (refresh) {
      _currentUserListPage = 0;
      _totalUserListPage = 1;
      _listOfUserListDetails.clear();
      _selectedIndexes.clear();
      _listOfItemsToDelete.items.clear();
      _isInitialLoading = true;
    } else {
      _isListLoadingInProgress = true;
    }
    _error = null;
    notifyListeners();

    final nextPage = _currentUserListPage + 1;

    try {
      final userListDetailsResponse = await _accountRepository.getUserListDetails(listId: _listId, page: nextPage);
      if (!_isDisposed) {
        if (_isInitialLoading || refresh) {
          _userListDetails = userListDetailsResponse;
        }
        _listOfUserListDetails.addAll(userListDetailsResponse.results);
        _currentUserListPage = userListDetailsResponse.page;
        _totalUserListPage = userListDetailsResponse.totalPages;
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = "Failed to load list details."; // TODO: Localize
        print("Error loading list details: $e");
        if (e is ApiClientException && e.type == ApiClientExceptionType.sessionExpired) {
          _error = "Session expired. Please login again."; // TODO: Localize
        }
      }
    } finally {
      if (!_isDisposed) {
        _isListLoadingInProgress = false;
        _isInitialLoading = false;
        notifyListeners();
      }
    }
  }

  void addItemToQueue(UserListResult userListResults) {
    _listOfItemsToDelete.items.add(ItemToRemove(
        userListResults.mediaType,
        userListResults.id)
    );
  }

  void removeItemFromQueue(UserListResult userListResults) {
    _listOfItemsToDelete.items.removeWhere((e) =>
    e.mediaId == userListResults.id && e.mediaType == userListResults.mediaType);
  }

  Future<void> removeItems() async {
    await _accountRepository.removeItems(_listId, _listOfItemsToDelete);
    _listOfItemsToDelete.items.clear();
    _selectedIndexes.clear();
    _resetList();
    await loadContent();
    EventHelper.eventBus.fire(ListUpdateEvent(
        _listId,
        userListDetails?.itemCount ?? 0
    ));

    notifyListeners();
  }

  void _resetList() {
    _currentUserListPage = 0;
    _totalUserListPage = 1;
    _listOfUserListDetails.clear();
  }

  void onMediaDetailsScreen(BuildContext context, UserListResult userListResults) {
    if (userListResults.mediaType == "movie") {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: userListResults.id);
    } else if (userListResults.mediaType == "tv") {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: userListResults.id);
    }
  }

  bool _isDisposed = false;
  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }
}