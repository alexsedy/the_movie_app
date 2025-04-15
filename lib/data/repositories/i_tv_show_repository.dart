import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/season/season.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';

abstract class ITvShowRepository {
  Future<MediaListResponse> getDiscoverTvShow(int page);
  Future<MediaListResponse> getTvShowWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  });
  Future<MediaDetails> getTvShowById(int seriesId);
  Future<ItemState?> getTvShowState(int seriesId);
  Future<void> makeFavorite({required int tvShowId, required bool isFavorite});
  Future<void> addToWatchlist({required int tvShowId, required bool isWatched});
  Future<void> addRating({required int tvShowId, required double rate});
  Future<void> deleteRating({required int tvShowId});
  Future<MediaListResponse> getTrendingTv({required int page, required String timeToggle});
  Future<Season> getSeason(int seriesId, int seasonNumber);
  Future<MediaDetails> getSeriesDetails(int seriesId, int seasonNumber, int episodeNumber);
}