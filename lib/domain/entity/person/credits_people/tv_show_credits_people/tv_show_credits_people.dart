import 'package:json_annotation/json_annotation.dart';

part 'tv_show_credits_people.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TvShowCreditsPeople {
  final List<TvShowCast> cast;
  final List<TvShowCrew> crew;
  final int? id;

  TvShowCreditsPeople(this.cast, this.crew, this.id);

  factory TvShowCreditsPeople.fromJson(Map<String, dynamic> json) => _$TvShowCreditsPeopleFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowCreditsPeopleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvShowCast {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double voteAverage;
  final int voteCount;
  final String character;
  final String creditId;
  final int episodeCount;

  TvShowCast(
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      this.posterPath,
      this.firstAirDate,
      this.name,
      this.voteAverage,
      this.voteCount,
      this.character,
      this.creditId,
      this.episodeCount);

  factory TvShowCast.fromJson(Map<String, dynamic> json) => _$TvShowCastFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvShowCrew {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double voteAverage;
  final int voteCount;
  final String creditId;
  final String department;
  final int? episodeCount;
  final String job;

  TvShowCrew(
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      this.posterPath,
      this.firstAirDate,
      this.name,
      this.voteAverage,
      this.voteCount,
      this.creditId,
      this.department,
      this.episodeCount,
      this.job);

  factory TvShowCrew.fromJson(Map<String, dynamic> json) => _$TvShowCrewFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowCrewToJson(this);
}

class TvShowCreditList {
  final int id;
  final int? episodeCount;
  final String originalName;
  final String? name;
  final String? firstAirDate;
  final String? character;
  final String department;
  final String? posterPath;
  final String? job;

  TvShowCreditList({required this.id, required this.episodeCount, required this.originalName,
    required this.name, required this.firstAirDate, required this.character, required this.department,
    required this.job, required this.posterPath});

  factory TvShowCreditList.fromCast(TvShowCast cast) {
    return TvShowCreditList(
      id: cast.id,
      episodeCount: cast.episodeCount,
      originalName: cast.originalName,
      name: cast.name,
      firstAirDate: cast.firstAirDate,
      character: cast.character,
      job: null,
      posterPath: cast.posterPath,
      department: "Actor",
    );
  }

  factory TvShowCreditList.fromCrew(TvShowCrew crew) {
    return TvShowCreditList(
      id: crew.id,
      episodeCount: crew.episodeCount,
      originalName: crew.originalName,
      name: crew.name,
      firstAirDate: crew.firstAirDate,
      character: null,
      job: crew.job,
      posterPath: crew.posterPath,
      department: crew.department,
    );
  }
}