import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/models/interfaces/i_base_user_lists_model.dart';

abstract class IBaseMediaDetailsModel implements IBaseUserListsModel {
  MediaDetails? get mediaDetails;
  // ItemState? get mediaState;
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

  void onRecommendationsListScreen(BuildContext context, List<MediaList>? mediaList);
  void onCollectionScreen(BuildContext context);

  Future<void> launchYouTubeVideo(String videoKey);

  String formatDate(String? date);
}