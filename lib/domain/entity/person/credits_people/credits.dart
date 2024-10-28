import 'package:json_annotation/json_annotation.dart';

part 'credits.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Credits {
  final List<Cast> cast;
  final List<Crew> crew;
  final List<Cast>? guestStars;
  final int? id;

  Credits(this.cast, this.crew, this.id, this.guestStars);

  factory Credits.fromJson(Map<String, dynamic> json) => _$CreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Cast {
  final bool adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String character;
  final String creditId;
  final int? order;
  final List<String>? originCountry;
  final String? originalName;
  final String? firstAirDate;
  final String? name;
  final int? episodeCount;
  final String? profilePath;

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
      this.order,
      this.originCountry,
      this.originalName,
      this.firstAirDate,
      this.name,
      this.episodeCount,
      this.profilePath);

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Crew {
  final bool adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String creditId;
  final String department;
  final String job;
  final List<String>? originCountry;
  final String? originalName;
  final String? firstAirDate;
  final String? name;
  final int? episodeCount;
  final String? profilePath;

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
      this.job,
      this.originCountry,
      this.originalName,
      this.firstAirDate,
      this.name,
      this.episodeCount,
      this.profilePath);

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
  final String? posterPath;
  final int? episodeCount;
  final String originalName;
  final String? name;
  final String? firstAirDate;

  CreditList({required this.id, required this.originalTitle, required this.title, required this.releaseDate,
    required this.character, required this.department, required this.job, required this.posterPath,
    required this.episodeCount, required this.originalName, required this.name, required this.firstAirDate,
  });

  factory CreditList.fromCast(Cast cast) {
    return CreditList(
      id: cast.id,
      originalTitle: cast.originalTitle,
      title: cast.title,
      releaseDate: cast.releaseDate,
      character: cast.character,
      job: null,
      posterPath: cast.posterPath,
      department: "Actor",
      episodeCount: cast.episodeCount,
      originalName: cast.originalName ?? "",
      name: cast.name, firstAirDate: cast.firstAirDate,
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
      posterPath: crew.posterPath,
      department: crew.department,
      episodeCount: crew.episodeCount,
      originalName: crew.originalName ?? '',
      name: crew.name,
      firstAirDate: crew.firstAirDate,
    );
  }
}