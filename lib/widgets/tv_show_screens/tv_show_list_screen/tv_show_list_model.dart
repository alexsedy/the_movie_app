import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_list_model/base_media_list_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class TvShowListModel extends ChangeNotifier implements BaseMediaListModel {
  final ScrollController _scrollController = ScrollController();
  final _apiClient = TvShowApiClient();
  final _tvs = <MediaList>[];
  late int _currentPage;
  late int _totalPage;
  late String _locale;
  var _isFirstLoadTvShow = true;
  var _isTvsLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();
  Timer? _searchDebounce;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  List<MediaList> get tvs => List.unmodifiable(_tvs);

  @override
  bool get isTvsLoadingInProgress => _isTvsLoadingInProgress;

  @override
  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _currentPage = 0;
      _totalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  @override
  Future<void> loadTvShows() async {
    if (_isTvsLoadingInProgress || _currentPage >= _totalPage) return;
    _isTvsLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final tvShowResponse = await _apiClient.getDiscoverTvShow(nextPage);
      _tvs.addAll(tvShowResponse.list);
      _currentPage = tvShowResponse.page;
      _totalPage = tvShowResponse.totalPages;
      _isTvsLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isTvsLoadingInProgress = false;
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
      if (_isTvsLoadingInProgress || _currentPage >= _totalPage) return;
      _isTvsLoadingInProgress = true;
      final nextPage = _currentPage + 1;

      try {
        final tvShowsResponse = await _apiClient.searchTvShow(nextPage, text);
        _tvs.addAll(tvShowsResponse.list);
        _currentPage = tvShowsResponse.page;
        _totalPage = tvShowsResponse.totalPages;
        _isTvsLoadingInProgress = false;
        notifyListeners();
      } catch (e) {
        _isTvsLoadingInProgress = false;
      }
    });
  }

  @override
  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  @override
  void preLoadTvShows(int index) {
    if (index < _tvs.length - 1) return;
    loadTvShows();
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _tvs.clear();
  }

  void closeSearch() {
    resetList();
    loadTvShows();
    scrollToTop();
  }

  // void setupLocale(BuildContext context) {
  //   final locale = Localizations.localeOf(context);
  // }

  /// not used
  @override
  bool get isMovieLoadingInProgress => false;
  @override
  Future<void> loadMovies() async {}
  @override
  Future<void> firstLoadMovies() async {}
  @override
  void preLoadMovies(int index) {}
  @override
  List<MediaList> get movies => <MediaList>[];
  @override
  void onMovieScreen(BuildContext context, int index) {}
}

// class TvShowListModel extends ChangeNotifier implements BaseMediaListModel {
//   final ScrollController _scrollController = ScrollController();
//   final _apiClient = TvShowApiClient();
//   final _tvs = <MediaList>[];
//   late int _currentPage;
//   late int _totalPage;
//   late String _locale;
//   var _isFirstLoadTvShow = true;
//   var _isTvsLoadingInProgress = false;
//   final _dateFormat = DateFormat.yMMMMd();
//   Timer? _searchDebounce;
//
//   @override
//   ScrollController get scrollController => _scrollController;
//
//   @override
//   List<MediaList> get media => List.unmodifiable(_tvs);
//
//   @override
//   bool get isLoadingInProgress => _isTvsLoadingInProgress;
//
//   @override
//   Future<void> firstLoadMedia() async {
//     if(_isFirstLoadTvShow) {
//       _currentPage = 0;
//       _totalPage = 1;
//       loadMedia();
//       _isFirstLoadTvShow = false;
//     }
//   }
//
//   @override
//   String formatDate(String? date) =>
//       date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";
//
//   @override
//   Future<void> loadMedia() async {
//     if (_isTvsLoadingInProgress || _currentPage >= _totalPage) return;
//     _isTvsLoadingInProgress = true;
//     final nextPage = _currentPage + 1;
//
//     try {
//       final tvShowResponse = await _apiClient.getDiscoverTvShow(nextPage);
//       _tvs.addAll(tvShowResponse.list);
//       _currentPage = tvShowResponse.page;
//       _totalPage = tvShowResponse.totalPages;
//       _isTvsLoadingInProgress = false;
//       notifyListeners();
//     } catch (e) {
//       _isTvsLoadingInProgress = false;
//     }
//   }
//
//   Future<void> searchTvShows(String text) async {
//     _searchDebounce?.cancel();
//     _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
//       if(text.isEmpty) {
//         resetList();
//         loadMedia();
//       }
//       resetList();
//       if (_isTvsLoadingInProgress || _currentPage >= _totalPage) return;
//       _isTvsLoadingInProgress = true;
//       final nextPage = _currentPage + 1;
//
//       try {
//         final tvShowsResponse = await _apiClient.searchTvShow(nextPage, text);
//         _tvs.addAll(tvShowsResponse.list);
//         _currentPage = tvShowsResponse.page;
//         _totalPage = tvShowsResponse.totalPages;
//         _isTvsLoadingInProgress = false;
//         notifyListeners();
//       } catch (e) {
//         _isTvsLoadingInProgress = false;
//       }
//     });
//   }
//
//   @override
//   void onMediaScreen(BuildContext context, int index) {
//     final id = _tvs[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
//   }
//
//   @override
//   void preLoadMedia(int index) {
//     if (index < _tvs.length - 1) return;
//     loadMedia();
//   }
//
//   void scrollToTop() {
//     scrollController.animateTo(
//       0.0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Future<void> resetList() async {
//     _currentPage = 0;
//     _totalPage = 1;
//     _tvs.clear();
//   }
//
//   void closeSearch() {
//     resetList();
//     loadMedia();
//     scrollToTop();
//   }
//
// // void setupLocale(BuildContext context) {
// //   final locale = Localizations.localeOf(context);
// // }
//
// /// not used
// // @override
// // bool get isMovieLoadingInProgress => false;
// // @override
// // Future<void> loadMovies() async {}
// // @override
// // Future<void> firstLoadMovies() async {}
// // @override
// // void preLoadMovies(int index) {}
// // @override
// // List<MediaList> get movies => <MediaList>[];
// // @override
// // void onMovieScreen(BuildContext context, int index) {}
// }