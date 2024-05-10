import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_details_model/media_filter_model.dart';
import 'package:the_movie_app/models/media_list_model/tv_list_model_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class TvShowListModel extends ChangeNotifier with TvListModelMixin, FilterTvShowListModelMixin {
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
  Future<void> loadFiltered() async {
    resetList();
    if (_isTvsLoadingInProgress || _currentPage >= _totalPage) return;
    _isTvsLoadingInProgress = true;
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
      final moviesResponse = await _apiClient.getTvShowWithFilter(
        page: nextPage,
        genres: _genres,
        releaseDateStart: startDate,
        releaseDateEnd: endDate,
        sortBy: _sortingValue,
        voteStart: _scoreStart,
        voteEnd: _scoreEnd,
      );
      _tvs.addAll(moviesResponse.list);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isTvsLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isTvsLoadingInProgress = false;
    }
  }

  @override
  void clearAllFilters() {
    clearFilterValue();
    // resetList();
    // loadMovies();
    // scrollToTop();
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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

mixin FilterTvShowListModelMixin implements MediaFilter {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  final _genreActions = <String, Map<String, bool>>{
    "10759": {'Action & Adventure': false},
    "16": {'Animation': false},
    "35": {'Comedy': false},
    "80": {'Crime': false},
    "99": {'Documentary': false},
    "18": {'Drama': false},
    "10751": {'Family': false},
    "10762": {'Kids': false},
    "9648": {'Mystery': false},
    "10763": {'News': false},
    "10764": {'Reality': false},
    "10765": {'Sci-Fi & Fantasy': false},
    "10766": {'Soap': false},
    "10767": {'Talk': false},
    "10768": {'War & Politics': false},
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
  Future<void> loadFiltered();

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
}