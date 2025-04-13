import 'package:json_annotation/json_annotation.dart';

part 'external_ids.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExternalIds {
  final int? id;
  final String? freebaseMid;
  final String? freebaseId;
  final String? imdbId;
  @JsonKey(name: "tvrage_id")
  final int? tvRageId;
  final String? wikidataId;
  final String? facebookId;
  final String? instagramId;
  final String? tiktokId;
  final String? twitterId;
  final String? youtubeId;

  ExternalIds(
      this.id,
      this.freebaseMid,
      this.freebaseId,
      this.imdbId,
      this.tvRageId,
      this.wikidataId,
      this.facebookId,
      this.instagramId,
      this.tiktokId,
      this.twitterId,
      this.youtubeId);

  factory ExternalIds.fromJson(Map<String, dynamic> json) => _$ExternalIdsFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}
