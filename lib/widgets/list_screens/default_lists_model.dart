import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_list_model/movie_list_model_mixin.dart';
import 'package:the_movie_app/models/media_list_model/tv_list_model_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class DefaultListsModel extends ChangeNotifier with MovieListModelMixin, TvListModelMixin {
  final ListType listType;
  final ScrollController _scrollController = ScrollController();
  final _accountApiClient = AccountApiClient();
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  late int _currentPage;
  late int _totalPage;
  var _isFirstLoadMovie = true;
  var _isFirstLoadTvShow = true;
  var _isMovieLoadingInProgress = false;
  var _isTvShowLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();

  DefaultListsModel(this.listType);

  @override
  ScrollController get scrollController => _scrollController;

  @override
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;

  @override
  bool get isTvsLoadingInProgress => _isTvShowLoadingInProgress;

  @override
  List<MediaList> get movies => List.unmodifiable(_movies);

  @override
  List<MediaList> get tvs => List.unmodifiable(_tvs);

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
      final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);

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
  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _currentPage = 0;
      _totalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  @override
  Future<void> loadTvShows() async {
    if (_isTvShowLoadingInProgress || _currentPage >= _totalPage) return;
    _isTvShowLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final tvShowResponse = await _accountApiClient.getDefaultTvShowLists(page: nextPage, listType: listType);

      _tvs.addAll(tvShowResponse.list);
      _currentPage = tvShowResponse.page;
      _totalPage = tvShowResponse.totalPages;
      _isTvShowLoadingInProgress = false;

      notifyListeners();
    } catch (e) {
      _isTvShowLoadingInProgress = false;
    }
  }

  @override
  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  @override
  void preLoadTvShows(int index) {
    if (index < _tvs.length - 1) return;
    loadTvShows();
  }

  @override
  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  @override
  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

enum ListType {
  favorites, watchlist, rated, recommendations
}

// class DefaultListsModel extends ChangeNotifier implements BaseMediaListModel {
//   final ListType listType;
//   final ScrollController _scrollController = ScrollController();
//   final _accountApiClient = AccountApiClient();
//   final _movies = <MediaList>[];
//   final _tvs = <MediaList>[];
//   late int _currentPage;
//   late int _totalPage;
//   var _isFirstLoadMovie = true;
//   var _isFirstLoadTvShow = true;
//   var _isMovieLoadingInProgress = false;
//   var _isTvShowLoadingInProgress = false;
//   final _dateFormat = DateFormat.yMMMMd();
//   String? _element;
//   static const String movie = "movie";
//   static const String tv = "tv";
//
//   DefaultListsModel(this.listType);
//
//   @override
//   ScrollController get scrollController => _scrollController;
//
//   @override
//   bool get isLoadingInProgress {
//     if(_element != null && _element == movie) {
//       return _isMovieLoadingInProgress;
//     } else if (_element == tv) {
//       return _isTvShowLoadingInProgress;
//     } else {
//       return false;
//     }
//   }
//
//   // @override
//   // bool get isTvsLoadingInProgress => _isTvShowLoadingInProgress;
//
//   @override
//   List<MediaList> get media => List.unmodifiable(_movies);
//
//   // @override
//   // List<MediaList> get tvs => List.unmodifiable(_tvs);
//
//   set element(value) => _element = value;
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
//       final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);
//
//       _movies.addAll(moviesResponse.list);
//       _currentPage = moviesResponse.page;
//       _totalPage = moviesResponse.totalPages;
//       _isMovieLoadingInProgress = false;
//
//       notifyListeners();
//     } catch (e) {
//       _isMovieLoadingInProgress = false;
//     }
//   }
//
//   // @override
//   // Future<void> firstLoadTvShows() async {
//   //   if(_isFirstLoadTvShow) {
//   //     _currentPage = 0;
//   //     _totalPage = 1;
//   //     loadTvShows();
//   //     _isFirstLoadTvShow = false;
//   //   }
//   // }
//   //
//   // @override
//   // Future<void> loadTvShows() async {
//   //   if (_isTvShowLoadingInProgress || _currentPage >= _totalPage) return;
//   //   _isTvShowLoadingInProgress = true;
//   //   final nextPage = _currentPage + 1;
//   //
//   //   try {
//   //     final tvShowResponse = await _accountApiClient.getDefaultTvShowLists(page: nextPage, listType: listType);
//   //
//   //     _tvs.addAll(tvShowResponse.list);
//   //     _currentPage = tvShowResponse.page;
//   //     _totalPage = tvShowResponse.totalPages;
//   //     _isTvShowLoadingInProgress = false;
//   //
//   //     notifyListeners();
//   //   } catch (e) {
//   //     _isTvShowLoadingInProgress = false;
//   //   }
//   // }
//
//   @override
//   void preLoadMedia(int index) {
//     if (index < _movies.length - 1) return;
//     loadMedia();
//   }
//
//   // @override
//   // void preLoadTvShows(int index) {
//   //   if (index < _tvs.length - 1) return;
//   //   loadTvShows();
//   // }
//
//   // @override
//   // void onTvShowScreen(BuildContext context, int index) {
//   //   final id = _tvs[index].id;
//   //   Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
//   // }
//
//   @override
//   void onMediaScreen(BuildContext context, int index) {
//     final id = _movies[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
//   }
//
//   @override
//   String formatDate(String? date) =>
//       date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";
// }
//
// enum ListType {
//   favorites, watchlist, rated, recommendations
// }