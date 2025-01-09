import 'package:json_annotation/json_annotation.dart';

part 'firebase_movies.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FirebaseMovies {
  final int movieId;
  final String? movieTitle;
  final String? releaseDate;
  final int status;
  final DateTime updatedAt;

  FirebaseMovies({
    required this.movieId,
    this.movieTitle,
    this.releaseDate,
    required this.status,
    required this.updatedAt});

  factory FirebaseMovies.fromJson(Map<String, dynamic> json) => _$FirebaseMoviesFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseMoviesToJson(this);
}