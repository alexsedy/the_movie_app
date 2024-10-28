import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/api_client/people_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class HomeModel extends ChangeNotifier {
  final _movieApiClient = MovieApiClient();
  final _tvShowApiClient = TvShowApiClient();
  final _peopleApiClient = PeopleApiClient();
  final _random = Random();
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  final _persons = <TrendingPersonList>[];
  String? _randomPoster;
  bool _isSwitch = true;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  set isSwitch(value) =>_isSwitch = value;

  TextEditingController get  searchController => _searchController;
  FocusNode get searchFocusNode => _searchFocusNode;
  List<MediaList> get movies => List.unmodifiable(_movies);
  List<MediaList> get tvs => List.unmodifiable(_tvs);
  List<TrendingPersonList> get persons => List.unmodifiable(_persons);
  String? get randomPoster => _randomPoster;

  Future<void> loadMovies() async {
    if(_isSwitch) {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "day");
      _movies.addAll(moviesResponse.list);

      _setRandomPoster();
    } else {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "week");
      _movies.addAll(moviesResponse.list);
    }
    notifyListeners();
  }

  Future<void> loadTvShows() async {
    if(_isSwitch) {
      _tvs.clear();
      final tvResponse = await _tvShowApiClient.getTrendingTv(page: 1, timeToggle: "day");
      _tvs.addAll(tvResponse.list);
    } else {
      _tvs.clear();
      final tvResponse = await _tvShowApiClient.getTrendingTv(page: 1, timeToggle: "week");
      _tvs.addAll(tvResponse.list);
    }
    notifyListeners();
  }

  Future<void> loadTrendingPerson() async {
    if(_isSwitch) {
      _persons.clear();
      final personsResponse = await _peopleApiClient.getTrendingPerson(page: 1, timeToggle: "day");
      _persons.addAll(personsResponse.trendingPersonList);
    } else {
      _persons.clear();
      final personsResponse = await _peopleApiClient.getTrendingPerson(page: 1, timeToggle: "week");
      _persons.addAll(personsResponse.trendingPersonList);
    }
    notifyListeners();
  }

  void _setRandomPoster() {
    if (_randomPoster == null) {
      final randomList = _movies + _tvs;
      _randomPoster = randomList[_random.nextInt(randomList.length)].backdropPath;

      notifyListeners();
    }
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

  void onHomeSearchScreen(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.homeSearch, arguments: _searchController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}