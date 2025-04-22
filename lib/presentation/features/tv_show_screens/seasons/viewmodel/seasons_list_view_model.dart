import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class SeasonsListViewModel extends ChangeNotifier {
  final List<Seasons> seasons;
  final int tvShowId;
  final LocalMediaTrackingService _localMediaTrackingService;

  final _seasonsStatuses = <int, HiveSeasons>{};
  StreamSubscription? _subscription;

  Map<int, HiveSeasons> get seasonsStatuses => Map.unmodifiable(_seasonsStatuses);

  SeasonsListViewModel({
    required this.seasons,
    required this.tvShowId,
    required LocalMediaTrackingService localMediaTrackingService,
  }) : _localMediaTrackingService = localMediaTrackingService {
    _initialize();
  }

  void _initialize() {
    _getSeasonsStatuses();
    _subscribeToEvents();
  }

  Future<void> _getSeasonsStatuses() async {
    try {
      final tvShow = await _localMediaTrackingService.getTVShowById(tvShowId);
      final localSeasons = tvShow?.seasons;
      _seasonsStatuses.clear();
      if (localSeasons != null) {
        _seasonsStatuses.addAll(localSeasons);
      }
      notifyListeners();
    } catch (e) {
      print("Error getting season statuses: $e");
    }
  }

  void _subscribeToEvents() {
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event && !_isDisposed) {
        await _getSeasonsStatuses();
      }
    });
  }

  Future<void> updateStatus(BuildContext context, int index, [int? number]) async {
    try {
      if(number == null) {
        throw Exception("int number is null");
      }

      final currentStatus = _seasonsStatuses[number]?.status;

      await _localMediaTrackingService.updateSeasonAndEpisodesStatus(
        tvShowId: tvShowId,
        seasonNumber: number,
        status: currentStatus == 0 || currentStatus == 2 ? 1 : 0,
      );

      await _getSeasonsStatuses();
      EventHelper.eventBus.fire(true);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    }
  }

  void onSeasonDetailsScreen(BuildContext context, int index) {
    if (index < 0 || index >= seasons.length) return;
    final seasonNumber = seasons[index].seasonNumber;
    Navigator.of(context).pushNamed(
        MainNavigationRouteNames.seasonDetails,
        arguments: {NavParamConst.tvShowId: tvShowId, NavParamConst.seasonNumber: seasonNumber},
    );
  }

  bool _isDisposed = false;
  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}