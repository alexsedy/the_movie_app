// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaListResponse _$MediaListResponseFromJson(Map<String, dynamic> json) =>
    MediaListResponse(
      page: (json['page'] as num).toInt(),
      list: (json['results'] as List<dynamic>)
          .map((e) => MediaList.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$MediaListResponseToJson(MediaListResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.list.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

MediaList _$MediaListFromJson(Map<String, dynamic> json) => MediaList(
      json['adult'] as bool?,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      (json['id'] as num).toInt(),
      json['original_language'] as String?,
      json['original_title'] as String?,
      json['overview'] as String?,
      (json['popularity'] as num?)?.toDouble(),
      json['poster_path'] as String?,
      json['release_date'] as String?,
      json['title'] as String?,
      json['video'] as bool?,
      (json['vote_average'] as num?)?.toDouble(),
      (json['vote_count'] as num?)?.toInt(),
      json['first_air_date'] as String?,
      json['name'] as String?,
      (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['original_name'] as String?,
      json['media_type'] as String?,
    );

Map<String, dynamic> _$MediaListToJson(MediaList instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'origin_country': instance.originCountry,
      'original_name': instance.originalName,
      'media_type': instance.mediaType,
    };
