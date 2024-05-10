// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_collections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaCollections _$MediaCollectionsFromJson(Map<String, dynamic> json) =>
    MediaCollections(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String?,
      json['poster_path'] as String?,
      json['backdrop_path'] as String?,
      (json['parts'] as List<dynamic>)
          .map((e) => UserListResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaCollectionsToJson(MediaCollections instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
    };
