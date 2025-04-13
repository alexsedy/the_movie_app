import 'package:the_movie_app/data/datasources/remote/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/season/season.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';

class TvShowRepositoryImpl implements ITvShowRepository {
  final TvShowApiClient _apiClient;

  TvShowRepositoryImpl(this._apiClient);

  @override
  Future<MediaListResponse> getDiscoverTvShow(int page) => _apiClient.getDiscoverTvShow(page);

  @override
  Future<MediaListResponse> getTvShowWithFilter({
    required int page,
    String? releaseDateStart,
    String? releaseDateEnd,
    String? sortBy,
    required double voteStart,
    required double voteEnd,
    String? genres,
  }) => _apiClient.getTvShowWithFilter(
    page: page,
    releaseDateStart: releaseDateStart,
    releaseDateEnd: releaseDateEnd,
    sortBy: sortBy,
    voteStart: voteStart,
    voteEnd: voteEnd,
    genres: genres,
  );

  @override
  Future<MediaDetails> getTvShowById(int seriesId) => _apiClient.getTvShowById(seriesId);

  @override
  Future<ItemState?> getTvShowState(int seriesId) => _apiClient.getTvShowState(seriesId);

  @override
  Future<void> makeFavorite({required int tvShowId, required bool isFavorite}) =>
      _apiClient.makeFavorite(tvShowId: tvShowId, isFavorite: isFavorite);

  @override
  Future<void> addToWatchlist({required int tvShowId, required bool isWatched}) =>
      _apiClient.addToWatchlist(tvShowId: tvShowId, isWatched: isWatched);

  @override
  Future<void> addRating({required int tvShowId, required double rate}) =>
      _apiClient.addRating(tvShowId: tvShowId, rate: rate);

  @override
  Future<void> deleteRating({required int tvShowId}) => _apiClient.deleteRating(tvShowId: tvShowId);

  @override
  Future<MediaListResponse> getTrendingTv({required int page, required String timeToggle}) =>
      _apiClient.getTrendingTv(page: page, timeToggle: timeToggle);

  @override
  Future<Season> getSeason(int seriesId, int seasonNumber) =>
      _apiClient.getSeason(seriesId, seasonNumber);

  @override
  Future<MediaDetails> getSeriesDetails(int seriesId, int seasonNumber, int episodeNumber) =>
      _apiClient.getSeriesDetails(seriesId, seasonNumber, episodeNumber);
}
