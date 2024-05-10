import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/models/color_list_model/base_color_list_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MediaCollectionModel extends ChangeNotifier implements BaseColorListModel {
  final _apiClient = MovieApiClient();
  final _dateFormat = DateFormat.yMMMd();
  int id;
  MediaCollections? _mediaCollections;

  MediaCollectionModel(this.id);

  @override
  MediaCollections? get mediaCollections => _mediaCollections;

  Future<void> loadCollections() async {
    _mediaCollections = await _apiClient.getMediaCollections(id);

    notifyListeners();
  }

  @override
  void onMediaDetailsScreen(BuildContext context, int index){
    final id = _mediaCollections?.parts[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  String formatDate(String? date) =>
      date != "" && date != null ? _dateFormat.format(DateTime.parse(date)) : "";

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}