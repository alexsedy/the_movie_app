// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_tv_shows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseTvShow _$FirebaseTvShowFromJson(Map<String, dynamic> json) =>
    FirebaseTvShow(
      tvShowId: (json['tv_show_id'] as num).toInt(),
      tvShowName: json['tv_show_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      status: (json['status'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
      seasons: (json['seasons'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), FirebaseSeasons.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$FirebaseTvShowToJson(FirebaseTvShow instance) =>
    <String, dynamic>{
      'tv_show_id': instance.tvShowId,
      'tv_show_name': instance.tvShowName,
      'first_air_date': instance.firstAirDate,
      'status': instance.status,
      'updated_at': instance.updatedAt.toIso8601String(),
      'added_at': instance.addedAt?.toIso8601String(),
      'seasons':
          instance.seasons?.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };
