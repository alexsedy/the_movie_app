import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/helpers/event_helper.dart';
import 'package:the_movie_app/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeasonsListModel extends ChangeNotifier {
  final List<Seasons> seasons;
  final int tvShowId;
  late final Future<void> _initSeasonsStatuses = _getSeasonsStatuses();
  final _localMediaTrackingService = LocalMediaTrackingService();
  StreamSubscription? _subscription;
  final _seasonsStatuses = <int, HiveSeasons>{};

  Map<int, HiveSeasons> get seasonsStatuses => _seasonsStatuses;

  SeasonsListModel({required this.seasons, required this.tvShowId}) {
    _initSeasonsStatuses;
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if(event) {
        await _getSeasonsStatuses();
      }
    });
  }

  void onSeasonDetailsScreen(BuildContext context, int index) {
    final tvShowId = seasons[index].tvShowId;
    final seasonNumber = seasons[index].seasonNumber;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonDetails, arguments: [tvShowId, seasonNumber]);
  }

  Future<void> _getSeasonsStatuses() async {
    final tvShow = await _localMediaTrackingService.getTVShowById(tvShowId);
    final seasons = tvShow?.seasons;
    _seasonsStatuses.clear();
    _seasonsStatuses.addAll(seasons ?? {});
    notifyListeners();
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}