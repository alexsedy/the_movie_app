import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/data/repositories/i_search_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

mixin HomeSearchMovieModelMixin {
  final _movies = <MediaList>[];
  var _isMovieLoadingInProgress = false;
  int _movieCurrentPage = 0;
  int _movieTotalPage = 1;
  final ScrollController _movieScrollController = ScrollController();
  ScrollController get movieScrollController => _movieScrollController;
}

mixin HomeSearchTVModelMixin {
  final _tvs = <MediaList>[];
  var _isTvsLoadingInProgress = false;
  int _tvCurrentPage = 0;
  int _tvTotalPage = 1;
  final ScrollController _tvScrollController = ScrollController();
  ScrollController get tvScrollController => _tvScrollController;
}

mixin HomeSearchPersonModelMixin {
  final _persons = <TrendingPersonList>[];
  var _isPersonLoadingInProgress = false;
  int _personCurrentPage = 0;
  int _personTotalPage = 1;
  final ScrollController _personScrollController = ScrollController();
  ScrollController get personScrollController => _personScrollController;
}

mixin HomeSearchCollectionModelMixin {
  final _collections = <MediaCollections>[];
  var _isCollectionLoadingInProgress = false;
  int _collectionCurrentPage = 0;
  int _collectionTotalPage = 1;
  final ScrollController _collectionScrollController = ScrollController();
  ScrollController get collectionScrollController => _collectionScrollController;
}


