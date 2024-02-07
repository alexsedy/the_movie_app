import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/movie/movie.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  late int _currentPage;
  late int _totalPage;
  late String _locale;
  var _isFirstLoadMovie = true;
  var _isLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();
  Timer? _searchDebounce;

  get isLoadingInProgress => _isLoadingInProgress;
  get movies => List.unmodifiable(_movies);

  Future<void> firstLoadMovies() async {
    if(_isFirstLoadMovie) {
      _currentPage = 0;
      _totalPage = 1;
      loadMovies();
      _isFirstLoadMovie = false;
    }
  }

  Future<void> loadMovies() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final moviesResponse = await _apiClient.getDiscoverMovie(nextPage);
      _movies.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  Future<void> searchMovies(String text) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if(text.isEmpty) {
        resetList();
        loadMovies();
      }
      resetList();
      if (_isLoadingInProgress || _currentPage >= _totalPage) return;
      _isLoadingInProgress = true;
      final nextPage = _currentPage + 1;

      try {
        final moviesResponse = await _apiClient.searchMovie(nextPage, text);
        _movies.addAll(moviesResponse.movies);
        _currentPage = moviesResponse.page;
        _totalPage = moviesResponse.totalPages;
        _isLoadingInProgress = false;
        notifyListeners();
      } catch (e) {
        _isLoadingInProgress = false;
      }
    });
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
  }

  void onMovieTab(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
  }

  // void setupLoadMovies(BuildContext context) {
  //   _currentPage = 0;
  //   _totalPage = 1;
  //   _movies.clear();
  // }

  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}