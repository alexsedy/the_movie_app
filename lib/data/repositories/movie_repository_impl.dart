import 'package:the_movie_app/data/datasources/remote/api_client/movie_api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';

class MovieRepositoryImpl implements IMovieRepository {
  final MovieApiClient _movieApiClient;

  MovieRepositoryImpl(this._movieApiClient);

  @override
  Future<MediaListResponse> getDiscoverMovie(int page) {
    return _movieApiClient.getDiscoverMovie(page);
  }

  @override
  Future<MediaListResponse> getMovieWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  }) {
    return _movieApiClient.getMovieWithFilter(
      page: page,
      releaseDateStart: releaseDateStart,
      releaseDateEnd: releaseDateEnd,
      sortBy: sortBy,
      voteStart: voteStart,
      voteEnd: voteEnd,
      genres: genres,
    );
  }

  @override
  Future<MediaDetails> getMovieById(int movieId) {
    return _movieApiClient.getMovieById(movieId);
  }

  @override
  Future<ItemState?> getMovieState(int movieId) {
    return _movieApiClient.getMovieState(movieId);
  }

  @override
  Future<void> addToFavorite({required int movieId, required bool isFavorite}) {
    return _movieApiClient.addToFavorite(movieId: movieId, isFavorite: isFavorite);
  }

  @override
  Future<Credits> getCredits(int movieId) {
    return _movieApiClient.getCredits(movieId);
  }

  @override
  Future<void> addToWatchlist({required int movieId, required bool isWatched}) {
    return _movieApiClient.addToWatchlist(movieId: movieId, isWatched: isWatched);
  }

  @override
  Future<void> addRating({required int movieId, required double rate}) {
    return _movieApiClient.addRating(movieId: movieId, rate: rate);
  }

  @override
  Future<void> deleteRating({required int movieId}) {
    return _movieApiClient.deleteRating(movieId: movieId);
  }

  @override
  Future<MediaListResponse> getTrendingMovie({required int page, required String timeToggle}) {
    return _movieApiClient.getTrendingMovie(page: page, timeToggle: timeToggle);
  }

  @override
  Future<MediaCollections> getMediaCollections(int collectionId) {
    return _movieApiClient.getMediaCollections(collectionId);
  }
}
