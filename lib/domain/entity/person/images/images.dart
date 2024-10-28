import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Images {
  final int? id;
  final List<Profile> profiles;

  Images(this.id, this.profiles);

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Profile {
  final double aspectRatio;
  final int height;
  @JsonKey(name: "iso_639_1")
  final String? iso;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Profile(this.aspectRatio, this.height, this.iso, this.filePath,
      this.voteAverage, this.voteCount, this.width);

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}