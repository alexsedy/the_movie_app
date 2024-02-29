import 'package:json_annotation/json_annotation.dart';

part 'movie_credits_people.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieCreditsPeople {
  final List<MovieCast> cast;
  final List<MovieCrew> crew;
  final int? id;

  MovieCreditsPeople(this.cast, this.crew, this.id);

  factory MovieCreditsPeople.fromJson(Map<String, dynamic> json) => _$MovieCreditsPeopleFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCreditsPeopleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieCast {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id; //1
  final String originalLanguage;
  final String? originalTitle; //1
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate; //1
  final String? title;
  final bool? video;
  final double voteAverage;
  final int voteCount;
  final String character; //1
  final String creditId;
  final int? order;

  MovieCast(
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.character,
      this.creditId,
      this.order);

  factory MovieCast.fromJson(Map<String, dynamic> json) => _$MovieCastFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieCrew {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id; //1
  final String originalLanguage;
  final String? originalTitle; //1
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double voteAverage;
  final int voteCount;
  final String creditId;
  final String department; //1
  final String job; //1

  MovieCrew(
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.creditId,
      this.department,
      this.job);

  factory MovieCrew.fromJson(Map<String, dynamic> json) => _$MovieCrewFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCrewToJson(this);
}

class MovieCreditList {
  final int id;
  final String? originalTitle;
  final String? title;
  final String? releaseDate;
  final String? character;
  final String department;
  final String? job;

  MovieCreditList({required this.id, required this.originalTitle, required this.title, required this.releaseDate,
    required this.character, required this.department, required this.job});

  factory MovieCreditList.fromCast(MovieCast cast) {
    return MovieCreditList(
      id: cast.id,
      originalTitle: cast.originalTitle,
      title: cast.title,
      releaseDate: cast.releaseDate,
      character: cast.character,
      job: null,
      department: "Actor",
    );
  }

  factory MovieCreditList.fromCrew(MovieCrew crew) {
    return MovieCreditList(
      id: crew.id,
      originalTitle: crew.originalTitle,
      title: crew.title,
      releaseDate: crew.releaseDate,
      character: null,
      job: crew.job,
      department: crew.department,
    );
  }
}