import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/domain/entity/account/user_list_details/user_list_details.dart';

part 'media_collections.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MediaCollections {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<UserListResult> parts;

  MediaCollections(this.id, this.name, this.overview, this.posterPath, this.backdropPath,
      this.parts);

  factory MediaCollections.fromJson(Map<String, dynamic> json) => _$MediaCollectionsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaCollectionsToJson(this);
}