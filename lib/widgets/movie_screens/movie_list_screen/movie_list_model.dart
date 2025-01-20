import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/helpers/event_helper.dart';
import 'package:the_movie_app/models/interfaces/i_media_filter_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier with FilterMovieListModelMixin {
  final _scrollController = ScrollController();
  final _apiClient = MovieApiClient();
  final _movies = <MediaList>[];
  int _currentPage = 0;
  int _totalPage = 1;
  var _isMovieLoadingInProgress = false;
  final _movieStatuses = <HiveMovies>[];
  late final Future<void> _initMovieStatuses = _getMovieStatuses();
  StreamSubscription? _subscription;

  List<MediaList> get movies => List.unmodifiable(_movies);
  ScrollController get scrollController => _scrollController;
  List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);

  @override
  Future<void> loadContent() async {
    _selectedGenres();
    if(isFiltered()) {
      await _loadFiltered();
    } else {
      await _loadMovies();
    }

    await _initMovieStatuses;
  }

  Future<void> _loadMovies() async {
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

  Future<void> _loadFiltered() async {
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

    _selectedGenres();

    try {
      final moviesResponse = await _apiClient.getMovieWithFilter(
        page: nextPage,
        genres: _genres,
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

  Future<void> _getMovieStatuses() async {
    final localMediaTrackingService = LocalMediaTrackingService();
    final movies = await localMediaTrackingService.getAllMovies();
    _movieStatuses.addAll(movies);

    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if(event) {
        _movieStatuses.clear();
        final movies = await localMediaTrackingService.getAllMovies();
        _movieStatuses.addAll(movies);
        notifyListeners();
      }
    });
  }

  @override
  void clearAllFilters() {
    clearFilterValue();
    resetList();
    loadContent();
    scrollToTop();
    notifyListeners();
  }

  void clearFilterValue() {
    _resetGenres();
    _selectedDateStart = null;
    _selectedDateEnd = null;
    _genres = null;
    _sortingValue = "popularity.desc";
    _scoreStart = 0;
    _scoreEnd = 10;
  }

  void resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
  }

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

  @override
  void applyFilter() {
    scrollToTop();
    resetList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

mixin FilterMovieListModelMixin implements IMediaFilter {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  final _genreActions = <String, Map<String, bool>>{
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
  Map<String, Map<String, bool>> get genreActions => _genreActions;

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
  void clearAllFilters();

  void _selectedGenres() {
    final selectedGenres = <String>[];

    _genreActions.forEach((key, value) {
      if (value.values.first) {
        selectedGenres.add(key);
      }
    });

    final result = selectedGenres.join(',');

    if(selectedGenres.isEmpty) {
      _genres = null;
    } else {
      _genres = result;
    }
  }

  void _resetGenres() {
    genreActions.forEach((key, value) {
      value.forEach((innerKey, innerValue) {
        value[innerKey] = false;
      });
    });
  }

  @override
  void applyFilter();
}