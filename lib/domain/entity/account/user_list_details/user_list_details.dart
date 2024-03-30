import 'package:json_annotation/json_annotation.dart';

part 'user_list_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserListDetails {
  final double averageRating;
  final String? backdropPath;
  final List<Result> results;
  final CreatedBy createdBy;
  final String? description;
  final int id;
  @JsonKey(name: "iso_3166_1")
  final String isoOne;
  @JsonKey(name: "iso_639_1")
  final String isoTwo;
  final int itemCount;
  final String name;
  // final ObjectIds objectIds;
  final int page;
  final String? posterPath;
  final bool public;
  final int runtime;
  final String sortBy;
  final int totalPages;
  final int totalResults;

  UserListDetails(
      this.averageRating,
      this.backdropPath,
      this.results,
      this.createdBy,
      this.description,
      this.id,
      this.isoOne,
      this.isoTwo,
      this.itemCount,
      this.name,
      // this.objectIds,
      this.page,
      this.posterPath,
      this.public,
      this.runtime,
      this.sortBy,
      this.totalPages,
      this.totalResults);

  factory UserListDetails.fromJson(Map<String, dynamic> json) => _$UserListDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserListDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatedBy {
  final String? avatarPath;
  final String? gravatarHash;
  final String id;
  final String? name;
  final String username;

  CreatedBy(
      this.avatarPath, this.gravatarHash, this.id, this.name, this.username);

  factory CreatedBy.fromJson(Map<String, dynamic> json) => _$CreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Result {
  final bool adult;
  final String? backdropPath;
  final int id;
  final String? title;
  final String originalLanguage;
  final String? originalTitle;
  final String? name;
  final String overview;
  final String? posterPath;
  final String mediaType;
  final List<int>? genreIds;
  final double? popularity;
  final String? releaseDate;
  final String? firstAirDate;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  Result(
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
      this.firstAirDate);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

// class ObjectIds {
// }