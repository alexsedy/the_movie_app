import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/state/item_state.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/models/media_list_model/base_media_list_model.dart';
import 'package:the_movie_app/models/user_lists_model/base_user_lists_model.dart';

abstract class BaseMediaDetailsModel implements BaseUserListsModel, BaseListModel {
  @override
  MediaDetails? get mediaDetails;
  ItemState? get mediaState;
  List<Lists> get lists;
  bool get isFavorite;
  bool get isWatched;
  bool get isRated;
  double get rate;

  set rate(value);

  Future<void> toggleFavorite(BuildContext context);
  Future<void> toggleWatchlist(BuildContext context);
  Future<void> toggleAddRating(BuildContext context, double rate);
  Future<void> toggleDeleteRating(BuildContext context);

  void onCastListScreen(BuildContext context, List<Cast> cast);
  void onCrewListScreen(BuildContext context, List<Crew> crew);
  void onGuestCastListScreen(BuildContext context, List<Cast> cast);
  void onPeopleDetailsScreen(BuildContext context, int index);
  void onCompaniesListScreen(BuildContext context);
  void onSeasonsListScreen(BuildContext context, List<Seasons> seasons);
  void onNetworksListScreen(BuildContext context);
  void onRecommendationsListScreen(BuildContext context, List<MediaList> mediaList);
  void onSimilarListScreen(BuildContext context, List<MediaList> mediaList);

  Future<void> launchYouTubeVideo(String videoKey);

  String formatDate(String? date);
  String formatDateTwo(String? date);
}