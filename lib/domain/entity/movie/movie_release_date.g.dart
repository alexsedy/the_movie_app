// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_release_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseDateRoot _$ReleaseDateRootFromJson(Map<String, dynamic> json) =>
    ReleaseDateRoot(
      id: json['id'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => ReleaseResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseDateRootToJson(ReleaseDateRoot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

ReleaseResult _$ReleaseResultFromJson(Map<String, dynamic> json) =>
    ReleaseResult(
      iso: json['iso_3166_1'] as String,
      releaseDates: (json['release_dates'] as List<dynamic>)
          .map((e) => ReleaseDate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseResultToJson(ReleaseResult instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso,
      'release_dates': instance.releaseDates,
    };

ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) => ReleaseDate(
      certification: json['certification'] as String,
      descriptors: (json['descriptors'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      iso: json['iso_639_1'] as String,
      note: json['note'] as String,
      releaseDate: DateTime.parse(json['release_date'] as String),
      type: json['type'] as int,
    );

Map<String, dynamic> _$ReleaseDateToJson(ReleaseDate instance) =>
    <String, dynamic>{
      'certification': instance.certification,
      'descriptors': instance.descriptors,
      'iso_639_1': instance.iso,
      'note': instance.note,
      'release_date': instance.releaseDate.toIso8601String(),
      'type': instance.type,
    };
