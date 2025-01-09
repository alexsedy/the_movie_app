// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMovies _$FirebaseMoviesFromJson(Map<String, dynamic> json) =>
    FirebaseMovies(
      movieId: (json['movie_id'] as num).toInt(),
      movieTitle: json['movie_title'] as String?,
      releaseDate: json['release_date'] as String?,
      status: (json['status'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FirebaseMoviesToJson(FirebaseMovies instance) =>
    <String, dynamic>{
      'movie_id': instance.movieId,
      'movie_title': instance.movieTitle,
      'release_date': instance.releaseDate,
      'status': instance.status,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
