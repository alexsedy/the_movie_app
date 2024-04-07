import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_list_model/movie_list_model_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier with MovieListModelMixin {
  final ScrollController _scrollController = ScrollController();
  final _apiClient = MovieApiClient();
  final _movies = <MediaList>[];
  late int _currentPage;
  late int _totalPage;
  late String _locale;
  var _isFirstLoadMovie = true;
  var _isMovieLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();
  Timer? _searchDebounce;

  @override
  List<MediaList> get movies => List.unmodifiable(_movies);

  @override
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  Future<void> firstLoadMovies() async {
    if(_isFirstLoadMovie) {
      _currentPage = 0;
      _totalPage = 1;
      loadMovies();
      _isFirstLoadMovie = false;
    }
  }

  @override
  Future<void> loadMovies() async {
    if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
    _isMovieLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final moviesResponse = await _apiClient.getDiscoverMovie(nextPage);
      _movies.addAll(moviesResponse.list);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isMovieLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isMovieLoadingInProgress = false;
    }
  }

  @override
  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }


  Future<void> searchMovies(String text) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if(text.isEmpty) {
        resetList();
        loadMovies();
      }
      resetList();
      if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
      _isMovieLoadingInProgress = true;
      final nextPage = _currentPage + 1;

      try {
        final moviesResponse = await _apiClient.searchMovie(nextPage, text);
        _movies.addAll(moviesResponse.list);
        _currentPage = moviesResponse.page;
        _totalPage = moviesResponse.totalPages;
        _isMovieLoadingInProgress = false;
        notifyListeners();
      } catch (e) {
        _isMovieLoadingInProgress = false;
      }
    });
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
  }

  @override
  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void closeSearch() {
    resetList();
    loadMovies();
    scrollToTop();
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  // void setupLocale(BuildContext context) {
  //   final locale = Localizations.localeOf(context);
  // }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// class MovieListModel extends ChangeNotifier implements BaseMediaListModel {
//   final ScrollController _scrollController = ScrollController();
//   final _apiClient = MovieApiClient();
//   final _movies = <MediaList>[];
//   late int _currentPage;
//   late int _totalPage;
//   late String _locale;
//   var _isFirstLoadMovie = true;
//   var _isMovieLoadingInProgress = false;
//   final _dateFormat = DateFormat.yMMMMd();
//   Timer? _searchDebounce;
//
//   @override
//   List<MediaList> get media => List.unmodifiable(_movies);
//
//   @override
//   bool get isLoadingInProgress => _isMovieLoadingInProgress;
//
//   @override
//   ScrollController get scrollController => _scrollController;
//
//   @override
//   Future<void> firstLoadMedia() async {
//     if(_isFirstLoadMovie) {
//       _currentPage = 0;
//       _totalPage = 1;
//       loadMedia();
//       _isFirstLoadMovie = false;
//     }
//   }
//
//   @override
//   Future<void> loadMedia() async {
//     if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
//     _isMovieLoadingInProgress = true;
//     final nextPage = _currentPage + 1;
//
//     try {
//       final moviesResponse = await _apiClient.getDiscoverMovie(nextPage);
//       _movies.addAll(moviesResponse.list);
//       _currentPage = moviesResponse.page;
//       _totalPage = moviesResponse.totalPages;
//       _isMovieLoadingInProgress = false;
//       notifyListeners();
//     } catch (e) {
//       _isMovieLoadingInProgress = false;
//     }
//   }
//
//   @override
//   void preLoadMedia(int index) {
//     if (index < _movies.length - 1) return;
//     loadMedia();
//   }
//
//
//   Future<void> searchMovies(String text) async {
//     _searchDebounce?.cancel();
//     _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
//       if(text.isEmpty) {
//         resetList();
//         loadMedia();
//       }
//       resetList();
//       if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
//       _isMovieLoadingInProgress = true;
//       final nextPage = _currentPage + 1;
//
//       try {
//         final moviesResponse = await _apiClient.searchMovie(nextPage, text);
//         _movies.addAll(moviesResponse.list);
//         _currentPage = moviesResponse.page;
//         _totalPage = moviesResponse.totalPages;
//         _isMovieLoadingInProgress = false;
//         notifyListeners();
//       } catch (e) {
//         _isMovieLoadingInProgress = false;
//       }
//     });
//   }
//
//   Future<void> resetList() async {
//     _currentPage = 0;
//     _totalPage = 1;
//     _movies.clear();
//   }
//
//   @override
//   void onMediaScreen(BuildContext context, int index) {
//     final id = _movies[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
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
//   void closeSearch() {
//     resetList();
//     loadMedia();
//     scrollToTop();
//   }
//
//   @override
//   String formatDate(String? date) =>
//       date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";
//
// // void setupLocale(BuildContext context) {
// //   final locale = Localizations.localeOf(context);
// // }
//
// /// not used
// // @override
// // Future<void> firstLoadTvShows() async {}
// // @override
// // bool get isTvsLoadingInProgress => false;
// // @override
// // Future<void> loadTvShows() async {
// // }
// // @override
// // void onTvShowScreen(BuildContext context, int index) {}
// // @override
// // void preLoadTvShows(int index) {}
// // @override
// // List<MediaList> get tvs => <MediaList>[];
// }