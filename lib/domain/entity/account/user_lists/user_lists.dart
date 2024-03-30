import 'package:json_annotation/json_annotation.dart';

part 'user_lists.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserLists {
  final int page;
  final List<Lists> results;
  final int totalPages;
  final int totalResults;

  UserLists(this.page, this.results, this.totalPages, this.totalResults);

  factory UserLists.fromJson(Map<String, dynamic> json) => _$UserListsFromJson(json);

  Map<String, dynamic> toJson() => _$UserListsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Lists {
  final String accountObjectId;
  final int adult;
  final double averageRating;
  final String createdAt;
  final String description;
  final int featured;
  final int id;
  @JsonKey(name: "iso_3166_1")
  final String isoOne;
  @JsonKey(name: "iso_639_1")
  final String isoTwo;
  final String name;
  final int numberOfItems;
  final int public;
  // final String? revenue;
  // final int runtime;
  final int sortBy;
  final String updatedAt;
  final String? backdropPath;
  final String? posterPath;

  Lists(
      this.accountObjectId,
      this.adult,
      this.averageRating,
      this.createdAt,
      this.description,
      this.featured,
      this.id,
      this.isoOne,
      this.isoTwo,
      this.name,
      this.numberOfItems,
      this.public,
      // this.revenue,
      // this.runtime,
      this.sortBy,
      this.updatedAt,
      this.backdropPath,
      this.posterPath);

  factory Lists.fromJson(Map<String, dynamic> json) => _$ListsFromJson(json);

  Map<String, dynamic> toJson() => _$ListsToJson(this);
}