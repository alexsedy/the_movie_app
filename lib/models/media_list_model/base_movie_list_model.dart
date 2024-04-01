import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';

abstract class BaseMovieListModel {
  ScrollController get scrollController;
  bool get isMovieLoadingInProgress;
  List<MediaList> get movies;

  Future<void> firstLoadMovies();

  Future<void> loadMovies();

  void preLoadMovies(int index);

  void onMovieScreen(BuildContext context, int index);

  String formatDate(String? date);
}