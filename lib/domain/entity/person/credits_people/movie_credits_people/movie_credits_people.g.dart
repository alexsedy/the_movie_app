// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credits_people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCreditsPeople _$MovieCreditsPeopleFromJson(Map<String, dynamic> json) =>
    MovieCreditsPeople(
      (json['cast'] as List<dynamic>)
          .map((e) => MovieCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => MovieCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int?,
    );

Map<String, dynamic> _$MovieCreditsPeopleToJson(MovieCreditsPeople instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

MovieCast _$MovieCastFromJson(Map<String, dynamic> json) => MovieCast(
      json['adult'] as bool,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      json['original_language'] as String,
      json['original_title'] as String?,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      json['release_date'] as String?,
      json['title'] as String?,
      json['video'] as bool?,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['character'] as String,
      json['credit_id'] as String,
      json['order'] as int?,
    );

Map<String, dynamic> _$MovieCastToJson(MovieCast instance) => <String, dynamic>{
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
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
    };

MovieCrew _$MovieCrewFromJson(Map<String, dynamic> json) => MovieCrew(
      json['adult'] as bool,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      json['original_language'] as String,
      json['original_title'] as String?,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      json['release_date'] as String?,
      json['title'] as String?,
      json['video'] as bool?,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['credit_id'] as String,
      json['department'] as String,
      json['job'] as String,
    );

Map<String, dynamic> _$MovieCrewToJson(MovieCrew instance) => <String, dynamic>{
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
      'credit_id': instance.creditId,
      'department': instance.department,
      'job': instance.job,
    };
