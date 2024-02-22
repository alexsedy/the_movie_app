import 'package:json_annotation/json_annotation.dart';

part 'content_ratings.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ContentRatings {
  @JsonKey(name: "results")
  final List<Ratings> ratingsList;
  final int? id;

  ContentRatings(this.ratingsList, this.id);

  factory ContentRatings.fromJson(Map<String, dynamic> json) => _$ContentRatingsFromJson(json);

  Map<String, dynamic> toJson() => _$ContentRatingsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Ratings {
  final List<dynamic> descriptors;
  @JsonKey(name: "iso_3166_1")
  final String iso;
  final String rating;

  Ratings(this.descriptors, this.iso, this.rating);

  factory Ratings.fromJson(Map<String, dynamic> json) => _$RatingsFromJson(json);

  Map<String, dynamic> toJson() => _$RatingsToJson(this);
}