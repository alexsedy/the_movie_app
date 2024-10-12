import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonsListModel extends ChangeNotifier {
  final List<Seasons> _seasons;

  List<Seasons> get seasons => _seasons;

  SeasonsListModel(this._seasons);

  void onSeasonDetailsScreen(BuildContext context, int index) {
    final tvShowId = _seasons[index].tvShowId;
    final seasonNumber = _seasons[index].seasonNumber;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonDetails, arguments: [tvShowId, seasonNumber]);
  }
}