import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/models/color_list_model/season_details_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonDetailsModel extends ChangeNotifier with SeasonDetailsMixin {
  final int tvShowId;
  final int seasonNumber;
  final _apiClient = TvShowApiClient();
  Season? _season;
  final _dateFormat = DateFormat.yMMMd();

  SeasonDetailsModel(this.tvShowId, this.seasonNumber);

  @override
  Season? get season => _season;

  Future<void> loadSeasonDetails() async {
    _season = await _apiClient.getSeason(tvShowId, seasonNumber);

    notifyListeners();
  }

  @override
  void onSeriesDetailsScreen(BuildContext context, int index) {
    final episodeNumber = _season?.episodes[index].episodeNumber;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.seriesDetails,
      arguments: [tvShowId, seasonNumber, episodeNumber]
    );
  }

  @override
  String formatDate(String? date) =>
      date != "" && date != null ? _dateFormat.format(DateTime.parse(date)) : "";

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}