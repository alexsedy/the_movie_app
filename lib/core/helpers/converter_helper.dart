import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/data/models/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/season/season.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_widget_display_model.dart';
import 'package:the_movie_app/presentation/presentation_models/models/statuses_model.dart';


class ConverterHelper {
  static List<ParameterizedWidgetDisplayModel> convertMovieForHorizontalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.title,
        secondLine: DateFormatHelper.yearOnly(media.releaseDate),
        thirdLine: null,
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertTVShowForHorizontalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: DateFormatHelper.yearOnly(media.firstAirDate),
        thirdLine: null,
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertTrendingPeopleForHorizontalWidget(List<TrendingPersonList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: media.knownForDepartment,
        thirdLine: null,
        imagePath: media.profilePath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertMoviesForVerticalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.title,
        secondLine: DateFormatHelper.fullDate(media.releaseDate),
        thirdLine: media.overview,
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertTVShowsForVerticalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: DateFormatHelper.fullDate(media.firstAirDate),
        thirdLine: media.overview,
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertCasts(List<Cast> casts){
    return casts.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: null,
        thirdLine: media.character,
        imagePath: media.profilePath,
        id: media.id,
      );
    }).toList();
    }

  static List<ParameterizedWidgetDisplayModel> convertCrew(List<Crew> crew){
    return crew.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: media.job,
        thirdLine: null,
        imagePath: media.profilePath,
        id: media.id,
      );
    }).toList();
    }

  static List<ParameterizedWidgetDisplayModel> convertSeason( List<Seasons> seasons){
    return seasons.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: "${media.episodeCount} episodes",
        thirdLine: DateFormatHelper.fullDate(media.airDate),
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertSeasonHorizontal(List<Seasons>? seasons){
    if(seasons != null) {
      return seasons.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: "${media.episodeCount} episodes",
          thirdLine: DateFormatHelper.fullShortDate(media.airDate),
          imagePath: media.posterPath,
          id: media.id,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertEpisodes(Season season){
    return season.episodes.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: "${media.episodeNumber}. ${media.name}",
        secondLine: DateFormatHelper.fullDate(media.airDate),
        thirdLine: media.overview,
        imagePath: media.stillPath,
        id: media.id,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertMediaCollection(MediaCollections collection){
    var list = collection.parts;

    if(list != null) {
      return list.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.title,
          secondLine: DateFormatHelper.fullDate(media.releaseDate),
          thirdLine: media.overview,
          imagePath: media.posterPath,
          id: media.id,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertCompanies(List<ProductionCompanie> companies){
    return companies.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: null,
        thirdLine: null,
        imagePath: media.logoPath,
        id: media.id,
      );
    }).toList();
    }

  static List<ParameterizedWidgetDisplayModel> convertNetworks(List<Network> networks){
    return networks.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: null,
        thirdLine: null,
        imagePath: media.logoPath,
        id: media.id,
      );
    }).toList();
    }

  static List<ParameterizedWidgetDisplayModel> convertRecommendation(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.title ?? media.name,
        secondLine: DateFormatHelper.fullShortDate(media.releaseDate ?? media.firstAirDate),
        thirdLine: null,
        imagePath: media.posterPath,
        id: media.id,
      );
    }).toList();
  }

  static List<StatusesModel> convertMovieStatuses(List<HiveMovies> hiveMovies) {
    return hiveMovies.map((movie) {
      return StatusesModel(
        id: movie.movieId,
        status: movie.status,
      );
    }).toList();
  }

  static List<StatusesModel> convertTvShowStatuses(List<HiveTvShow> hiveTvShows) {
    return hiveTvShows.map((movie) {
      return StatusesModel(
        id: movie.tvShowId,
        status: movie.status,
      );
    }).toList();
  }

  static List<StatusesModel>? convertEpisodeStatuses(Map<int, HiveEpisodes> episodes) {
    if(episodes.isEmpty) {
      return null;
    }

    return episodes.entries.map((e) {
      return StatusesModel(
        id: e.value.episodeId,
        status: e.value.status,
        number: e.key,
      );},
    ).toList();
  }

  static List<StatusesModel>? convertWatchedSeasonsStatuses(Map<int, int> seasons) {
    if(seasons.isEmpty) {
      return null;
    }

    return seasons.entries.map((e) {
      return StatusesModel(
        id: e.key,
        status: e.value
      );
    }).toList();
  }

  static List<StatusesModel>? convertSeasonStatuses(Map<int, HiveSeasons> season) {
    if(season.isEmpty) {
      return null;
    }

    return season.entries.map((e) {
      return StatusesModel(
        id: e.value.seasonId,
        status: e.value.status,
        number: e.key,
      );},
    ).toList();
  }
}