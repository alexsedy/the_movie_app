import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';
import 'package:the_movie_app/domain/entity/tv_show/details/tv_show_details.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';


class TvShowDetailsModel extends ChangeNotifier {
  final _apiClient = TvShowApiClient();
  final _accountApiClient = AccountApiClient();
  TvShowDetails? _tvShowDetails;
  ItemState? _tvShowState;
  AccountSate? _accountSate;
  final int _seriesId;
  final _lists = <Lists>[];
  final _dateFormat = DateFormat.yMMMMd();
  final _dateFormatTwo = DateFormat.yMMMd();
  bool _isFavorite = false;
  bool _isWatched = false;
  bool _isRated = false;
  double _rate = 0;
  late int _currentPage;
  late int _totalPage;

  TvShowDetails? get tvShowDetails => _tvShowDetails;
  ItemState? get tvShowState => _tvShowState;
  List<Lists> get lists => List.unmodifiable(_lists);
  bool get isFavorite => _isFavorite;
  bool get isWatched => _isWatched;
  bool get isRated => _isRated;
  double get rate => _rate;

  set rate(value) => _rate = value;

  TvShowDetailsModel(this._seriesId);

  Future<void> loadTvShowDetails() async {
    _tvShowDetails = await _apiClient.getTvShowById(_seriesId);
    _tvShowState = await _apiClient.getTvShowState(_seriesId);
    
    if(_tvShowState != null) {
      _isFavorite = _tvShowState?.favorite ?? false;
      _isWatched = _tvShowState?.watchlist ?? false;

      final rated = _tvShowState?.rated;
      if(rated != null) {
        _rate = rated.value ?? 0;
        _isRated = true;
      }
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final result = await SnackBarHelper.handleErrorDefaultLists(
      apiReq: () => _apiClient.makeFavorite(tvShowId: _seriesId, isFavorite: !_isFavorite,),
      context: context,
    );
    if(result) {
      _isFavorite = !_isFavorite;
      notifyListeners();
    }
  }

  Future<void> toggleWatchlist(BuildContext context) async {
    final result = await SnackBarHelper.handleErrorDefaultLists(
      apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: !_isWatched,),
      context: context,
    );
    if(result) {
      _isWatched = !_isWatched;
      notifyListeners();
    }
  }

  Future<void> toggleAddRating(BuildContext context, double rate) async {
    final result = await SnackBarHelper.handleErrorDefaultLists(
      apiReq: () => _apiClient.addRating(tvShowId: _seriesId, rate: rate),
      context: context,
    );
    if(result && _isRated == false) {
      _isRated = !_isRated;
      notifyListeners();
    }
  }

  Future<void> toggleDeleteRating(BuildContext context) async {
    if(_isRated) {
      final result = await SnackBarHelper.handleErrorDefaultLists(
        apiReq: () => _apiClient.deleteRating(tvShowId: _seriesId),
        context: context,
      );
      if (result) {
        _isRated = !_isRated;
        _rate = 0.0;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text("The rating was deleted successfully.",
            style: TextStyle(fontSize: 20),),
        ));
      }
    }
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

  Future<void> addItemListToList({required BuildContext context, required int listId, required String name}) async {
    //todo find best solution
    final isSuccess = await _accountApiClient.isAddedToListToList(listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId);

    if(isSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text("This tv show already exists on the \"$name\" list.", style: const TextStyle(fontSize: 20),),)
      );
    } else {
      await SnackBarHelper.handleErrorWithMessage(
        apiReq: () =>
            _accountApiClient.addItemListToList(
                listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId),
        context: context,
        message: name,
        messageType: MessageType.tvShowAddedToList,
      );

      _lists.clear();
      notifyListeners();
    }
  }

  void onCastListTab(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListTab(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsTab(BuildContext context, int index) {
    final id = _tvShowDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  Future<void> launchYouTubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "";


  String formatDateTwo(String? date) =>
      date != "" ? _dateFormatTwo.format(DateTime.parse(date ?? "")) : "";
}