// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_seasons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseSeasons _$FirebaseSeasonsFromJson(Map<String, dynamic> json) =>
    FirebaseSeasons(
      seasonId: (json['season_id'] as num).toInt(),
      airDate: json['air_date'] as String?,
      status: (json['status'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      episodeCount: (json['episode_count'] as num?)?.toInt(),
      episodes: (json['episodes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), FirebaseEpisodes.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$FirebaseSeasonsToJson(FirebaseSeasons instance) =>
    <String, dynamic>{
      'season_id': instance.seasonId,
      'air_date': instance.airDate,
      'status': instance.status,
      'updated_at': instance.updatedAt.toIso8601String(),
      'episode_count': instance.episodeCount,
      'episodes':
          instance.episodes?.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };
