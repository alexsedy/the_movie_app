import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/api_client/people_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/models/media_list_model/movie_list_model_mixin.dart';
import 'package:the_movie_app/models/media_list_model/trending_person_list_model_mixin.dart';
import 'package:the_movie_app/models/media_list_model/tv_list_model_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class HomeModel extends ChangeNotifier with MovieListModelMixin, TrendingPersonListModelMixin, TvListModelMixin {
  final _movieApiClient = MovieApiClient();
  final _tvShowApiClient = TvShowApiClient();
  final _peopleApiClient = PeopleApiClient();
  final _random = Random();
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  final _persons = <TrendingPersonList>[];
  final _dateFormat = DateFormat.y();
  String? randomPoster;
  bool _isSwitch = true;

  set isSwitch(value) =>_isSwitch = value;

  @override
  List<MediaList> get movies => List.unmodifiable(_movies);

  @override
  List<MediaList> get tvs => List.unmodifiable(_tvs);

  @override
  List<TrendingPersonList> get persons => List.unmodifiable(_persons);

  @override
  Future<void> loadMovies() async {
    if(_isSwitch) {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "day");
      _movies.addAll(moviesResponse.list);

      randomPoster ??= movies[_random.nextInt(movies.length)].backdropPath;
    } else {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "week");
      _movies.addAll(moviesResponse.list);
    }
    notifyListeners();
  }

  @override
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

  @override
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

  Future<String?> getRandomPoster() async {
    if (_movies.isNotEmpty) {
      var random = Random();
      final posterPath = movies[random.nextInt(movies.length)].backdropPath;
      notifyListeners();

      return posterPath;
    }
    return null;
  }

  @override
  void onMovieScreen(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void onTvShowScreen(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  @override
  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _persons[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";

  // @override
  // Future<void> firstLoadMovies() {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> firstLoadTvShows() {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // bool get isMovieLoadingInProgress => throw UnimplementedError();
  //
  // @override
  // bool get isTvsLoadingInProgress => throw UnimplementedError();
  //
  // @override
  // void preLoadMovies(int index) {
  // }
  //
  // @override
  // void preLoadTvShows(int index) {
  // }
  //
  // @override
  // ScrollController get scrollController => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}