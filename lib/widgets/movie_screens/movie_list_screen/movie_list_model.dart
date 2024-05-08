import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_details_model/media_filter_mixin.dart';
import 'package:the_movie_app/models/media_list_model/movie_list_model_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier with MovieListModelMixin, MediaFilterMixin {
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

  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  String? _genres;
  double _scoreStart = 0;
  double _scoreEnd = 10;
  static const _sortingDropdownItems = <String, String>{
    "popularity.desc": "Popularity Descending",
    "popularity.asc": "Popularity Ascending",
    "vote_average.desc": "Rating Descending",
    "vote_average.asc": "Rating Ascending",
    "primary_release_date.desc": "Release Date Descending",
    "primary_release_date.asc": "Release Date Ascending",
    "title.asc": "Title (A-Z)",
    "title.desc": "Title (Z-A)",
  };
  String _sortingValue = "popularity.desc";

  @override
  Map<String, String> get sortingDropdownItems => _sortingDropdownItems;
  @override
  DateTime? get selectedDateStart => _selectedDateStart;
  @override
  DateTime? get selectedDateEnd => _selectedDateEnd;
  @override
  String? get genres => _genres;
  @override
  double get scoreStart => _scoreStart;
  @override
  double get scoreEnd => _scoreEnd;
  @override
  String get sortingValue => _sortingValue;

  @override
  set selectedDateStart(value) {
    _selectedDateStart = value;
  }
  @override
  set selectedDateEnd(value) {
    _selectedDateEnd = value;
  }
  @override
  set genres(value) {
    _genres = value;
  }
  @override
  set scoreStart(value) {
    _scoreStart = value;
  }
  @override
  set scoreEnd(value) {
    _scoreEnd = value;
  }
  @override
  set sortingValue(value) {
    _sortingValue = value;
  }

  @override
  List<MediaList> get movies => List.unmodifiable(_movies);

  @override
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  Future<void> filterMovie() async {
    resetList();
    if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
    _isMovieLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    String? startDate;
    String? endDate;

    if(_selectedDateStart != null) {
      startDate = _selectedDateStart.toString().substring(0,10);
    }
    if(_selectedDateEnd != null) {
      endDate = _selectedDateEnd.toString().substring(0,10);
    }

    try {
      final moviesResponse = await _apiClient.getMovieWithFilter(
        page: nextPage,
        genres: "",
        releaseDateStart: startDate,
        releaseDateEnd: endDate,
        sortBy: _sortingValue,
        voteStart: _scoreStart,
        voteEnd: _scoreEnd,
      );
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
  bool isFiltered() {
    if(_selectedDateStart != null || _selectedDateEnd != null ||
        _genres != null || _scoreStart != 0 || _scoreEnd != 10 ||
        _sortingValue != "popularity.desc") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void clearAllFilters() {
    _selectedDateStart = null;
    _selectedDateEnd = null;
    _genres = null;
    _sortingValue = "popularity.desc";
    _scoreStart = 0;
    _scoreEnd = 10;
    resetList();
    loadMovies();
    scrollToTop();
    notifyListeners();
  }

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

mixin MovieListModelMixin {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  final genreActions = <String, Map<String, bool>>{
    "28": {'Action': false},
    "12": {'Adventure': false},
    "16": {'Animation': false},
    "35": {'Comedy': false},
    "80": {'Crime': false},
    "99": {'Documentary': false},
    "18": {'Drama': false},
    "10751": {'Family': false},
    "14": {'Fantasy': false},
    "36": {'History': false},
    "27": {'Horror': false},
    "10402": {'Music': false},
    "9648": {'Mystery': false},
    "10749": {'Romance': false},
    "878": {'Science Fiction': false},
    "10770": {'TV Movie': false},
    "53": {'Thriller': false},
    "10752": {'War': false},
    "37": {'Western': false},
  };
  String? _genres;
  double _scoreStart = 0;
  double _scoreEnd = 10;
  static const _sortingDropdownItems = <String, String>{
    "popularity.desc": "Popularity Descending",
    "popularity.asc": "Popularity Ascending",
    "vote_average.desc": "Rating Descending",
    "vote_average.asc": "Rating Ascending",
    "primary_release_date.desc": "Release Date Descending",
    "primary_release_date.asc": "Release Date Ascending",
    "title.asc": "Title (A-Z)",
    "title.desc": "Title (Z-A)",
  };
  String _sortingValue = "popularity.desc";

  Map<String, String> get sortingDropdownItems => _sortingDropdownItems;
  DateTime? get selectedDateStart => _selectedDateStart;
  DateTime? get selectedDateEnd => _selectedDateEnd;
  String? get genres => _genres;
  double get scoreStart => _scoreStart;
  double get scoreEnd => _scoreEnd;
  String get sortingValue => _sortingValue;

  set selectedDateStart(value) {
    _selectedDateStart = value;
  }
  set selectedDateEnd(value) {
    _selectedDateEnd = value;
  }
  set genres(value) {
    _genres = value;
  }
  set scoreStart(value) {
    _scoreStart = value;
  }
  set scoreEnd(value) {
    _scoreEnd = value;
  }
  set sortingValue(value) {
    _sortingValue = value;
  }


  Future<void> filterMovie();

  bool isFiltered() {
    if(_selectedDateStart != null || _selectedDateEnd != null ||
        _genres != null || _scoreStart != 0 || _scoreEnd != 10 ||
        _sortingValue != "popularity.desc") {
      return true;
    } else {
      return false;
    }
  }

  void clearAllFilters() {
    _selectedDateStart = null;
    _selectedDateEnd = null;
    _genres = null;
    _sortingValue = "popularity.desc";
    _scoreStart = 0;
    _scoreEnd = 10;
  }
}