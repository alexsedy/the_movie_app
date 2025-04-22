import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_update_event_bus.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_user_lists_model.dart';

class UserListsViewModel extends ChangeNotifier implements IBaseUserListsModel {
  final IAccountRepository _accountRepository;

  final _lists = <Lists>[];
  int _currentPage = 0;
  int _totalPage = 1;
  bool _isLoading = false;
  StreamSubscription? _eventBusSubscription;
  int _listIndex = -1;

  List<Lists> get lists => List.unmodifiable(_lists);
  bool get isLoading => _isLoading;
  int get listIndex => _listIndex;

  set listIndex(int value) => _listIndex = value;

  UserListsViewModel(this._accountRepository) {
    _initialize();
  }

  void _initialize() {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventBusSubscription = EventHelper.eventBus.on<ListUpdateEvent>().listen((event) {
      final index = _lists.indexWhere((list) => list.id == event.listId);
      if (index != -1) {
        _lists[index].numberOfItems = event.newCount;
        notifyListeners();
      }
    });
  }

  @override
  Future<void> getAllUserLists(BuildContext context) async {
    if (_lists.isEmpty && !_isLoading) {
      _isLoading = true;
      // notifyListeners();

      _currentPage = 0;
      _totalPage = 1;
      _lists.clear();

      try {
        await _getUserListsRecursive();
      } catch(e) {
        print("Error during getAllUserLists process: $e");
        //TODO show an error
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _getUserListsRecursive() async {
    if (_currentPage >= _totalPage) return;

    final nextPage = _currentPage + 1;
    final userListsResponse = await _accountRepository.getUserLists(nextPage);

    if (hasListeners) {
      _lists.addAll(userListsResponse.results);
      _currentPage = userListsResponse.page;
      _totalPage = userListsResponse.totalPages;
      notifyListeners();
      await _getUserListsRecursive();
    }
  }

  @override
  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public}) async {
    try {
      await _accountRepository.addNewList(description: description, name: name, public: public);
      SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.listCreatedMessage(name));
      Navigator.of(context).pop(); // Закрываем диалог/sheet

      _lists.clear();

    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch(e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      notifyListeners();
    }
  }

  Future<void> removeList({required BuildContext context, required int index}) async {
    if (index < 0 || index >= _lists.length) return;
    final listToRemove = _lists[index];

    try {
      final success = await _accountRepository.removeList(listToRemove.id);
      if (success) {
        SnackBarMessageHandler.showSuccessSnackBar(
            context: context,
            message: "List \"${listToRemove.name}\" removed." // TODO: Localize
        );
        _lists.removeAt(index);
        Navigator.pop(context);
      } else {
        throw Exception("Failed to remove list");
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateList({
    required BuildContext context,
    required String? description,
    required String name,
    required bool public,
    required int index
  }) async {
    if (index < 0 || index >= _lists.length) return;
    final listToUpdate = _lists[index];

    try {
      final success = await _accountRepository.updateList(
        listId: listToUpdate.id,
        description: description,
        name: name,
        public: public,
      );
      if (success) {
        SnackBarMessageHandler.showSuccessSnackBar(
            context: context,
            message: "List \"${name}\" updated." // TODO: Localize
        );
        Navigator.of(context).pop();

        _lists.clear();
        await getAllUserLists(context);
      } else {
        throw Exception("Failed to update list");
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _listIndex = -1;
      notifyListeners();
    }
  }

  @override
  Future<void> addItemListToList({required BuildContext context, required int listId, required String name}) async {
    print("addItemListToList called in UserListsViewModel - should not happen");
  }

  void onUserListDetails(BuildContext context, int index) {
    final id = _lists[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.userListDetails, arguments: id);
  }

  void _handleApiClientException(ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
        break;
      default:
        SnackBarMessageHandler.showErrorSnackBar(context);
    }
  }

  @override
  void dispose() {
    _eventBusSubscription?.cancel();
    super.dispose();
  }
}