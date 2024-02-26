import 'package:json_annotation/json_annotation.dart';

part 'credits_people.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreditsPeople {
  final List<Cast> cast;
  final List<Crew> crew;
  final int? id;

  CreditsPeople(this.cast, this.crew, this.id);

  factory CreditsPeople.fromJson(Map<String, dynamic> json) => _$CreditsPeopleFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsPeopleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Cast {
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

  Cast(
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

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Crew {
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

  Crew(
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

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  Map<String, dynamic> toJson() => _$CrewToJson(this);
}

class CreditList {
  final int id;
  final String? originalTitle;
  final String? title;
  final String? releaseDate;
  final String? character;
  final String department;
  final String? job;

  CreditList({required this.id, required this.originalTitle, required this.title, required this.releaseDate,
    required this.character, required this.department, required this.job});

  factory CreditList.fromCast(Cast cast) {
    return CreditList(
      id: cast.id,
      originalTitle: cast.originalTitle,
      title: cast.title,
      releaseDate: cast.releaseDate,
      character: cast.character,
      job: null,
      department: "Actor",
    );
  }

  factory CreditList.fromCrew(Crew crew) {
    return CreditList(
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