import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/data/models/media/season/season.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class SeasonDetailsViewModel extends ChangeNotifier {
  final int tvShowId;
  final int seasonNumber;
  final ITvShowRepository _tvShowRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  Season? _season;
  final Map<int, HiveEpisodes> _episodesStatuses = {};
  StreamSubscription? _subscription;

  Season? get season => _season;
  Map<int, HiveEpisodes> get episodesStatuses => Map.unmodifiable(_episodesStatuses);

  SeasonDetailsViewModel({
    required this.tvShowId,
    required this.seasonNumber,
    required ITvShowRepository tvShowRepository,
    required LocalMediaTrackingService localMediaTrackingService,
  }) : _tvShowRepository = tvShowRepository,
        _localMediaTrackingService = localMediaTrackingService {
    _initialize();
  }

  void _initialize() {
    loadSeasonDetails();
    _subscribeToEvents();
  }

  Future<void> loadSeasonDetails() async {
    notifyListeners();

    try {
      await Future.wait([
        _tvShowRepository.getSeason(tvShowId, seasonNumber).then((s) => _season = s),
        _getEpisodeStatuses(),
      ]);
    } catch (e) {
      print("Error loading season details: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _getEpisodeStatuses() async {
    final tvShow = await _localMediaTrackingService.getTVShowById(tvShowId);
    final episodes = tvShow?.seasons?[seasonNumber]?.episodes;
    _episodesStatuses.clear();
    _episodesStatuses.addAll(episodes ?? {});
  }

  void _subscribeToEvents() {
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event) {
        await _getEpisodeStatuses();
        notifyListeners();
      }
    });
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

  void onSeriesDetailsScreen(BuildContext context, int index) {
    final episodeNumber = _season?.episodes[index].episodeNumber;
    Navigator.of(context).pushNamed(
        MainNavigationRouteNames.seriesDetails,
        arguments: {
          NavParamConst.tvShowId: tvShowId,
          NavParamConst.seasonNumber: seasonNumber,
          NavParamConst.episodeNumber: episodeNumber,
        }
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}