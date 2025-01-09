import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonDetailsModel extends ChangeNotifier {
  final int tvShowId;
  final int seasonNumber;
  final _apiClient = TvShowApiClient();
  Season? _season;

  SeasonDetailsModel(this.tvShowId, this.seasonNumber);

  Season? get season => _season;

  Future<void> loadSeasonDetails() async {
    _season = await _apiClient.getSeason(tvShowId, seasonNumber);

    notifyListeners();
  }

  void onSeriesDetailsScreen(BuildContext context, int index) {
    final episodeNumber = _season?.episodes[index].episodeNumber;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.seriesDetails,
      arguments: [tvShowId, seasonNumber, episodeNumber]
    );
  }
}