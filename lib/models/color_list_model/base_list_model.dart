import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';

abstract class BaseColorListModel {
  List<Cast> get cast;
  List<Seasons> get seasons;
  Season? get season;

  void onPeopleScreen(BuildContext context, int index);
  void onSeasonDetailsScreen(BuildContext context, int index);
  void onSeriesDetailsScreen(BuildContext context, int index);

  String formatDate(String? date);
}