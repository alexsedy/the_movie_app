import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';

abstract class IMovieRepository {
  Future<MediaListResponse> getDiscoverMovie(int page);
  Future<MediaListResponse> getMovieWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  });
  Future<MediaDetails> getMovieById(int movieId);
  Future<ItemState?> getMovieState(int movieId);
  Future<void> addToFavorite({required int movieId, required bool isFavorite});
  Future<Credits> getCredits(int movieId);
  Future<void> addToWatchlist({required int movieId, required bool isWatched});
  Future<void> addRating({required int movieId, required double rate});
  Future<void> deleteRating({required int movieId});
  Future<MediaListResponse> getTrendingMovie({required int page, required String timeToggle});
  Future<MediaCollections> getMediaCollections(int collectionId);
}
