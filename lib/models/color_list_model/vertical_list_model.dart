import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';

abstract class VerticalListModel {
  void onSeriesDetailsScreen(BuildContext context, int index);
  void onMediaDetailsScreen(BuildContext context, int index);
  Season? get season;
  MediaCollections? get mediaCollections;

  String formatDate(String? date);
}