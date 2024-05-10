import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

abstract class BaseListModel {
  ScrollController get scrollController;

  bool get isMovieLoadingInProgress;
  bool get isTvsLoadingInProgress;
  List<MediaList> get movies;
  List<MediaList> get tvs;
  List<TrendingPersonList> get persons;
  MediaDetails? get mediaDetails;

  Future<void> firstLoadTvShows();
  Future<void> firstLoadMovies();

  Future<void> loadTrendingPerson();
  Future<void> loadMovies();
  Future<void> loadTvShows();

  void preLoadMovies(int index);
  void preLoadTvShows(int index);

  void onTvShowScreen(BuildContext context, int index);
  void onPeopleDetailsScreen(BuildContext context, int index);
  void onGuestPeopleDetailsScreen(BuildContext context, int index);
  void onMovieScreen(BuildContext context, int index);
  void onSeasonDetailsScreen(BuildContext context, int index);
  void onMediaDetailsScreen(BuildContext context, int index);

  String formatDate(String? date);
}