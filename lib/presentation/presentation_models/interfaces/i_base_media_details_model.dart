import 'package:flutter/material.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_user_lists_model.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_firebase_statuses.dart';

abstract class IBaseMediaDetailsModel implements IBaseUserListsModel, IStatuses {
  MediaDetails? get mediaDetails;
  List<Lists> get lists;
  bool get isFavorite;
  bool get isWatched;
  bool get isRated;
  double get rate;

  set rate(value);

  Future<void> toggleFavorite(BuildContext context);
  Future<void> toggleWatchlist(BuildContext context, int status);
  Future<void> toggleAddRating(BuildContext context, double rate);
  Future<void> toggleDeleteRating(BuildContext context);
  Future<void> launchYouTubeVideo(String videoKey);

  void onCollectionScreen(BuildContext context);
}