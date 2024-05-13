// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingPerson _$TrendingPersonFromJson(Map<String, dynamic> json) =>
    TrendingPerson(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => TrendingPersonList.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$TrendingPersonToJson(TrendingPerson instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.trendingPersonList.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

KnownFor _$KnownForFromJson(Map<String, dynamic> json) => KnownFor(
      json['adult'] as bool?,
      json['backdrop_path'] as String?,
      json['id'] as int?,
      json['title'] as String?,
      json['original_language'] as String?,
      json['original_title'] as String?,
      json['overview'] as String?,
      json['poster_path'] as String?,
      json['media_type'] as String?,
      (json['popularity'] as num?)?.toDouble(),
      json['release_date'] as String?,
      json['video'] as bool?,
      (json['vote_average'] as num?)?.toDouble(),
      json['vote_count'] as int?,
      json['name'] as String?,
      json['original_name'] as String?,
      json['first_air_date'] as String?,
      (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$KnownForToJson(KnownFor instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'id': instance.id,
      'title': instance.title,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'release_date': instance.releaseDate,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'name': instance.name,
      'original_name': instance.originalName,
      'first_air_date': instance.firstAirDate,
      'origin_country': instance.originCountry,
    };

TrendingPersonList _$TrendingPersonListFromJson(Map<String, dynamic> json) =>
    TrendingPersonList(
      json['adult'] as bool,
      json['id'] as int,
      json['name'] as String,
      json['original_name'] as String,
      json['media_type'] as String?,
      (json['popularity'] as num).toDouble(),
      json['gender'] as int,
      json['known_for_department'] as String?,
      json['profile_path'] as String?,
      (json['known_for'] as List<dynamic>)
          .map((e) => KnownFor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrendingPersonListToJson(TrendingPersonList instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'gender': instance.gender,
      'known_for_department': instance.knownForDepartment,
      'profile_path': instance.profilePath,
      'known_for': instance.knownFor.map((e) => e.toJson()).toList(),
    };
