import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/domain/entity/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/domain/entity/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/domain/entity/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';

class BackgroundSyncWithLocal {
  final _movieApiClient = MovieApiClient();
  final _tvShowApiClient = TvShowApiClient();
  final _localMediaTrackingService = LocalMediaTrackingService();

  Future<void> syncLocalData() async {
    final stopwatch = Stopwatch()..start();
    final currentDate = DateTime.now();
    await _tvShowSync(currentDate);
    await _movieSync(currentDate);
    stopwatch.stop();
    print("Background sync with local data completed in ${stopwatch.elapsedMilliseconds} milliseconds.");
    print("Background sync with local data completed.");
  }

  Future<void> _tvShowSync(DateTime currentDate) async {
    final tvShows = await _localMediaTrackingService.getAllTVShows();

    for(var tvShow in tvShows) {
      if(currentDate.difference(tvShow.updatedAt).inDays > 90) {
        final tvShowDetails = await _tvShowApiClient.getTvShowById(tvShow.tvShowId);
        final cachedTvShow = await _localMediaTrackingService.getTVShowById(tvShow.tvShowId);

        final seasons = await tvShowDetails.seasons;
        final seasonDetailsList = <Season>[];
        if (seasons != null) {
          final futures = seasons.map((s) {
            return _tvShowApiClient.getSeason(tvShowDetails.id, s.seasonNumber);
          }).toList();

          final detailsList = await Future.wait(futures);
          seasonDetailsList.addAll(detailsList);
        }

        final hiveSeasons = {
          for (var season in seasonDetailsList)
            season.seasonNumber: HiveSeasons(
              seasonId: season.id,
              airDate: season.airDate,
              status: cachedTvShow?.seasons?[season.seasonNumber]?.status ?? 0,
              updatedAt: cachedTvShow?.seasons?[season.seasonNumber]?.updatedAt ?? currentDate,
              episodeCount: season.episodes.length,
              episodes: {
                for (var episode in season.episodes)
                  episode.episodeNumber: HiveEpisodes(
                    episodeId: episode.id,
                    airDate: episode.airDate,
                    status: cachedTvShow?.seasons?[season.seasonNumber]?.episodes?[episode.episodeNumber]?.status ?? 0,
                  ),
              },
            ),
        };

        final hiveTvShow = HiveTvShow(
          tvShowId: tvShowDetails.id,
          status: cachedTvShow?.status ?? 0,
          updatedAt: cachedTvShow?.updatedAt ?? currentDate,
          addedAt: cachedTvShow?.addedAt ?? currentDate,
          tvShowName: tvShowDetails.name,
          firstAirDate: tvShowDetails.firstAirDate,
          autoSyncDate: currentDate,
          seasons: hiveSeasons,
        );

        await _localMediaTrackingService.addTVShowDataAndStatus(hiveTvShow);
      }
    }
  }

  Future<void> _movieSync(DateTime currentDate) async {
    final movies = await _localMediaTrackingService.getAllMovies();

    for (var movie in movies) {
      if(currentDate.difference(movie.updatedAt).inDays > 90) {
        final movieDetails = await _movieApiClient.getMovieById(movie.movieId);
        final cachedMovie = await _localMediaTrackingService.getMovieById(movie.movieId);

        final updatedMovie = HiveMovies(
          movieId: movieDetails.id,
          movieTitle: movieDetails.title,
          releaseDate: movieDetails.releaseDate,
          status: cachedMovie?.status ?? 0,
          updatedAt: cachedMovie?.updatedAt ?? currentDate,
          addedAt: cachedMovie?.addedAt ?? currentDate,
          autoSyncDate: currentDate,
        );

        await _localMediaTrackingService.addMovieAndStatus(updatedMovie);
      }
    }
  }
}