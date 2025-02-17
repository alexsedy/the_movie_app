import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_movie_app/domain/entity/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/domain/entity/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/domain/entity/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/domain/entity/hive/hive_tv_show/hive_tv_show.dart';

class LocalMediaTrackingService {
  static const String moviesBoxName = 'movies';
  static const String tvShowsBoxName = 'tv_shows';

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
  Future<void> addMovieAndStatus(HiveMovies movie) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      await box.put(movie.movieId.toString(), movie);
    } catch (e) {
      throw Exception("Error adding movie to local storage: $e");
    }
  }

  Future<void> updateMovieStatus({
    required int movieId,
    required int status,
    required DateTime updatedAt,
  }) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      final movie = box.get(movieId.toString());

      if (movie == null) {
        throw Exception("Error updating movie status in local storage");
      }
      final updatedMovie = HiveMovies(
        movieId: movie.movieId,
        movieTitle: movie.movieTitle,
        releaseDate: movie.releaseDate,
        status: status,
        updatedAt: updatedAt,
        addedAt: movie.addedAt,
        autoSyncDate: movie.autoSyncDate,
      );
      await box.put(movieId.toString(), updatedMovie);
    } catch (e) {
      throw Exception("Error updating movie status in local storage: $e");
    }
  }

  Future<void> deleteMovieStatus(int movieId) async {
    try {
      final box = await Hive.openBox<HiveMovies>(moviesBoxName);
      await box.delete(movieId.toString());
    } catch (e) {
      throw Exception("Error deleting movie from local storage: $e");
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
  Future<void> addTVShowDataAndStatus(HiveTvShow tvShow) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      await box.put(tvShow.tvShowId.toString(), tvShow);
    } catch (e) {
      throw Exception("Error adding TV show to local storage: $e");
    }
  }

  Future<void> updateTVShowStatus({
    required int tvShowId,
    required int status,
    required DateTime updatedAt,
  }) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow == null) {
        throw Exception("Error updating TV show status in local storage");
      }

      final updatedTvShow = HiveTvShow(
        tvShowId: tvShow.tvShowId,
        tvShowName: tvShow.tvShowName,
        firstAirDate: tvShow.firstAirDate,
        status: status,
        updatedAt: updatedAt,
        addedAt: tvShow.addedAt,
        seasons: tvShow.seasons,
        autoSyncDate: tvShow.autoSyncDate,
      );
      await box.put(tvShowId.toString(), updatedTvShow);
    } catch (e) {
      throw Exception("Error updating TV show status in local storage: $e");
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

  Future<void> deleteTVShowStatus(int tvShowId) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      await box.delete(tvShowId.toString());
    } catch (e) {
      throw Exception("Error deleting TV show from local storage: $e");
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

  Future<void> updateSeasonAndEpisodesStatus({
    required int tvShowId,
    required int seasonNumber,
    required int status,
  }) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow == null || tvShow.seasons == null) {
        throw Exception("TV show or seasons not found");
      }

      final season = tvShow.seasons?[seasonNumber];
      if (season == null) {
        throw Exception("Season not found");
      }

      final updatedEpisodes = season.episodes?.map((key, episode) {
        return MapEntry(
          key,
          HiveEpisodes(
            episodeId: episode.episodeId,
            airDate: episode.airDate,
            status: status,
          ),
        );
      });

      final updatedSeason = HiveSeasons(
        seasonId: season.seasonId,
        airDate: season.airDate,
        status: status,
        updatedAt: DateTime.now(),
        episodeCount: season.episodeCount,
        episodes: updatedEpisodes,
      );

      tvShow.seasons?[seasonNumber] = updatedSeason;

      final seasonStatuses = tvShow.seasons!.values.map((s) => s.status).toList();
      final newTvShowStatus = seasonStatuses.every((status) => status == 1) ? 1 : 2;

      final updatedTvShow = HiveTvShow(
        tvShowId: tvShow.tvShowId,
        tvShowName: tvShow.tvShowName,
        firstAirDate: tvShow.firstAirDate,
        status: newTvShowStatus,
        updatedAt: DateTime.now(),
        addedAt: tvShow.addedAt,
        seasons: tvShow.seasons,
        autoSyncDate: tvShow.autoSyncDate,
      );

      await box.put(tvShowId.toString(), updatedTvShow);
    } catch (e) {
      throw Exception("Error updating season and episodes status: $e");
    }
  }

  //this method don't update TV show status
  // Future<void> updateSeasonAndEpisodesStatus({
  //   required int tvShowId,
  //   required int seasonNumber,
  //   required int status,
  // }) async {
  //   try {
  //     final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
  //     final tvShow = box.get(tvShowId.toString());
  //
  //     if (tvShow == null || tvShow.seasons == null) {
  //       throw Exception("TV show or seasons not found");
  //     }
  //
  //     final season = tvShow.seasons?[seasonNumber];
  //     if (season == null) {
  //       throw Exception("Season not found");
  //     }
  //
  //     final updatedEpisodes = season.episodes?.map((key, episode) {
  //       return MapEntry(
  //         key,
  //         HiveEpisodes(
  //           episodeId: episode.episodeId,
  //           airDate: episode.airDate,
  //           status: status,
  //         ),
  //       );
  //     });
  //
  //     final updatedSeason = HiveSeasons(
  //       seasonId: season.seasonId,
  //       airDate: season.airDate,
  //       status: status,
  //       updatedAt: DateTime.now(),
  //       episodeCount: season.episodeCount,
  //       episodes: updatedEpisodes,
  //     );
  //
  //     tvShow.seasons?[seasonNumber] = updatedSeason;
  //
  //     await box.put(tvShowId.toString(), tvShow);
  //   } catch (e) {
  //     throw Exception("Error updating season and episodes status: $e");
  //   }
  // }

  // EPISODES METHODS

  Future<void> updateEpisodeStatus({
    required int tvShowId,
    required int seasonNumber,
    required int episodeNumber,
    required int status,
  }) async {
    try {
      final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
      final tvShow = box.get(tvShowId.toString());

      if (tvShow == null || tvShow.seasons == null) {
        throw Exception("TV Show or seasons not found");
      }

      final season = tvShow.seasons?[seasonNumber];
      if (season == null || season.episodes == null) {
        throw Exception("Season or episodes not found");
      }

      final episode = season.episodes?[episodeNumber];
      if (episode == null) {
        throw Exception("Episode not found");
      }

      season.episodes![episodeNumber] = HiveEpisodes(
        episodeId: episode.episodeId,
        airDate: episode.airDate,
        status: status,
      );

      final completedEpisodes = season.episodes!.values.where((e) => e.status == 1).length;
      final totalEpisodes = season.episodeCount;

      final newSeasonStatus = completedEpisodes == totalEpisodes
          ? 1
          : (completedEpisodes > 0 ? 2 : 0);

      tvShow.seasons![seasonNumber] = HiveSeasons(
        seasonId: season.seasonId,
        airDate: season.airDate,
        status: newSeasonStatus,
        updatedAt: DateTime.now(),
        episodeCount: season.episodeCount,
        episodes: season.episodes,
      );

      final seasonStatuses = tvShow.seasons!.values.map((s) => s.status).toList();
      final newTvShowStatus = seasonStatuses.every((status) => status == 1) ? 1 : 2;

      final updatedTvShow = HiveTvShow(
        tvShowId: tvShow.tvShowId,
        tvShowName: tvShow.tvShowName,
        firstAirDate: tvShow.firstAirDate,
        status: newTvShowStatus,
        updatedAt: DateTime.now(),
        addedAt: tvShow.addedAt,
        seasons: tvShow.seasons,
        autoSyncDate: tvShow.autoSyncDate,
      );

      await box.put(tvShowId.toString(), updatedTvShow);
    } catch (e) {
      throw Exception("Error updating episode status: $e");
    }
  }
  //this method don't update TV show status
  // Future<void> updateEpisodeStatus({
  //   required int tvShowId,
  //   required int seasonNumber,
  //   required int episodeNumber,
  //   required int status,
  // }) async {
  //   try {
  //     final box = await Hive.openBox<HiveTvShow>(tvShowsBoxName);
  //     final tvShow = box.get(tvShowId.toString());
  //
  //     if (tvShow == null || tvShow.seasons == null) {
  //       throw Exception("TV Show or seasons not found");
  //     }
  //
  //     final season = tvShow.seasons?[seasonNumber];
  //     if (season == null || season.episodes == null) {
  //       throw Exception("Season or episodes not found");
  //     }
  //
  //     final episode = season.episodes?[episodeNumber];
  //     if (episode == null) {
  //       throw Exception("Episode not found");
  //     }
  //
  //     season.episodes![episodeNumber] = HiveEpisodes(
  //       episodeId: episode.episodeId,
  //       airDate: episode.airDate,
  //       status: status,
  //     );
  //
  //     final completedEpisodes = season.episodes!.values.where((e) => e.status == 1).length;
  //     final totalEpisodes = season.episodeCount;
  //
  //     final newSeasonStatus = completedEpisodes == totalEpisodes
  //         ? 1
  //         : (completedEpisodes > 0 ? 2 : 0);
  //
  //     tvShow.seasons![seasonNumber] = HiveSeasons(
  //       seasonId: season.seasonId,
  //       airDate: season.airDate,
  //       status: newSeasonStatus,
  //       updatedAt: DateTime.now(),
  //       episodeCount: season.episodeCount,
  //       episodes: season.episodes,
  //     );
  //
  //     await box.put(tvShowId.toString(), tvShow);
  //   } catch (e) {
  //     throw Exception("Error updating episode status: $e");
  //   }
  // }


// Utility methods
  // Future<void> clearAll() async {
  //   await Hive.deleteBoxFromDisk(moviesBoxName);
  //   await Hive.deleteBoxFromDisk(tvShowsBoxName);
  //   await init();
  // }
}