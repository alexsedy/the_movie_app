// import 'package:flutter/material.dart';
// import 'package:the_movie_app/data/datasources/remote/api_client/movie_api_client.dart';
// import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
// import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
//
// class MediaCollectionModel extends ChangeNotifier {
//   final _apiClient = MovieApiClient();
//   int id;
//   MediaCollections? _mediaCollections;
//
//   MediaCollectionModel(this.id);
//
//   MediaCollections? get mediaCollections => _mediaCollections;
//
//   Future<void> loadCollections() async {
//     _mediaCollections = await _apiClient.getMediaCollections(id);
//
//     notifyListeners();
//   }
//
//   void onMediaDetailsScreen(BuildContext context, int index){
//     final id = _mediaCollections?.parts?[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
//   }
// }