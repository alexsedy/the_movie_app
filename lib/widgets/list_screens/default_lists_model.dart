import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/interfaces/i_loading_status.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class DefaultListsModel extends ChangeNotifier with DefaultListsMoviesModelMixin, DefaultListsTVsModelMixin {
  final ListType listType;
  final ScrollController _scrollController = ScrollController();
  final _accountApiClient = AccountApiClient();
  late int _currentPage;
  late int _totalPage;
  var _isFirstLoadMovie = true;
  var _isFirstLoadTvShow = true;

  DefaultListsModel(this.listType);

  ScrollController get scrollController => _scrollController;

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

      _movies.addAll(moviesResponse.list);
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

      _tvs.addAll(tvShowResponse.list);
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
    if (index < _tvs.length - 1) return;
    loadTvShows();
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

mixin DefaultListsMoviesModelMixin implements ILoadingStatus {
  final _movies = <MediaList>[];
  var _isMovieLoadingInProgress = false;
  List<MediaList> get movies => List.unmodifiable(_movies);

  @override
  bool get isLoadingInProgress => _isMovieLoadingInProgress;
}

mixin DefaultListsTVsModelMixin implements ILoadingStatus {
  final _tvs = <MediaList>[];
  var _isTvShowLoadingInProgress = false;
  List<MediaList> get tvs => List.unmodifiable(_tvs);

  @override
  bool get isLoadingInProgress => _isTvShowLoadingInProgress;
}