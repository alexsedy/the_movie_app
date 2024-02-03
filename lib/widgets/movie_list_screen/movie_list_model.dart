import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/movie/movie.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  int _currentPage = 0;
  int _totalPage = 1;
  var _isLoadingInProgress = false;

  late String _locale;
  final _dateFormat = DateFormat.yMMMMd();

  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);

  // Future<void> loadMovies() async {
  //
  //   final nextPage = _currentPage++;
  //   final moviesResponse = await _apiClient.getDiscoverMovie(nextPage);
  //   _currentPage = moviesResponse.page;
  //   _movies.addAll(moviesResponse.movies);
  //   notifyListeners();
  // }

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
}