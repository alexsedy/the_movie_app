// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Videos _$VideosFromJson(Map<String, dynamic> json) => Videos(
      json['id'] as int?,
      (json['results'] as List<dynamic>)
          .map((e) => VideosResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideosToJson(Videos instance) => <String, dynamic>{
      'id': instance.id,
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

VideosResult _$VideosResultFromJson(Map<String, dynamic> json) => VideosResult(
      json['iso_639_1'] as String,
      json['iso_3166_1'] as String,
      json['name'] as String,
      json['key'] as String,
      json['site'] as String,
      json['size'] as int,
      json['type'] as String,
      json['official'] as bool,
      json['published_at'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$VideosResultToJson(VideosResult instance) =>
    <String, dynamic>{
      'iso_639_1': instance.isoOne,
      'iso_3166_1': instance.isoTwo,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt,
      'id': instance.id,
    };
