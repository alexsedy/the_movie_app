// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_credits_people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowCreditsPeople _$TvShowCreditsPeopleFromJson(Map<String, dynamic> json) =>
    TvShowCreditsPeople(
      (json['cast'] as List<dynamic>)
          .map((e) => TvShowCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => TvShowCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int?,
    );

Map<String, dynamic> _$TvShowCreditsPeopleToJson(
        TvShowCreditsPeople instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

TvShowCast _$TvShowCastFromJson(Map<String, dynamic> json) => TvShowCast(
      json['adult'] as bool,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['original_language'] as String,
      json['original_name'] as String,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      json['first_air_date'] as String?,
      json['name'] as String?,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['character'] as String,
      json['credit_id'] as String,
      json['episode_count'] as int,
    );

Map<String, dynamic> _$TvShowCastToJson(TvShowCast instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'character': instance.character,
      'credit_id': instance.creditId,
      'episode_count': instance.episodeCount,
    };

TvShowCrew _$TvShowCrewFromJson(Map<String, dynamic> json) => TvShowCrew(
      json['adult'] as bool,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['original_language'] as String,
      json['original_name'] as String,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      json['first_air_date'] as String?,
      json['name'] as String?,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['credit_id'] as String,
      json['department'] as String,
      json['episode_count'] as int?,
      json['job'] as String,
    );

Map<String, dynamic> _$TvShowCrewToJson(TvShowCrew instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'credit_id': instance.creditId,
      'department': instance.department,
      'episode_count': instance.episodeCount,
      'job': instance.job,
    };
