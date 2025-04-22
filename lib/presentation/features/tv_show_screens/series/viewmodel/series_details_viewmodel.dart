import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';

class SeriesDetailsViewModel extends ChangeNotifier implements IBaseMediaDetailsModel {
  final int seriesId;
  final int seasonNumber;
  final int episodeNumber;
  final ITvShowRepository _tvShowRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  MediaDetails? _mediaDetails;
  int? _currentStatus;

  @override
  MediaDetails? get mediaDetails => _mediaDetails;
  int? get currentStatus => _currentStatus;


  SeriesDetailsViewModel({
    required this.seriesId,
    required this.seasonNumber,
    required this.episodeNumber,
    required ITvShowRepository tvShowRepository,
    required LocalMediaTrackingService localMediaTrackingService,
  }) : _tvShowRepository = tvShowRepository,
        _localMediaTrackingService = localMediaTrackingService {
    _initialize();
  }

  void _initialize() {
    loadSeriesDetails();
  }

  Future<void> loadSeriesDetails() async {
    notifyListeners();

    try {
      await Future.wait([
        _tvShowRepository.getSeriesDetails(seriesId, seasonNumber, episodeNumber)
            .then((details) => _mediaDetails = details),
        _getSeriesStatus(),
      ]);
    } catch (e) {
      print("Error loading series details: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _getSeriesStatus() async {
    try {
      final seasonData = await _localMediaTrackingService.getSeason(seriesId, seasonNumber);
      _currentStatus = seasonData?.episodes?[episodeNumber]?.status ?? 0;
    } catch (e) {
      print("Error getting series status: $e");
      _currentStatus = 0;
    }
  }

  Future<void> updateStatus(BuildContext context, int status) async {
    status = _currentStatus == 1 ? 0 : 1;

    try {
      await _localMediaTrackingService.updateEpisodeStatus(
        tvShowId: seriesId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
        status: status,
      );

      _currentStatus = status;
      notifyListeners();

      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: "The episode status has been updated", //TODO: Localize
      );
      EventHelper.eventBus.fire(true);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    }
  }

  void onCastListScreen(BuildContext context, List<Cast> cast) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);

  void onGuestCastListScreen(BuildContext context, List<Cast> cast) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);

  void onCrewListScreen(BuildContext context, List<Crew> crew) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.credits.cast[index].id;
    if (id != null) {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
    }
  }

  void onGuestPeopleDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.credits.guestStars?[index].id;
    if (id != null) {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
