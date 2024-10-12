import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/search_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/models/interfaces/i_loading_status.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class HomeSearchModel extends ChangeNotifier with HomeSearchMovieModelMixin, HomeSearchTVModelMixin,
    HomeSearchPersonModelMixin, HomeSearchCollectionModelMixin {
  final TextEditingController _searchController;
  final _scrollController = ScrollController();
  final _searchApiClient = SearchApiClient();
  Timer? _searchDebounce;
  late String _locale;

  HomeSearchModel(this._searchController);

  TextEditingController get searchController => _searchController;
  List<MediaCollections> get collections => _collections;

  List<MediaList> get tvs => _tvs;
  List<MediaList> get movies => _movies;
  List<TrendingPersonList> get persons => _persons;
  ScrollController get scrollController => _scrollController;
  bool get isPersonLoadingInProgress => _isPersonLoadingInProgress;
  bool get isCollectionLoadingInProgress => _isCollectionLoadingInProgress;

  Future<void> firstLoadAll() async {
    await firstLoadMovies();
    await firstLoadTvShows();
    await firstLoadPerson();
    await firstLoadCollection();
  }

  Future<void> loadAll() async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      clearAll();
      await loadMovies();
      await loadTvShows();
      await loadPersons();
      await loadCollections();
    });
  }

  Future<void> firstLoadMovies() async {
    if(_isFirstLoadMovie) {
      _movieCurrentPage = 0;
      _movieTotalPage = 1;
      loadMovies();
      _isFirstLoadMovie = false;
    }
  }

  Future<void> firstLoadTvShows() async {
    if(_isFirstLoadTvShow) {
      _tvCurrentPage = 0;
      _tvTotalPage = 1;
      loadTvShows();
      _isFirstLoadTvShow = false;
    }
  }

  Future<void> firstLoadPerson() async {
    if(_isFirstLoadPerson) {
      _personCurrentPage = 0;
      _personTotalPage = 1;
      loadPersons();
      _isFirstLoadPerson = false;
    }
  }

  Future<void> firstLoadCollection() async {
    if(_isFirstLoadCollection) {
      _collectionCurrentPage = 0;
      _collectionTotalPage = 1;
      loadCollections();
      _isFirstLoadCollection = false;
    }
  }

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

  Future<void> loadPersons() async {
    if (_isPersonLoadingInProgress || _personCurrentPage >= _personTotalPage) return;
    _isPersonLoadingInProgress = true;
    final nextPage = _personCurrentPage + 1;

    try {
      final personsResponse = await _searchApiClient.getSearchPersons(
          query: _searchController.text, page: nextPage
      );
      _persons.addAll(personsResponse.trendingPersonList);
      _personCurrentPage = personsResponse.page;
      _personTotalPage = personsResponse.totalPages;
      _isPersonLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isPersonLoadingInProgress = false;
    }
  }

  Future<void> loadCollections() async {
    if (_isCollectionLoadingInProgress || _collectionCurrentPage >= _collectionTotalPage) return;
    _isCollectionLoadingInProgress = true;
    final nextPage = _collectionCurrentPage + 1;

    // try {
      final collectionsResponse = await _searchApiClient.getSearchMediaCollections(
          query: _searchController.text, page: nextPage
      );
      _collections.addAll(collectionsResponse.results);
      _collectionCurrentPage = collectionsResponse.page;
      _collectionTotalPage = collectionsResponse.totalPages;
      _isCollectionLoadingInProgress = false;
      notifyListeners();
    // } catch (e) {
    //   _isCollectionLoadingInProgress = false;
    // }
  }

  void clearAll() {
    _movies.clear();
    _tvs.clear();
    _persons.clear();
    _collections.clear();
    _movieCurrentPage = 0;
    _movieTotalPage = 1;
    _tvCurrentPage = 0;
    _tvTotalPage = 1;
    _personCurrentPage = 0;
    _personTotalPage = 1;
    _collectionCurrentPage = 0;
    _collectionTotalPage = 1;
    notifyListeners();
  }

  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _persons[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onCollectionScreen(BuildContext context, int index) {
    final id = _collections[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.collection, arguments: id);
  }

  void backOnHomePage(BuildContext context) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      Navigator.pop(context);
    });
  }

  void preLoadMovies(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  void preLoadTvShows(int index) {
    if (index < _tvs.length - 1) return;
    loadTvShows();
  }

  void preLoadPersons(int index) {
    if (index < _persons.length - 1) return;
    loadPersons();
  }

  void preLoadCollections(int index) {
    if (index < _collections.length - 1) return;
    loadCollections();
  }
}

mixin HomeSearchMovieModelMixin implements ILoadingStatus {
  final _movies = <MediaList>[];
  var _isMovieLoadingInProgress = false;
  late int _movieCurrentPage;
  late int _movieTotalPage;
  var _isFirstLoadMovie = true;

  @override
  bool get isLoadingInProgress => _isMovieLoadingInProgress;
}

mixin HomeSearchTVModelMixin implements ILoadingStatus {
  final _tvs = <MediaList>[];
  var _isTvsLoadingInProgress = false;
  late int _tvCurrentPage;
  late int _tvTotalPage;
  var _isFirstLoadTvShow = true;

  @override
  bool get isLoadingInProgress => _isTvsLoadingInProgress;
}

mixin HomeSearchPersonModelMixin implements ILoadingStatus {
  final _persons = <TrendingPersonList>[];
  var _isPersonLoadingInProgress = false;
  late int _personCurrentPage;
  late int _personTotalPage;
  var _isFirstLoadPerson = true;

  @override
  bool get isLoadingInProgress => _isPersonLoadingInProgress;
}

mixin HomeSearchCollectionModelMixin implements ILoadingStatus {
  final _collections = <MediaCollections>[];
  var _isCollectionLoadingInProgress = false;
  late int _collectionCurrentPage;
  late int _collectionTotalPage;
  var _isFirstLoadCollection = true;

  @override
  bool get isLoadingInProgress => _isCollectionLoadingInProgress;
}