class HomeSearchViewModel extends ChangeNotifier with
    HomeSearchMovieModelMixin, HomeSearchTVModelMixin,
    HomeSearchPersonModelMixin, HomeSearchCollectionModelMixin
{
  final ISearchRepository _searchRepository;
  final LocalMediaTrackingService _localMediaTrackingService;
  final int initialIndex;

  Timer? _searchDebounce;
  StreamSubscription? _eventSubscription;
  final _movieStatuses = <HiveMovies>[];
  final _tvShowStatuses = <HiveTvShow>[];
  bool _isDisposed = false;

  List<MediaList> get movies => List.unmodifiable(_movies);
  List<MediaList> get tvs => List.unmodifiable(_tvs);
  List<TrendingPersonList> get persons => List.unmodifiable(_persons);
  List<MediaCollections> get collections => List.unmodifiable(_collections);
  List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);
  List<HiveTvShow> get tvShowStatuses => List.unmodifiable(_tvShowStatuses);
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;
  bool get isTvsLoadingInProgress => _isTvsLoadingInProgress;
  bool get isPersonLoadingInProgress => _isPersonLoadingInProgress;
  bool get isCollectionLoadingInProgress => _isCollectionLoadingInProgress;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  HomeSearchViewModel(
      this.initialIndex,
      this._searchRepository,
      this._localMediaTrackingService,
      ) {
    _initialize();
  }

  void _initialize() {
    searchController.addListener(_onSearchChanged);
    _subscribeToEvents();
    if (searchController.text.trim().isNotEmpty) {
      loadAll(immediate: true);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
    });
  }

  void _onSearchChanged() {
    loadAll();
  }

  Future<void> loadAll({bool immediate = false}) async {
    _searchDebounce?.cancel();
    final query = searchController.text.trim();

    if (query.isEmpty) {
      if (_movies.isNotEmpty || _tvs.isNotEmpty || _persons.isNotEmpty || _collections.isNotEmpty) {
        clearAll();
      }
      return;
    }

    final duration = immediate ? Duration.zero : const Duration(milliseconds: 500);
    _searchDebounce = Timer(duration, () async {
      clearAll();
      await Future.wait([
        _getMovieStatuses(),
        _getTvShowStatuses(),
        loadMovies(),
        loadTvShows(),
        loadPersons(),
        loadCollections(),
      ]);
    });
  }

  Future<void> loadMovies() async {
    final query = searchController.text.trim();
    if (query.isEmpty || _isMovieLoadingInProgress || _movieCurrentPage >= _movieTotalPage) return;

    _isMovieLoadingInProgress = true;
    notifyListeners();
    final nextPage = _movieCurrentPage + 1;

    try {
      final moviesResponse = await _searchRepository.getSearchMovies(query: query, page: nextPage);
      _movies.addAll(moviesResponse.list);
      _movieCurrentPage = moviesResponse.page;
      _movieTotalPage = moviesResponse.totalPages;
    } catch (e) {
      print("Error searching movies: $e");
      // TODO: Error handling
    } finally {
      if(!_isDisposed) {
        _isMovieLoadingInProgress = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadTvShows() async {
    final query = searchController.text.trim();
    if (query.isEmpty || _isTvsLoadingInProgress || _tvCurrentPage >= _tvTotalPage) return;

    _isTvsLoadingInProgress = true;
    notifyListeners();
    final nextPage = _tvCurrentPage + 1;

    try {
      final tvResponse = await _searchRepository.getSearchTvs(query: query, page: nextPage);
      _tvs.addAll(tvResponse.list);
      _tvCurrentPage = tvResponse.page;
      _tvTotalPage = tvResponse.totalPages;
    } catch (e) {
      print("Error searching tv shows: $e");
      // TODO: Error handling
    } finally {
      if(!_isDisposed) {
        _isTvsLoadingInProgress = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadPersons() async {
    final query = searchController.text.trim();
    if (query.isEmpty || _isPersonLoadingInProgress || _personCurrentPage >= _personTotalPage) return;

    _isPersonLoadingInProgress = true;
    notifyListeners();
    final nextPage = _personCurrentPage + 1;

    try {
      final personsResponse = await _searchRepository.getSearchPersons(query: query, page: nextPage);
      _persons.addAll(personsResponse.trendingPersonList);
      _personCurrentPage = personsResponse.page;
      _personTotalPage = personsResponse.totalPages;
    } catch (e) {
      print("Error searching persons: $e");
      // TODO: Error handling
    } finally {
      if(!_isDisposed) {
        _isPersonLoadingInProgress = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadCollections() async {
    final query = searchController.text.trim();
    if (query.isEmpty || _isCollectionLoadingInProgress || _collectionCurrentPage >= _collectionTotalPage) return;

    _isCollectionLoadingInProgress = true;
    notifyListeners();
    final nextPage = _collectionCurrentPage + 1;

    try {
      final collectionsResponse = await _searchRepository.getSearchMediaCollections(query: query, page: nextPage);
      _collections.addAll(collectionsResponse.results);
      _collectionCurrentPage = collectionsResponse.page;
      _collectionTotalPage = collectionsResponse.totalPages;
    } catch (e) {
      print("Error searching collections: $e");
      // TODO: Error handling
    } finally {
      if(!_isDisposed) {
        _isCollectionLoadingInProgress = false;
        notifyListeners();
      }
    }
  }

  void clearAll() {
    _movies.clear();
    _tvs.clear();
    _persons.clear();
    _collections.clear();
    _movieCurrentPage = 0; _movieTotalPage = 1;
    _tvCurrentPage = 0; _tvTotalPage = 1;
    _personCurrentPage = 0; _personTotalPage = 1;
    _collectionCurrentPage = 0; _collectionTotalPage = 1;
    _isMovieLoadingInProgress = false;
    _isTvsLoadingInProgress = false;
    _isPersonLoadingInProgress = false;
    _isCollectionLoadingInProgress = false;
    notifyListeners();
  }

  Future<void> _getMovieStatuses() async {
    _movieStatuses.clear();
    final movies = await _localMediaTrackingService.getAllMovies();
    if (!_isDisposed) {
      _movieStatuses.addAll(movies);
      // notifyListeners();
    }
  }

  Future<void> _getTvShowStatuses() async {
    _tvShowStatuses.clear();
    final tvShows = await _localMediaTrackingService.getAllTVShows();
    if (!_isDisposed) {
      _tvShowStatuses.addAll(tvShows);
      // notifyListeners();
    }
  }

  void _subscribeToEvents() {
    _eventSubscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event && !_isDisposed) {
        await _getMovieStatuses();
        await _getTvShowStatuses();
        notifyListeners();
      }
    });
  }

  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _persons[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onCollectionScreen(BuildContext context, int index) {
    final id = _collections[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.collection, arguments: id);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchDebounce?.cancel();
    _eventSubscription?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    _movieScrollController.dispose();
    _tvScrollController.dispose();
    _personScrollController.dispose();
    _collectionScrollController.dispose();
    super.dispose();
  }
}