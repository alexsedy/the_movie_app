import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class DefaultListsModel extends ChangeNotifier {
  final ListType listType;
  final ScrollController _scrollController = ScrollController();
  final _accountApiClient = AccountApiClient();
  int _movieCurrentPage = 0;
  int _movieTotalPage = 1;
  int _tvCurrentPage = 0;
  int _tvTotalPage = 1;
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  var _isMovieLoadingInProgress = false;
  var _isTvShowLoadingInProgress = false;

  DefaultListsModel(this.listType);

  ScrollController get scrollController => _scrollController;
  List<MediaList> get tvs => List.unmodifiable(_tvs);
  List<MediaList> get movies => List.unmodifiable(_movies);

  Future<void> loadMovies() async {
    if (_isMovieLoadingInProgress || _movieCurrentPage >= _movieTotalPage) return;
    _isMovieLoadingInProgress = true;
    final nextPage = _movieCurrentPage + 1;

    try {
      final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);

      _movies.addAll(moviesResponse.list);
      _movieCurrentPage = moviesResponse.page;
      _movieTotalPage = moviesResponse.totalPages;
      _isMovieLoadingInProgress = false;

      notifyListeners();
    } catch (e) {
      _isMovieLoadingInProgress = false;
    }
  }

  Future<void> loadTvShows() async {
    if (_isTvShowLoadingInProgress || _tvCurrentPage >= _tvTotalPage) return;
    _isTvShowLoadingInProgress = true;
    final nextPage = _tvCurrentPage + 1;

    try {
      final tvShowResponse = await _accountApiClient.getDefaultTvShowLists(page: nextPage, listType: listType);

      _tvs.addAll(tvShowResponse.list);
      _tvCurrentPage = tvShowResponse.page;
      _tvTotalPage = tvShowResponse.totalPages;
      _isTvShowLoadingInProgress = false;

      notifyListeners();
    } catch (e) {
      _isTvShowLoadingInProgress = false;
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
}

enum ListType {
  favorites, watchlist, rated, recommendations
}