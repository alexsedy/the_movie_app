import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';

abstract class BaseTvListModel {
  ScrollController get scrollController;
  bool get isTvsLoadingInProgress;
  List<MediaList> get tvs;

  Future<void> firstLoadTvShows();

  Future<void> loadTvShows();

  void preLoadTvShows(int index);

  void onTvShowScreen(BuildContext context, int index);

  String formatDate(String? date);
}