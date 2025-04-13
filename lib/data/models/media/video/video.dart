import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Videos {
  final int? id;
  final List<VideosResult> results;

  Videos(this.id, this.results);

  factory Videos.fromJson(Map<String, dynamic> json) =>
      _$VideosFromJson(json);

  Map<String, dynamic> toJson() => _$VideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VideosResult {
  @JsonKey(name: 'iso_639_1')
  final String isoOne;
  @JsonKey(name: 'iso_3166_1')
  final String isoTwo;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  VideosResult(this.isoOne, this.isoTwo, this.name, this.key, this.site,
      this.size, this.type, this.official, this.publishedAt, this.id);

  factory VideosResult.fromJson(Map<String, dynamic> json) =>
      _$VideosResultFromJson(json);

  Map<String, dynamic> toJson() => _$VideosResultToJson(this);
}