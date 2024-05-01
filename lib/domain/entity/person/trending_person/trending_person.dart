import 'package:json_annotation/json_annotation.dart';

part 'trending_person.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrendingPerson {
  final int page;
  @JsonKey(name: "results")
  final List<TrendingPersonList> trendingPersonList;
  final int totalPages;
  final int totalResults;

  TrendingPerson(this.page, this.trendingPersonList, this.totalPages, this.totalResults);

  factory TrendingPerson.fromJson(Map<String, dynamic> json) => _$TrendingPersonFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingPersonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class KnownFor {
  final bool adult;
  final String? backdropPath;
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String mediaType;
  final List<int> genreIds;
  final double popularity;
  final String? releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String name;
  final String originalName;
  final String firstAirDate;
  final List<String> originCountry;

  KnownFor(
      this.adult,
      this.backdropPath,
      this.id,
      this.title,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.mediaType,
      this.genreIds,
      this.popularity,
      this.releaseDate,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.name,
      this.originalName,
      this.firstAirDate,
      this.originCountry);

  factory KnownFor.fromJson(Map<String, dynamic> json) => _$KnownForFromJson(json);

  Map<String, dynamic> toJson() => _$KnownForToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrendingPersonList {
  final bool adult;
  final int id;
  final String name;
  final String originalName;
  final String mediaType;
  final double popularity;
  final int gender;
  final String? knownForDepartment;
  final String? profilePath;
  // final List<KnownFor> knownFor;

  TrendingPersonList(
      this.adult,
      this.id,
      this.name,
      this.originalName,
      this.mediaType,
      this.popularity,
      this.gender,
      this.knownForDepartment,
      this.profilePath,
      // this.knownFor
      );

  factory TrendingPersonList.fromJson(Map<String, dynamic> json) => _$TrendingPersonListFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingPersonListToJson(this);
}
