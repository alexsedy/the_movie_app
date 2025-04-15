import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_media_filter_model.dart';

class MovieListViewModel extends ChangeNotifier with FilterMovieListModelMixin{
  final IMovieRepository _movieRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  final _scrollController = ScrollController();
  final _movies = <MediaList>[];
  int _currentPage = 0;
  int _totalPage = 1;
  var _isLoadingInProgress = false;
  final _movieStatuses = <HiveMovies>[];
  StreamSubscription? _subscription;

  List<MediaList> get movies => List.unmodifiable(_movies);
  ScrollController get scrollController => _scrollController;
  List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);
  bool get isLoadingInProgress => _isLoadingInProgress;

  MovieListViewModel(this._movieRepository, this._localMediaTrackingService) {
    _initialize();
  }

  void _initialize() {
    loadContent();
    _subscribeToEvents();
  }

  Future<void> loadContent() async {
    _selectedGenres();
    if (isFiltered()) {
      await _loadFiltered();
    } else {
      await _loadMovies();
    }
    if (_movieStatuses.isEmpty) {
      await _getMovieStatuses();
    }
  }

  Future<void> _loadMovies() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;

    final nextPage = _currentPage + 1;

    try {
      final moviesResponse = await _movieRepository.getDiscoverMovie(nextPage);
      _movies.addAll(moviesResponse.list);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
    } catch (e) {
      // TODO: Error handle
      print(e);
    } finally {
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  Future<void> _loadFiltered() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    // notifyListeners(); // Optional

    final nextPage = _currentPage + 1;
    String? startDate;
    String? endDate;

    if (selectedDateStart != null) {
      startDate = selectedDateStart.toString().substring(0, 10);
    }
    if (selectedDateEnd != null) {
      endDate = selectedDateEnd.toString().substring(0, 10);
    }

    try {
      final moviesResponse = await _movieRepository.getMovieWithFilter(
        page: nextPage,
        genres: genres,
        releaseDateStart: startDate,
        releaseDateEnd: endDate,
        sortBy: sortingValue,
        voteStart: scoreStart,
        voteEnd: scoreEnd,
      );
      _movies.addAll(moviesResponse.list);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
    } catch (e) {
      // TODO: Error handle
      print(e);
    } finally {
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  Future<void> _getMovieStatuses() async {
    _movieStatuses.clear();
    final movies = await _localMediaTrackingService.getAllMovies();
    _movieStatuses.addAll(movies);
    notifyListeners();
  }

  void _subscribeToEvents() {
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event) {
        await _getMovieStatuses();
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
  }

  @override
  void applyFilter() {
    scrollToTop();
    resetList();
  }

  void resetList() {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
  }

  void scrollToTop() {
    // Ensure the scroll controller has clients before animating.
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();
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
    return _selectedDateStart != null ||
        _selectedDateEnd != null ||
        _genres != null ||
        _scoreStart != 0 ||
        _scoreEnd != 10 ||
        _sortingValue != "popularity.desc";
  }

  @override
  void clearAllFilters();
  @override
  void applyFilter();

  void _selectedGenres() {
    final selectedGenres = <String>[];
    _genreActions.forEach((key, value) {
      if (value.values.first) {
        selectedGenres.add(key);
      }
    });
    _genres = selectedGenres.isEmpty ? null : selectedGenres.join(',');
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

  void _resetGenres() {
    _genreActions.forEach((key, value) {
      value[value.keys.first] = false;
    });
  }
}
