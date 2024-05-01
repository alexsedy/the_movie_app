import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/models/color_list_model/seasons_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonsListModel extends ChangeNotifier with SeasonsMixin {
  final List<Seasons> _seasons;
  final _dateFormat = DateFormat.yMMMd();

  @override
  List<Seasons> get seasons => _seasons;


  SeasonsListModel(this._seasons);

  @override
  void onSeasonDetailsScreen(BuildContext context, int index) {
    final tvShowId = _seasons[index].tvShowId;
    final seasonNumber = _seasons[index].seasonNumber;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonDetails, arguments: [tvShowId, seasonNumber]);
  }

  @override
  String formatDate(String? date) =>
      date != "" && date != null ? _dateFormat.format(DateTime.parse(date)) : "";

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}