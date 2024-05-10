import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/search_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/models/media_list_model/base_media_list_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class HomeSearchModel extends ChangeNotifier implements BaseListModel{
  final TextEditingController _searchController;
  final _scrollController = ScrollController();
  final _searchApiClient = SearchApiClient();
  late int _movieCurrentPage;
  late int _movieTotalPage;
  late String _locale;
  var _isFirstLoadMovie = true;
  var _isMovieLoadingInProgress = false;
  late int _tvCurrentPage;
  late int _tvTotalPage;
  var _isFirstLoadTvShow = true;
  var _isTvsLoadingInProgress = false;

  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  final _persons = <TrendingPersonList>[];
  final _collections = <MediaCollections>[];

  final _dateFormat = DateFormat.yMMMMd();

  HomeSearchModel(this._searchController);

  TextEditingController get searchController => _searchController;
  List<MediaCollections> get collections => _collections;

  @override
  bool get isMovieLoadingInProgress => _isMovieLoadingInProgress;
  @override
  bool get isTvsLoadingInProgress => _isTvsLoadingInProgress;
  @override
  List<MediaList> get tvs => _tvs;
  @override
  List<MediaList> get movies => _movies;
  @override
  List<TrendingPersonList> get persons => _persons;
  @override
  ScrollController get scrollController => _scrollController;

  @override
  Future<void> firstLoadMovies() async {
    if(_isFirstLoadMovie) {
      _movieCurrentPage = 0;
      _movieTotalPage = 1;
      loadMovies();
      _isFirstLoadMovie = false;
    }
  }

  @override
  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _tvCurrentPage = 0;
      _tvTotalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  @override
  Future<void> loadMovies() async {
    if (_isMovieLoadingInProgress || _movieCurrentPage >= _movieTotalPage) return;
    _isMovieLoadingInProgress = true;
    final nextPage = _movieCurrentPage + 1;

    try {
      final moviesResponse = await _searchApiClient.getSearchMovies(
        query: _searchController.text, page: nextPage
      );
      _movies.addAll(moviesResponse.list);
      _movieCurrentPage = moviesResponse.page;
      _movieTotalPage = moviesResponse.totalPages;
      _isMovieLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isMovieLoadingInProgress = false;
    }
  }

  @override
  Future<void> loadTrendingPerson() {
    // TODO: implement loadTrendingPerson
    throw UnimplementedError();
  }

  @override
  Future<void> loadTvShows() async {
    if (_isTvsLoadingInProgress || _tvCurrentPage >= _tvTotalPage) return;
    _isTvsLoadingInProgress = true;
    final nextPage = _tvCurrentPage + 1;

    try {
      final tvShowResponse = await _searchApiClient.getSearchTvs(
          query: _searchController.text, page: nextPage
      );
      _tvs.addAll(tvShowResponse.list);
      _tvCurrentPage = tvShowResponse.page;
      _tvTotalPage = tvShowResponse.totalPages;
      _isTvsLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isTvsLoadingInProgress = false;
    }
  }

  @override
  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _persons[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  @override
  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  @override
  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  @override
  void preLoadTvShows(int index) {
    if (index < _tvs.length - 1) return;
    loadTvShows();
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}