// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_collections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionsList _$CollectionsListFromJson(Map<String, dynamic> json) =>
    CollectionsList(
      (json['page'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => MediaCollections.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$CollectionsListToJson(CollectionsList instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

MediaCollections _$MediaCollectionsFromJson(Map<String, dynamic> json) =>
    MediaCollections(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['overview'] as String?,
      json['poster_path'] as String?,
      json['backdrop_path'] as String?,
      (json['parts'] as List<dynamic>?)
          ?.map((e) => UserListResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['original_language'] as String?,
      json['original_name'] as String?,
    );

Map<String, dynamic> _$MediaCollectionsToJson(MediaCollections instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'parts': instance.parts?.map((e) => e.toJson()).toList(),
    };
