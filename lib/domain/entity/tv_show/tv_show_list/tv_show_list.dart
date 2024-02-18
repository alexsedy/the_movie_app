import 'package:json_annotation/json_annotation.dart';

part 'tv_show_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TvShowResponse {
  final int page;
  @JsonKey(name: "results")
  final List<TvShow> tvShows;
  final int totalPages;
  final int totalResults;

  TvShowResponse(this.page, this.tvShows, this.totalPages, this.totalResults);

  factory TvShowResponse.fromJson(Map<String, dynamic> json) => _$TvShowResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvShow {
  final String? backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  TvShow(
      this.backdropPath,
      this.firstAirDate,
      this.genreIds,
      this.id,
      this.name,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      this.posterPath,
      this.voteAverage,
      this.voteCount);

  factory TvShow.fromJson(Map<String, dynamic> json) => _$TvShowFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowToJson(this);
}