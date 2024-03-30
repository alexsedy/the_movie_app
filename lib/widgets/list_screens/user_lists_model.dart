import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/account/user_list_details/user_list_details.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class UserListsModel extends ChangeNotifier {
  final int? listId;
  final _accountApiClient = AccountApiClient();
  UserLists? _userLists;
  UserListDetails? _userListDetails;
  final _lists = <Lists>[];
  final _listOfUserListDetails = <Result>[];
  late int _currentPage;
  late int _totalPage;
  final _dateFormat = DateFormat.yMMMMd();
  var _isListLoadingInProgress = false;
  var _isLoadList = true;


  UserListsModel({this.listId});

  List<Lists> get lists => List.unmodifiable(_lists);
  List<Result> get listOfUserListDetails => List.unmodifiable(_listOfUserListDetails);
  bool get isListLoadingInProgress => _isListLoadingInProgress;
  UserListDetails? get userListDetails => _userListDetails;

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

  Future<void> firstLoadList() async {
    if(_isLoadList) {
      _currentPage = 0;
      _totalPage = 1;
      loadList();
      _isLoadList = false;
    }
  }

  Future<void> loadList() async {
    if (_isListLoadingInProgress || _currentPage >= _totalPage) return;
    _isListLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    // try {
      final userListDetails = await _accountApiClient.getUserListDetails(listId: listId ?? 0, page: nextPage);

      _userListDetails = userListDetails;

      _listOfUserListDetails.addAll(userListDetails.results);
      _currentPage = userListDetails.page;
      _totalPage = userListDetails.totalPages;
      _isListLoadingInProgress = false;

      notifyListeners();
    // } catch (e) {
    //   _isListLoadingInProgress = false;
    // }
  }

  void preLoadList(int index) {
    if (index < _listOfUserListDetails.length - 1) return;
    loadList();
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