import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_movie_app/domain/entity/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/domain/entity/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/domain/entity/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/domain/entity/hive/hive_tv_show/hive_tv_show.dart';

class LocalMediaTrackingService {
  static const String moviesBoxName = 'movies';
  static const String tvShowsBoxName = 'tv_shows';

  // Инициализация Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveMoviesAdapter());
    Hive.registerAdapter(HiveTvShowAdapter());
    Hive.registerAdapter(HiveSeasonsAdapter());
    Hive.registerAdapter(HiveEpisodesAdapter());

    await Hive.openBox<HiveMovies>(moviesBoxName);
    await Hive.openBox<HiveTvShow>(tvShowsBoxName);
  }

  // MOVIES METHODS
  Future<bool> addMovieAndStatus(HiveMovies movie) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      await box.put(movie.movieId.toString(), movie);
      return true;
    } catch (e) {
      print("Error adding movie to local storage: $e");
      return false;
    }
  }

  Future<bool> updateMovieStatus({
    required int movieId,
    required int status,
    required String updatedAt,
  }) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      final movie = box.get(movieId.toString());

      if (movie != null) {
        final updatedMovie = HiveMovies(
          movieId: movie.movieId,
          movieTitle: movie.movieTitle,
          releaseDate: movie.releaseDate,
          status: status,
          updatedAt: DateTime.parse(updatedAt),
          addedAt: movie.addedAt,
        );
        await box.put(movieId.toString(), updatedMovie);
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating movie status in local storage: $e");
      return false;
    }
  }

  Future<bool> deleteMovieStatus(int movieId) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      await box.delete(movieId.toString());
      return true;
    } catch (e) {
      print("Error deleting movie from local storage: $e");
      return false;
    }
  }

  Future<HiveMovies?> getMovieById(int movieId) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      return box.get(movieId.toString());
    } catch (e) {
      print("Error getting movie from local storage: $e");
      return null;
    }
  }

  Future<List<HiveMovies>> getAllMovies() async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      return box.values.toList();
    } catch (e) {
      print("Error getting all movies from local storage: $e");
      return [];
    }
  }

  // TV SHOWS METHODS
  Future<bool> addTVShowDataAndStatus(HiveTvShow tvShow) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      await box.put(tvShow.tvShowId.toString(), tvShow);
      return true;
    } catch (e) {
      print("Error adding TV show to local storage: $e");
      return false;
    }
  }

  Future<bool> updateTVShowStatus({
    required int tvShowId,
    required int status,
    required String updatedAt,
  }) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow != null) {
        final updatedTvShow = HiveTvShow(
          tvShowId: tvShow.tvShowId,
          tvShowName: tvShow.tvShowName,
          firstAirDate: tvShow.firstAirDate,
          status: status,
          updatedAt: DateTime.parse(updatedAt),
          addedAt: tvShow.addedAt,
          seasons: tvShow.seasons,
        );
        await box.put(tvShowId.toString(), updatedTvShow);
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating TV show status in local storage: $e");
      return false;
    }
  }

  Future<HiveTvShow?> getTVShowById(int tvShowId) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      return box.get(tvShowId.toString());
    } catch (e) {
      print("Error getting TV show from local storage: $e");
      return null;
    }
  }

  Future<List<HiveTvShow>> getAllTVShows() async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      return box.values.toList();
    } catch (e) {
      print("Error getting all TV shows from local storage: $e");
      return [];
    }
  }

  // SEASONS METHODS
  Future<HiveSeasons?> getSeason(int tvShowId, int seasonNumber) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow != null && tvShow.seasons != null) {
        return tvShow.seasons![seasonNumber];
      }
      return null;
    } catch (e) {
      print("Error getting season from local storage: $e");
      return null;
    }
  }

  // EPISODES METHODS
  Future<bool> updateEpisodeStatus({
    required int tvShowId,
    required int seasonNumber,
    required int episodeNumber,
    required int status,
  }) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow != null && tvShow.seasons != null) {
        final season = tvShow.seasons![seasonNumber];
        if (season != null && season.episodes != null) {
          final episode = season.episodes![episodeNumber];
          if (episode != null) {
            // Создаем обновленный эпизод
            final updatedEpisode = HiveEpisodes(
              episodeId: episode.episodeId,
              airDate: episode.airDate,
              status: status,
            );

            // Создаем обновленную карту эпизодов
            final updatedEpisodes = Map<int, HiveEpisodes>.from(season.episodes!);
            updatedEpisodes[episodeNumber] = updatedEpisode;

            // Создаем обновленный сезон
            final updatedSeason = HiveSeasons(
              seasonId: season.seasonId,
              airDate: season.airDate,
              status: season.status,
              updatedAt: season.updatedAt,
              episodeCount: season.episodeCount,
              episodes: updatedEpisodes,
            );

            // Создаем обновленную карту сезонов
            final updatedSeasons = Map<int, HiveSeasons>.from(tvShow.seasons!);
            updatedSeasons[seasonNumber] = updatedSeason;

            // Создаем обновленный сериал
            final updatedTvShow = HiveTvShow(
              tvShowId: tvShow.tvShowId,
              tvShowName: tvShow.tvShowName,
              firstAirDate: tvShow.firstAirDate,
              status: tvShow.status,
              updatedAt: tvShow.updatedAt,
              addedAt: tvShow.addedAt,
              seasons: updatedSeasons,
            );

            await box.put(tvShowId.toString(), updatedTvShow);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error updating episode status in local storage: $e");
      return false;
    }
  }

  // Utility methods
  // Future<void> clearAll() async {
  //   await Hive.deleteBoxFromDisk(moviesBoxName);
  //   await Hive.deleteBoxFromDisk(tvShowsBoxName);
  //   await init();
  // }
}