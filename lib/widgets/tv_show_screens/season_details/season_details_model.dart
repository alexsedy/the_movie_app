import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/helpers/event_helper.dart';
import 'package:the_movie_app/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonDetailsModel extends ChangeNotifier {
  final int tvShowId;
  final int seasonNumber;
  final _apiClient = TvShowApiClient();
  Season? _season;
  final Map<int, HiveEpisodes> _episodesStatuses = {};
  late final Future<void> _initEpisodeStatuses = _getEpisodeStatuses();
  final _localMediaTrackingService = LocalMediaTrackingService();
  StreamSubscription? _subscription;

  SeasonDetailsModel(this.tvShowId, this.seasonNumber) {
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if(event) {
        await _getEpisodeStatuses();
        notifyListeners();
      }
    });
  }

  Season? get season => _season;
  Map<int, HiveEpisodes> get episodesStatuses => _episodesStatuses;

  Future<void> loadSeasonDetails() async {
    _season = await _apiClient.getSeason(tvShowId, seasonNumber);
    await _initEpisodeStatuses;

    notifyListeners();
  }

  void onSeriesDetailsScreen(BuildContext context, int index) {
    final episodeNumber = _season?.episodes[index].episodeNumber;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.seriesDetails,
      arguments: [tvShowId, seasonNumber, episodeNumber]
    );
  }

  Future<void> updateStatus(BuildContext context, int index, [int? number]) async {
    try {
      if(number == null) {
        throw Exception("int number is null");
      }

      final currentStatus = _episodesStatuses[number]?.status;

      await _localMediaTrackingService.updateEpisodeStatus(
        tvShowId: tvShowId,
        seasonNumber: seasonNumber,
        episodeNumber: number,
        status: currentStatus == 0 ? 1 : 0,
      );

      await _getEpisodeStatuses();
      notifyListeners();
      EventHelper.eventBus.fire(true);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    }
  }

  Future<void> _getEpisodeStatuses() async {
    final tvShow = await _localMediaTrackingService.getTVShowById(tvShowId);
    final episodes = tvShow?.seasons?[seasonNumber]?.episodes;
    _episodesStatuses.clear();
    _episodesStatuses.addAll(episodes ?? {});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}