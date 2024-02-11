import 'package:json_annotation/json_annotation.dart';

part 'movie_release_date.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReleaseDateRoot {
  final int? id;
  final List<ReleaseResult> results;

  ReleaseDateRoot({required this.id, required this.results});

  factory ReleaseDateRoot.fromJson(Map<String, dynamic> json) => _$ReleaseDateRootFromJson(json);
  Map<String, dynamic> toJson() => _$ReleaseDateRootToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReleaseResult {
  @JsonKey(name: 'iso_3166_1')
  final String iso;
  final List<ReleaseDates> releaseDates;

  ReleaseResult({required this.iso, required this.releaseDates});

  factory ReleaseResult.fromJson(Map<String, dynamic> json) => _$ReleaseResultFromJson(json);
  Map<String, dynamic> toJson() => _$ReleaseResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReleaseDates {
  final String certification;
  final List<Object> descriptors;
  @JsonKey(name: 'iso_639_1')
  final String iso;
  final String note;
  final DateTime releaseDate;
  final int type;

  ReleaseDates({required this.certification, required this.descriptors, required this.iso, required this.note,
  required this.releaseDate, required this.type});

  factory ReleaseDates.fromJson(Map<String, dynamic> json) => _$ReleaseDatesFromJson(json);
  Map<String, dynamic> toJson() => _$ReleaseDatesToJson(this);
}