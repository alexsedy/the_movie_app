import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MediaListResponse{
  final int page;
  @JsonKey(name: "results")
  final List<MediaList> list;
  final int totalPages;
  final int totalResults;

  MediaListResponse({
    required this.page,
    required this.list,
    required this.totalPages,
    required this.totalResults});

  factory MediaListResponse.fromJson(Map<String, dynamic> json) => _$MediaListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MediaListResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MediaList {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String? firstAirDate;
  final String? name;
  final List<String>? originCountry;
  final String? originalName;
  final String? mediaType;

  MediaList(
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
      this.firstAirDate,
      this.name,
      this.originCountry,
      this.originalName,
      this.mediaType,
      );


  factory MediaList.fromJson(Map<String, dynamic> json) => _$MediaListFromJson(json);

  Map<String, dynamic> toJson() => _$MediaListToJson(this);
}