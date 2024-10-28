import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class SeriesDetailsModel extends ChangeNotifier implements IBaseMediaDetailsModel {
  final _apiClient = TvShowApiClient();
  final int seriesId;
  final int seasonNumber;
  final int episodeNumber;
  MediaDetails? _mediaDetails;

  @override
  MediaDetails? get mediaDetails => _mediaDetails;

  SeriesDetailsModel(this.seriesId, this.seasonNumber, this.episodeNumber);

  Future<void> loadSeriesDetails() async {
    _mediaDetails = await _apiClient.getSeriesDetails(seriesId, seasonNumber, episodeNumber);

    notifyListeners();
  }

  void onCastListScreen(BuildContext context, List<Cast>? cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onGuestCastListScreen(BuildContext context, List<Cast>? cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListScreen(BuildContext context, List<Crew>? crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onGuestPeopleDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.credits.guestStars?[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}