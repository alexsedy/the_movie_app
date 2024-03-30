import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/movie/movie_list/movie_list.dart';
import 'package:the_movie_app/domain/entity/tv_show/tv_show_list/tv_show_list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class DefaultListsModel extends ChangeNotifier {
  final ListType listType;
  final _accountApiClient = AccountApiClient();
  final _movies = <Movie>[];
  final _tvShows = <TvShow>[];
  late int _currentPage;
  late int _totalPage;
  var _isFirstLoadMovie = true;
  var _isFirstLoadTvShow = true;
  var _isMovieLoadingInProgress = false;
  var _isTvShowLoadingInProgress = false;
  final _dateFormat = DateFormat.yMMMMd();

  DefaultListsModel(this.listType);

  bool get isLoadingInProgress => _isMovieLoadingInProgress;
  bool get isTvShowLoadingInProgress => _isTvShowLoadingInProgress;
  List<Movie> get movies => List.unmodifiable(_movies);
  List<TvShow> get tvShows => List.unmodifiable(_tvShows);

  Future<void> firstLoadMovies() async {
    if(_isFirstLoadMovie) {
      _currentPage = 0;
      _totalPage = 1;
      loadMovies();
      _isFirstLoadMovie = false;
    }
  }

  Future<void> loadMovies() async {
    if (_isMovieLoadingInProgress || _currentPage >= _totalPage) return;
    _isMovieLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);

      _movies.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isMovieLoadingInProgress = false;

      notifyListeners();
    } catch (e) {
      _isMovieLoadingInProgress = false;
    }
  }

  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _currentPage = 0;
      _totalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  Future<void> loadTvShows() async {
    if (_isTvShowLoadingInProgress || _currentPage >= _totalPage) return;
    _isTvShowLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final tvShowResponse = await _accountApiClient.getDefaultTvShowLists(page: nextPage, listType: listType);

      _tvShows.addAll(tvShowResponse.tvShows);
      _currentPage = tvShowResponse.page;
      _totalPage = tvShowResponse.totalPages;
      _isTvShowLoadingInProgress = false;

      notifyListeners();
    } catch (e) {
      _isTvShowLoadingInProgress = false;
    }
  }

  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  void preLoadTvShows(int index) {
    if (index < _tvShows.length - 1) return;
    loadTvShows();
  }

  void onTvShowTab(BuildContext context, int index) {
    final id = _tvShows[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onMovieTab(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

}

enum ListType {
  favorites, watchlist, rated, recommendations
}