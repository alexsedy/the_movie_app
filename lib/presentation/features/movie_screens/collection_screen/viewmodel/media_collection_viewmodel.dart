import 'package:flutter/material.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class MediaCollectionViewModel extends ChangeNotifier {
  final int _collectionId;
  final IMovieRepository _movieRepository;

  MediaCollections? _mediaCollections;

  MediaCollections? get mediaCollections => _mediaCollections;

  MediaCollectionViewModel(this._collectionId, this._movieRepository) {
    loadCollections();
  }

  Future<void> loadCollections() async {
    try {
      _mediaCollections = await _movieRepository.getMediaCollections(_collectionId);
    } catch (e) {
      print("Error loading media collection: $e");
    } finally {
      notifyListeners();
    }
  }

  void onMediaDetailsScreen(BuildContext context, int index) {
    final id = _mediaCollections?.parts?[index].id;
    if (id != null) {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
    }
  }
}