import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/api_client/people_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/movie/movie_list/movie_list.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/domain/entity/tv_show/tv_show_list/tv_show_list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class HomeModel extends ChangeNotifier {
  final _movieApiClient = MovieApiClient();
  final _tvShowApiClient = TvShowApiClient();
  final _peopleApiClient = PeopleApiClient();
  final _random = Random();
  final _movies = <Movie>[];
  final _tvs = <TvShow>[];
  final _persons = <TrendingPersonList>[];
  final _dateFormat = DateFormat.y();
  String? randomPoster;

  List<Movie> get movies => List.unmodifiable(_movies);
  List<TvShow> get tvs => List.unmodifiable(_tvs);
  List<TrendingPersonList> get persons => List.unmodifiable(_persons);

  Future<void> loadMovies(bool isSwitch) async {
    if(isSwitch) {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "day");
      _movies.addAll(moviesResponse.movies);

      randomPoster ??= movies[_random.nextInt(movies.length)].backdropPath;
    } else {
      _movies.clear();
      final moviesResponse = await _movieApiClient.getTrendingMovie(page: 1, timeToggle: "week");
      _movies.addAll(moviesResponse.movies);
    }
    notifyListeners();
  }

  Future<void> loadTv(bool isSwitch) async {
    if(isSwitch) {
      _tvs.clear();
      final tvResponse = await _tvShowApiClient.getTrendingTv(page: 1, timeToggle: "day");
      _tvs.addAll(tvResponse.tvShows);
    } else {
      _tvs.clear();
      final tvResponse = await _tvShowApiClient.getTrendingTv(page: 1, timeToggle: "week");
      _tvs.addAll(tvResponse.tvShows);
    }
    notifyListeners();
  }

  Future<void> loadPerson(bool isSwitch) async {
    if(isSwitch) {
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

  void onMovieTab(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowTab(BuildContext context, int index) {
    final id = _tvs[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onPeopleTab(BuildContext context, int index) {
    final id = _persons[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "No date";
}

enum ToggleWidgetType {
  movie, tv, person
}