import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/data/models/account/user_list_details/user_list_details.dart';

part 'media_collections.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CollectionsList {
  final int page;
  final List<MediaCollections> results;
  final int totalPages;
  final int totalResults;

  CollectionsList(this.page, this.results, this.totalPages, this.totalResults);

  factory CollectionsList.fromJson(Map<String, dynamic> json) => _$CollectionsListFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionsListToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MediaCollections {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? originalLanguage;
  final String? originalName;
  final List<UserListResult>? parts;

  MediaCollections(this.id, this.name, this.overview, this.posterPath, this.backdropPath,
      this.parts, this.originalLanguage, this.originalName);

  factory MediaCollections.fromJson(Map<String, dynamic> json) => _$MediaCollectionsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaCollectionsToJson(this);
}