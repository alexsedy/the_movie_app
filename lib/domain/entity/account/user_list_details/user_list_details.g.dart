// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListDetails _$UserListDetailsFromJson(Map<String, dynamic> json) =>
    UserListDetails(
      (json['average_rating'] as num).toDouble(),
      json['backdrop_path'] as String?,
      (json['results'] as List<dynamic>)
          .map((e) => UserListResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      CreatedBy.fromJson(json['created_by'] as Map<String, dynamic>),
      json['description'] as String?,
      json['id'] as int,
      json['iso_3166_1'] as String,
      json['iso_639_1'] as String,
      json['item_count'] as int,
      json['name'] as String,
      json['page'] as int,
      json['poster_path'] as String?,
      json['public'] as bool,
      json['runtime'] as int,
      json['sort_by'] as String,
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$UserListDetailsToJson(UserListDetails instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRating,
      'backdrop_path': instance.backdropPath,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'created_by': instance.createdBy.toJson(),
      'description': instance.description,
      'id': instance.id,
      'iso_3166_1': instance.isoOne,
      'iso_639_1': instance.isoTwo,
      'item_count': instance.itemCount,
      'name': instance.name,
      'page': instance.page,
      'poster_path': instance.posterPath,
      'public': instance.public,
      'runtime': instance.runtime,
      'sort_by': instance.sortBy,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

CreatedBy _$CreatedByFromJson(Map<String, dynamic> json) => CreatedBy(
      json['avatar_path'] as String?,
      json['gravatar_hash'] as String?,
      json['id'] as String,
      json['name'] as String?,
      json['username'] as String,
    );

Map<String, dynamic> _$CreatedByToJson(CreatedBy instance) => <String, dynamic>{
      'avatar_path': instance.avatarPath,
      'gravatar_hash': instance.gravatarHash,
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
    };

UserListResult _$UserListResultFromJson(Map<String, dynamic> json) =>
    UserListResult(
      json['adult'] as bool,
      json['backdrop_path'] as String?,
      json['id'] as int,
      json['title'] as String?,
      json['original_language'] as String,
      json['original_title'] as String?,
      json['overview'] as String,
      json['poster_path'] as String?,
      json['media_type'] as String,
      (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      (json['popularity'] as num?)?.toDouble(),
      json['release_date'] as String?,
      json['video'] as bool?,
      (json['vote_average'] as num?)?.toDouble(),
      json['vote_count'] as int?,
      json['name'] as String?,
      json['first_air_date'] as String?,
    );

Map<String, dynamic> _$UserListResultToJson(UserListResult instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'id': instance.id,
      'title': instance.title,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'media_type': instance.mediaType,
      'genre_ids': instance.genreIds,
      'popularity': instance.popularity,
      'release_date': instance.releaseDate,
      'first_air_date': instance.firstAirDate,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
