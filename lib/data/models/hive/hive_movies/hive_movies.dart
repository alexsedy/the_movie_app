import 'package:hive/hive.dart';
import 'package:the_movie_app/data/models/firebase_entity/movies/firebase_movies.dart';

part 'hive_movies.g.dart';

@HiveType(typeId: 0)
class HiveMovies extends HiveObject {
  @HiveField(0)
  final int movieId;

  @HiveField(1)
  final String? movieTitle;

  @HiveField(2)
  final String? releaseDate;

  @HiveField(3)
  final int status;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final DateTime? addedAt;

  @HiveField(6)
  final DateTime autoSyncDate;

  HiveMovies({
    required this.movieId,
    this.movieTitle,
    this.releaseDate,
    required this.status,
    required this.updatedAt,
    this.addedAt,
    required this.autoSyncDate,
  });

  FirebaseMovies toFirebaseMovie() {
    return FirebaseMovies(
      movieId: movieId,
      movieTitle: movieTitle,
      releaseDate: releaseDate,
      status: status,
      updatedAt: updatedAt,
      addedAt: addedAt,
    );
  }
}