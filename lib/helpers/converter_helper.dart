import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_collections/media_collections.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';
import 'package:the_movie_app/models/models/parameterized_widget_display_model.dart';

class ConverterHelper {
  static final _dateYear = DateFormat.y();
  static final _dateFull = DateFormat.yMMMMd();
  static final _dateFullShort = DateFormat.yMMMd();

  static List<ParameterizedWidgetDisplayModel> convertMovieForHorizontalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.title,
        secondLine: _formatDateOnlyYear(media.releaseDate),
        thirdLine: null,
        imagePath: media.posterPath,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertTVShowForHorizontalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: _formatDateOnlyYear(media.firstAirDate),
        thirdLine: null,
        imagePath: media.posterPath,
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
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertMoviesForVerticalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.title,
        secondLine: _formatFullDate(media.releaseDate),
        thirdLine: media.overview,
        imagePath: media.posterPath,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertTVShowsForVerticalWidget(List<MediaList> mediaList) {
    return mediaList.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: _formatFullDate(media.firstAirDate),
        thirdLine: media.overview,
        imagePath: media.posterPath,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertCasts(List<Cast>? casts){
    if(casts != null) {
      return casts.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: null,
          thirdLine: media.character,
          imagePath: media.profilePath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertCrew(List<Crew>? crew){
    if(crew != null) {
      return crew.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: media.job,
          thirdLine: null,
          imagePath: media.profilePath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertSeason( List<Seasons> seasons){
    return seasons.map((media) {
      return ParameterizedWidgetDisplayModel(
        firstLine: media.name,
        secondLine: "${media.episodeCount} episodes",
        thirdLine: _formatFullDate(media.airDate),
        imagePath: media.posterPath,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertSeasonHorizontal( List<Seasons>? seasons){
    if(seasons != null) {
      return seasons.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: "${media.episodeCount} episodes",
          thirdLine: _formatFullShortDate(media.airDate),
          imagePath: media.posterPath,
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
        secondLine: _formatFullDate(media.airDate),
        thirdLine: media.overview,
        imagePath: media.stillPath,
      );
    }).toList();
  }

  static List<ParameterizedWidgetDisplayModel> convertMediaCollection(MediaCollections collection){
    var list = collection.parts;

    if(list != null) {
      return list.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.title,
          secondLine: _formatFullDate(media.releaseDate),
          thirdLine: media.overview,
          imagePath: media.posterPath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertCompanies(List<ProductionCompanie>? companies){
    if(companies != null) {
      return companies.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: null,
          thirdLine: null,
          imagePath: media.logoPath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertNetworks(List<Network>? networks){
    if(networks != null) {
      return networks.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.name,
          secondLine: null,
          thirdLine: null,
          imagePath: media.logoPath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static List<ParameterizedWidgetDisplayModel> convertRecommendation(List<MediaList>? mediaList) {
    if (mediaList != null) {
      return mediaList.map((media) {
        return ParameterizedWidgetDisplayModel(
          firstLine: media.title ?? media.name,
          secondLine: _formatFullShortDate(media.releaseDate ?? media.firstAirDate),
          thirdLine: null,
          imagePath: media.posterPath,
        );
      }).toList();
    } else {
      return <ParameterizedWidgetDisplayModel>[];
    }
  }

  static String _formatDateOnlyYear(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateYear.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }

  static String _formatFullDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateFull.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }

  static String _formatFullShortDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateFullShort.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }
}