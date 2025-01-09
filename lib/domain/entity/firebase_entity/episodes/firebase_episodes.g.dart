// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_episodes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseEpisodes _$FirebaseEpisodesFromJson(Map<String, dynamic> json) =>
    FirebaseEpisodes(
      episodeId: (json['episode_id'] as num).toInt(),
      airDate: json['air_date'] as String?,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$FirebaseEpisodesToJson(FirebaseEpisodes instance) =>
    <String, dynamic>{
      'episode_id': instance.episodeId,
      'air_date': instance.airDate,
      'status': instance.status,
    };
