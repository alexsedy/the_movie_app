import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

enum ListType {
  favorites, watchlist, rated, recommendations
}

class DefaultListsViewModel extends ChangeNotifier {
  final ListType listType;
  final IAccountRepository _accountRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  final _movieScrollController = ScrollController();
  final _tvScrollController = ScrollController();
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  int _movieCurrentPage = 0;
  int _movieTotalPage = 1;
  int _tvCurrentPage = 0;
  int _tvTotalPage = 1;
  var _isMovieLoadingInProgress = false;
  var _isTvShowLoadingInProgress = false;
  final _movieStatuses = <HiveMovies>[];
  final _tvShowStatuses = <HiveTvShow>[];
  StreamSubscription? _subscription;
  bool _initialLoadWatchlistComplete = false;
  String? _errorMessage;

  ScrollController get movieScrollController => _movieScrollController;
  ScrollController get tvScrollController => _tvScrollController;
  List<MediaList> get tvs => List.unmodifiable(_tvs);
  List<MediaList> get movies => List.unmodifiable(_movies);
  List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);
  List<HiveTvShow> get tvShowStatuses => List.unmodifiable(_tvShowStatuses);
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;
  bool get isTvShowLoadingInProgress => _isTvShowLoadingInProgress;
  bool get isWatchlistLoading => listType == ListType.watchlist && !_initialLoadWatchlistComplete;


  DefaultListsViewModel(this.listType,
      this._accountRepository,
      this._localMediaTrackingService) {
    _initialize();
  }

  void _initialize() {
    if (listType == ListType.watchlist) {
      fetchAllMediaData();
      _subscribeToEvents();
    } else {
      loadMovies();
      loadTvShows();
    }
  }

  Future<void> loadMovies() async {
    if (listType == ListType.watchlist || _isMovieLoadingInProgress || _movieCurrentPage >= _movieTotalPage) return;

    _isMovieLoadingInProgress = true;
    notifyListeners();
    final nextPage = _movieCurrentPage + 1;

    try {
      final moviesResponse = await _accountRepository.getDefaultMovieLists(page: nextPage, listType: listType);
      _movies.addAll(moviesResponse.list);
      _movieCurrentPage = moviesResponse.page;
      _movieTotalPage = moviesResponse.totalPages;
    } catch (e) {
      print("Error loading default movies: $e");
      // TODO: Error handling
    } finally {
      _isMovieLoadingInProgress = false;
      notifyListeners();    }
  }

  Future<void> loadTvShows() async {
    if (listType == ListType.watchlist || _isTvShowLoadingInProgress || _tvCurrentPage >= _tvTotalPage) return;

    _isTvShowLoadingInProgress = true;
    notifyListeners();
    final nextPage = _tvCurrentPage + 1;

    try {
      final tvShowResponse = await _accountRepository.getDefaultTvShowLists(page: nextPage, listType: listType);
      _tvs.addAll(tvShowResponse.list);
      _tvCurrentPage = tvShowResponse.page;
      _tvTotalPage = tvShowResponse.totalPages;
    } catch (e) {
      print("Error loading default tv shows: $e");
      // TODO: Error handling
    } finally {
      _isTvShowLoadingInProgress = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllMediaData() async {
    if (listType != ListType.watchlist) return;

    _initialLoadWatchlistComplete = false;
    _isMovieLoadingInProgress = true;
    _isTvShowLoadingInProgress = true;
    notifyListeners();

    _movieCurrentPage = 0; _movieTotalPage = 1; _movies.clear();
    _tvCurrentPage = 0; _tvTotalPage = 1; _tvs.clear();

    try {
      await _getMovieStatuses();
      await _getTvShowStatuses();

      while (_movieCurrentPage < _movieTotalPage) {
        final nextPage = _movieCurrentPage + 1;
        final moviesResponse = await _accountRepository.getDefaultMovieLists(page: nextPage, listType: listType);

        _movies.addAll(moviesResponse.list);
        _movieCurrentPage = moviesResponse.page;
        _movieTotalPage = moviesResponse.totalPages;
      }
    } catch (e) {
      print('Error loading all watchlist movies: $e');
    } finally {
      _isMovieLoadingInProgress = false;
      // notifyListeners();
    }

    try {
      while (_tvCurrentPage < _tvTotalPage) {
        final nextPage = _tvCurrentPage + 1;
        final tvsResponse = await _accountRepository.getDefaultTvShowLists(page: nextPage, listType: listType);

        _tvs.addAll(tvsResponse.list);
        _tvCurrentPage = tvsResponse.page;
        _tvTotalPage = tvsResponse.totalPages;
      }
    } catch (e) {
      print('Error loading all watchlist tv shows: $e');
    } finally {
      _isTvShowLoadingInProgress = false;
      // notifyListeners();
    }

    _initialLoadWatchlistComplete = true;
    notifyListeners();
  }


  Future<void> _getMovieStatuses() async {
    _movieStatuses.clear();
    final movies = await _localMediaTrackingService.getAllMovies();
    _movieStatuses.addAll(movies);
  }

  Future<void> _getTvShowStatuses() async {
    _tvShowStatuses.clear();
    final tvShows = await _localMediaTrackingService.getAllTVShows();
    _tvShowStatuses.addAll(tvShows);
  }

  void _subscribeToEvents() {
    if (listType == ListType.watchlist) {
      _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
        if (event) {
          await fetchAllMediaData();
        }
      });
    }
  }

  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _tvScrollController.dispose();
    _movieScrollController.dispose();
    super.dispose();
  }
}