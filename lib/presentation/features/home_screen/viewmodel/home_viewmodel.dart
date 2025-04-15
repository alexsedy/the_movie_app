import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/data/repositories/i_people_repository.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class HomeViewModel extends ChangeNotifier {
  final IMovieRepository _movieRepository;
  final ITvShowRepository _tvShowRepository;
  final IPeopleRepository _peopleRepository;

  final _random = Random();
  final _movies = <MediaList>[];
  final _tvs = <MediaList>[];
  final _persons = <TrendingPersonList>[];
  String? _randomPoster;
  bool _isLoadingMovies = false;
  bool _isLoadingTvs = false;
  bool _isLoadingPersons = false;

  List<MediaList> get movies => List.unmodifiable(_movies);
  List<MediaList> get tvs => List.unmodifiable(_tvs);
  List<TrendingPersonList> get persons => List.unmodifiable(_persons);
  String? get randomPoster => _randomPoster;
  bool get isLoadingMovies => _isLoadingMovies;
  bool get isLoadingTvs => _isLoadingTvs;
  bool get isLoadingPersons => _isLoadingPersons;


  HomeViewModel(
      this._movieRepository,
      this._tvShowRepository,
      this._peopleRepository,
      ) {
    _loadAllTrending();
  }

  Future<void> _loadAllTrending() async {
    await Future.wait([
      loadMovies(timeToggle: "day"),
      loadTvShows(timeToggle: "day"),
      loadTrendingPerson(timeToggle: "day"),
    ]);
    _setRandomPoster();
  }

  Future<void> loadMovies({required String timeToggle}) async {
    _isLoadingMovies = true;
    notifyListeners();
    try {
      final moviesResponse = await _movieRepository.getTrendingMovie(page: 1, timeToggle: timeToggle);
      _movies.clear();
      _movies.addAll(moviesResponse.list);
    } catch (e) {
      print("Error loading trending movies: $e");
    } finally {
      _isLoadingMovies = false;
      notifyListeners();
    }
  }

  Future<void> loadTvShows({required String timeToggle}) async {
    _isLoadingTvs = true;
    notifyListeners();
    try {
      final tvResponse = await _tvShowRepository.getTrendingTv(page: 1, timeToggle: timeToggle);
      _tvs.clear();
      _tvs.addAll(tvResponse.list);
    } catch (e) {
      print("Error loading trending tv shows: $e");
    } finally {
      _isLoadingTvs = false;
      notifyListeners();
    }
  }

  Future<void> loadTrendingPerson({required String timeToggle}) async {
    _isLoadingPersons = true;
    notifyListeners();
    try {
      final personsResponse = await _peopleRepository.getTrendingPerson(page: 1, timeToggle: timeToggle);
      _persons.clear();
      _persons.addAll(personsResponse.trendingPersonList);
    } catch (e) {
      print("Error loading trending persons: $e");
    } finally {
      _isLoadingPersons = false;
      notifyListeners();
    }
  }

  void _setRandomPoster() {
    if (_randomPoster == null && (_movies.isNotEmpty || _tvs.isNotEmpty)) {
      final randomList = [..._movies, ..._tvs];
      if (randomList.isNotEmpty) {
        _randomPoster = randomList[_random.nextInt(randomList.length)].backdropPath;
        notifyListeners();
      }
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

  void onHomeSearchScreen({required BuildContext context, int index = 0}) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.homeSearch,
        arguments: index,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
