import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/api_error_mapper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class MediaCollectionViewModel extends ChangeNotifier {
  final int _collectionId;
  final IMovieRepository _movieRepository;
  String? _errorMessage;

  MediaCollections? _mediaCollections;

  MediaCollections? get mediaCollections => _mediaCollections;
  String? get errorMessage => _errorMessage;

  MediaCollectionViewModel(this._collectionId, this._movieRepository) {
    fetchCollections();
  }

  Future<void> fetchCollections() async {
    try {
      _mediaCollections = await _movieRepository.getMediaCollections(_collectionId);
      _errorMessage = null;
    } catch (e) {
      print("Error loading media collection: $e");
      if(e is ApiClientException) {
        _errorMessage = ApiErrorMapper.mapError(e);
      } else {
        _errorMessage = ApiErrorMapper.unknownError();
      }
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