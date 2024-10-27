import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

import 'list_update_event_bus.dart';

class UserListsModel extends ChangeNotifier {
  final _accountApiClient = AccountApiClient();
  UserLists? _userLists;
  final _lists = <Lists>[];
  late int _currentPage;
  late int _totalPage;
  final _dateFormat = DateFormat.yMMMMd();
  List<Lists> get lists => List.unmodifiable(_lists);
  StreamSubscription? _subscription;

  UserListsModel() {
    _subscription = ListUpdateEventBus().onListUpdate.listen((event) {
      final index = _lists.indexWhere((list) => list.id == event.listId);
      if (index != -1) {
        _lists[index].numberOfItems = event.newCount;
        notifyListeners();
      }
    });
  }

  Future<void> getAllUserLists(BuildContext context) async {
    if (lists.isEmpty) {
      _currentPage = 0;
      _totalPage = 1;

      // while (_currentPage < _totalPage) {
      // await getUserLists();
      // }

      await SnackBarHelper.handleErrorForUserLists(
        apiReq: () => _getUserLists(),
        context: context,
      );
    }
  }

  Future<void> _getUserLists() async {
    if (_currentPage >= _totalPage) return;

    final nextPage = _currentPage + 1;

    final userLists = await _accountApiClient.getUserLists(nextPage);
    _lists.addAll(userLists.results);
    _currentPage = userLists.page;
    _totalPage = userLists.totalPages;
    await _getUserLists();
  }

  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public}) async {
    await SnackBarHelper.handleErrorWithMessage(
      apiReq: () =>  _accountApiClient.addNewList(description: description, name: name, public: public),
      context: context,
      message: name,
      messageType: MessageType.listCreated,
    );

    _lists.clear();
    notifyListeners();
  }

  void onUserListDetails(BuildContext context, int index) {
    final id = _lists[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.userListDetails, arguments: id);
  }

  String formatDate(String? date) {
    try {
      return _dateFormat.format(DateTime.parse(date ?? ""));
    } catch (_) {
      return "";
    }
  }
}