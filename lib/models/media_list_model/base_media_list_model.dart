import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';

abstract class BaseListModel {
  ScrollController get scrollController;

  bool get isTvsLoadingInProgress;

  List<MediaList> get tvs;

  List<TrendingPersonList> get persons;

  MediaDetails? get mediaDetails;

  Future<void> firstLoadTvShows();

  Future<void> loadTvShows();

  void preLoadTvShows(int index);

  void onTvShowScreen(BuildContext context, int index);

  String formatDate(String? date);

  Future<void> loadTrendingPerson();

  void onPeopleScreen(BuildContext context, int index);

  bool get isMovieLoadingInProgress;

  List<MediaList> get movies;

  Future<void> firstLoadMovies();

  Future<void> loadMovies();

  void preLoadMovies(int index);

  void onMovieScreen(BuildContext context, int index);
}