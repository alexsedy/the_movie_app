// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowDetails _$TvShowDetailsFromJson(Map<String, dynamic> json) =>
    TvShowDetails(
      json['adult'] as bool,
      json['backdrop_path'] as String,
      (json['created_by'] as List<dynamic>)
          .map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['episode_run_time'] as List<dynamic>).map((e) => e as int).toList(),
      json['first_air_date'] as String,
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['homepage'] as String,
      json['id'] as int,
      json['in_production'] as bool,
      (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      json['last_air_date'] as String,
      json['last_episode_to_air'] == null
          ? null
          : LastEpisodeToAir.fromJson(
              json['last_episode_to_air'] as Map<String, dynamic>),
      json['name'] as String,
      json['next_episode_to_air'] == null
          ? null
          : NextEpisodeToAir.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>),
      (json['networks'] as List<dynamic>)
          .map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['number_of_episodes'] as int,
      json['number_of_seasons'] as int,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['original_language'] as String,
      json['original_name'] as String,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['seasons'] as List<dynamic>)
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['spoken_languages'] as List<dynamic>)
          .map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
      json['tagline'] as String,
      json['type'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      Credits.fromJson(json['credits'] as Map<String, dynamic>),
      Videos.fromJson(json['videos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TvShowDetailsToJson(TvShowDetails instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'created_by': instance.createdBy.map((e) => e.toJson()).toList(),
      'episode_run_time': instance.episodeRunTime,
      'first_air_date': instance.firstAirDate,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'homepage': instance.homepage,
      'id': instance.id,
      'in_production': instance.inProduction,
      'languages': instance.languages,
      'last_air_date': instance.lastAirDate,
      'last_episode_to_air': instance.lastEpisodeToAir?.toJson(),
      'name': instance.name,
      'next_episode_to_air': instance.nextEpisodeToAir?.toJson(),
      'networks': instance.networks.map((e) => e.toJson()).toList(),
      'number_of_episodes': instance.numberOfEpisodes,
      'number_of_seasons': instance.numberOfSeasons,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies':
          instance.productionCompanies.map((e) => e.toJson()).toList(),
      'production_countries':
          instance.productionCountries.map((e) => e.toJson()).toList(),
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
      'spoken_languages':
          instance.spokenLanguages.map((e) => e.toJson()).toList(),
      'status': instance.status,
      'tagline': instance.tagline,
      'type': instance.type,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'credits': instance.credits.toJson(),
      'videos': instance.videos.toJson(),
    };

CreatedBy _$CreatedByFromJson(Map<String, dynamic> json) => CreatedBy(
      json['id'] as int,
      json['credit_id'] as String,
      json['name'] as String,
      json['gender'] as int,
      json['profile_path'] as String,
    );

Map<String, dynamic> _$CreatedByToJson(CreatedBy instance) => <String, dynamic>{
      'id': instance.id,
      'credit_id': instance.creditId,
      'name': instance.name,
      'gender': instance.gender,
      'profile_path': instance.profilePath,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
      json['id'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

LastEpisodeToAir _$LastEpisodeToAirFromJson(Map<String, dynamic> json) =>
    LastEpisodeToAir(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['air_date'] as String,
      json['episode_number'] as int,
      json['production_code'] as String,
      json['runtime'] as int,
      json['season_number'] as int,
      json['show_id'] as int,
      json['still_path'] as String,
    );

Map<String, dynamic> _$LastEpisodeToAirToJson(LastEpisodeToAir instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'air_date': instance.airDate,
      'episode_number': instance.episodeNumber,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
    };

NextEpisodeToAir _$NextEpisodeToAirFromJson(Map<String, dynamic> json) =>
    NextEpisodeToAir(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['air_date'] as String,
      json['episode_number'] as int,
      json['production_code'] as String,
      json['runtime'] as int,
      json['season_number'] as int,
      json['show_id'] as int,
      json['still_path'] as String,
    );

Map<String, dynamic> _$NextEpisodeToAirToJson(NextEpisodeToAir instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'air_date': instance.airDate,
      'episode_number': instance.episodeNumber,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
    };

Network _$NetworkFromJson(Map<String, dynamic> json) => Network(
      json['id'] as int,
      json['logo_path'] as String,
      json['name'] as String,
      json['origin_country'] as String,
    );

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

ProductionCompany _$ProductionCompanyFromJson(Map<String, dynamic> json) =>
    ProductionCompany(
      json['id'] as int,
      json['logo_path'] as String,
      json['name'] as String,
      json['origin_country'] as String,
    );

Map<String, dynamic> _$ProductionCompanyToJson(ProductionCompany instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) =>
    ProductionCountry(
      json['iso_3166_1'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$ProductionCountryToJson(ProductionCountry instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso,
      'name': instance.name,
    };

Season _$SeasonFromJson(Map<String, dynamic> json) => Season(
      json['air_date'] as String,
      json['episode_count'] as int,
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      json['poster_path'] as String,
      json['season_number'] as int,
      (json['vote_average'] as num).toDouble(),
    );

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
      'air_date': instance.airDate,
      'episode_count': instance.episodeCount,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
      'vote_average': instance.voteAverage,
    };

SpokenLanguage _$SpokenLanguageFromJson(Map<String, dynamic> json) =>
    SpokenLanguage(
      json['english_name'] as String,
      json['iso_639_1'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$SpokenLanguageToJson(SpokenLanguage instance) =>
    <String, dynamic>{
      'english_name': instance.englishName,
      'iso_639_1': instance.iso,
      'name': instance.name,
    };
