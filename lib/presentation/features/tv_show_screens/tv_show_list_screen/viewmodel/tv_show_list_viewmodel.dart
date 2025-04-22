import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_media_filter_model.dart';

class TvShowListViewModel extends ChangeNotifier with FilterTvShowListModelMixin {
  final ITvShowRepository _tvShowRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  final _scrollController = ScrollController();
  final _tvs = <MediaList>[];
  int _currentPage = 0;
  int _totalPage = 1;
  var _isLoadingInProgress = false;
  final _tvShowStatuses = <HiveTvShow>[];
  StreamSubscription? _subscription;

  List<MediaList> get tvs => List.unmodifiable(_tvs);
  ScrollController get scrollController => _scrollController;
  List<HiveTvShow> get tvShowStatuses => List.unmodifiable(_tvShowStatuses);
  bool get isLoadingInProgress => _isLoadingInProgress;

  TvShowListViewModel(this._tvShowRepository, this._localMediaTrackingService) {
    _initialize();
  }

  void _initialize() {
    loadContent();
    _subscribeToEvents();
  }

  @override
  Future<void> loadContent() async {
    debugPrint('loadContent called. isFiltered: ${isFiltered()}');
    _selectedGenres();
    if (isFiltered()) {
      await _loadFiltered();
    } else {
      await _loadTvShows();
    }
    if (_tvShowStatuses.isEmpty) {
      await _getTvShowStatuses();
    }
  }

  Future<void> _loadTvShows() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    // notifyListeners();
    debugPrint('Loading TV shows page: ${_currentPage + 1}');
    final nextPage = _currentPage + 1;

    try {
      final tvShowResponse = await _tvShowRepository.getDiscoverTvShow(nextPage);
      _tvs.addAll(tvShowResponse.list);
      _currentPage = tvShowResponse.page;
      _totalPage = tvShowResponse.totalPages;
      debugPrint('TV shows loaded: ${_tvs.length} items. Total pages: $_totalPage');
    } catch (e, stackTrace) {
      debugPrint('Error loading TV shows: $e\n$stackTrace');
    } finally {
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  Future<void> _loadFiltered() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    // notifyListeners();
    debugPrint('Loading filtered TV shows page: ${_currentPage + 1}');
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
      final tvResponse = await _tvShowRepository.getTvShowWithFilter(
        page: nextPage,
        genres: genres,
        releaseDateStart: startDate,
        releaseDateEnd: endDate,
        sortBy: sortingValue,
        voteStart: scoreStart,
        voteEnd: scoreEnd,
      );
      _tvs.addAll(tvResponse.list);
      _currentPage = tvResponse.page;
      _totalPage = tvResponse.totalPages;
      debugPrint('Filtered TV shows loaded: ${_tvs.length} items. Total pages: $_totalPage');
    } catch (e, stackTrace) {
      debugPrint('Error loading filtered TV shows: $e\n$stackTrace');
    } finally {
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  Future<void> _getTvShowStatuses() async {
    debugPrint('Getting TV show statuses...');
    _tvShowStatuses.clear();
    final tvShows = await _localMediaTrackingService.getAllTVShows();
    _tvShowStatuses.addAll(tvShows);
    debugPrint('TV show statuses loaded: ${_tvShowStatuses.length} items.');
  }

  void _subscribeToEvents() {
    debugPrint('Subscribing to TV show status events...');
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event) {
        debugPrint('Received TV show status update event.');
        await _getTvShowStatuses();
        notifyListeners();
      }
    });
  }

  @override
  void clearAllFilters() {
    debugPrint('Clearing all TV show filters...');
    clearFilterValue();
    resetList();
    loadContent();
    scrollToTop();
    // notifyListeners();
  }

  @override
  void applyFilter() {
    debugPrint('Applying TV show filters...');
    scrollToTop();
    resetList();
    loadContent();
  }

  void resetList() {
    debugPrint('Resetting TV show list.');
    _currentPage = 0;
    _totalPage = 1;
    _tvs.clear();
    // notifyListeners();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      debugPrint('Scrolling TV show list to top.');
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onTvShowScreen(BuildContext context, int index) {
    if (index < 0 || index >= _tvs.length) return;
    final id = _tvs[index].id;
    debugPrint('Navigating to TV show details: $id');
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  @override
  void dispose() {
    debugPrint('Disposing TvShowListViewModel...');
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
    debugPrint('TvShowListViewModel disposed.');
  }
}

mixin FilterTvShowListModelMixin implements IMediaFilter {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  final _genreActions = <String, Map<String, bool>>{
    "10759": {'Action & Adventure': false}, "16": {'Animation': false},
    "35": {'Comedy': false}, "80": {'Crime': false}, "99": {'Documentary': false},
    "18": {'Drama': false}, "10751": {'Family': false}, "10762": {'Kids': false},
    "9648": {'Mystery': false}, "10763": {'News': false}, "10764": {'Reality': false},
    "10765": {'Sci-Fi & Fantasy': false}, "10766": {'Soap': false}, "10767": {'Talk': false},
    "10768": {'War & Politics': false}, "37": {'Western': false},
  };
  String? _genres;
  double _scoreStart = 0;
  double _scoreEnd = 10;
  static const _sortingDropdownItems = <String, String>{
    "popularity.desc": "Popularity Descending", "popularity.asc": "Popularity Ascending",
    "vote_average.desc": "Rating Descending", "vote_average.asc": "Rating Ascending",
    "primary_release_date.desc": "Release Date Descending", "primary_release_date.asc": "Release Date Ascending",
    "title.asc": "Title (A-Z)", "title.desc": "Title (Z-A)",
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
  set selectedDateStart(value) => _selectedDateStart = value;
  @override
  set selectedDateEnd(value) => _selectedDateEnd = value;
  @override
  set genres(value) => _genres = value;
  @override
  set scoreStart(value) => _scoreStart = value;
  @override
  set scoreEnd(value) => _scoreEnd = value;
  @override
  set sortingValue(value) => _sortingValue = value;

  @override
  bool isFiltered() {
    return _selectedDateStart != null || _selectedDateEnd != null ||
        _genres != null || _scoreStart != 0 || _scoreEnd != 10 ||
        _sortingValue != "popularity.desc";
  }

  @override
  Future<void> loadContent();
  @override
  void clearAllFilters();
  @override
  void applyFilter();

  void _selectedGenres() {
    final selectedGenres = <String>[];
    _genreActions.forEach((key, value) {
      if (value.values.first) selectedGenres.add(key);
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
