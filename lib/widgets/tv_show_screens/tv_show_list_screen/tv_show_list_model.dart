import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/tv_show/tv_show_list/tv_show_list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class TvShowListModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final _apiClient = TvShowApiClient();
  final _tvShows = <TvShow>[];
  late int _currentPage;
  late int _totalPage;
  late String _locale;
  var _isFirstLoadTvShow = true;
  var _isLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();
  Timer? _searchDebounce;

  bool get isLoadingInProgress => _isLoadingInProgress;
  List<TvShow> get tvShows => List.unmodifiable(_tvShows);

  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _currentPage = 0;
      _totalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  Future<void> loadTvShows() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final tvShowResponse = await _apiClient.getDiscoverTvShow(nextPage);
      _tvShows.addAll(tvShowResponse.tvShows);
      _currentPage = tvShowResponse.page;
      _totalPage = tvShowResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  Future<void> searchTvShows(String text) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if(text.isEmpty) {
        resetList();
        loadTvShows();
      }
      resetList();
      if (_isLoadingInProgress || _currentPage >= _totalPage) return;
      _isLoadingInProgress = true;
      final nextPage = _currentPage + 1;

      try {
        final tvShowsResponse = await _apiClient.searchTvShow(nextPage, text);
        _tvShows.addAll(tvShowsResponse.tvShows);
        _currentPage = tvShowsResponse.page;
        _totalPage = tvShowsResponse.totalPages;
        _isLoadingInProgress = false;
        notifyListeners();
      } catch (e) {
        _isLoadingInProgress = false;
      }
    });
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _tvShows.clear();
  }

  void onTvShowTab(BuildContext context, int index) {
    final id = _tvShows[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
  }

  void preLoadTvShows(int index) {
    if (index < _tvShows.length - 1) return;
    loadTvShows();
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void closeSearch() {
    resetList();
    loadTvShows();
    scrollToTop();
  }
}