// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Season _$SeasonFromJson(Map<String, dynamic> json) => Season(
      json['s_id'] as String?,
      json['air_date'] as String?,
      (json['episodes'] as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
      json['overview'] as String,
      (json['id'] as num).toInt(),
      json['poster_path'] as String?,
      (json['season_number'] as num).toInt(),
      (json['vote_average'] as num).toDouble(),
    );

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
      's_id': instance.sId,
      'air_date': instance.airDate,
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'overview': instance.overview,
      'id': instance.id,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
      'vote_average': instance.voteAverage,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      json['air_date'] as String?,
      (json['episode_number'] as num).toInt(),
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['overview'] as String,
      json['production_code'] as String,
      (json['runtime'] as num?)?.toInt(),
      (json['season_number'] as num).toInt(),
      (json['show_id'] as num).toInt(),
      json['still_path'] as String?,
      (json['vote_average'] as num).toDouble(),
      (json['vote_count'] as num).toInt(),
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'air_date': instance.airDate,
      'episode_number': instance.episodeNumber,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
