import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/models/media_list_model/common_movie_list_model.dart';
import 'package:the_movie_app/models/media_list_model/common_tv_list_model.dart';

abstract class BaseMediaListModel implements CommonMovieListModel, CommonTvListModel {}
// abstract class BaseMediaListModel {
//   ScrollController get scrollController;
//   bool get isLoadingInProgress;
//   List<MediaList> get media;
//
//   Future<void> firstLoadMedia();
//
//   Future<void> loadMedia();
//
//   void preLoadMedia(int index);
//
//   void onMediaScreen(BuildContext context, int index);
//
//   String formatDate(String? date);
// }