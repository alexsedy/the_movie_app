import 'package:json_annotation/json_annotation.dart';

part 'account_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AccountSate {
  Avatar avatar;
  int id;
  @JsonKey(name: "iso_639_1")
  String isoOne;
  @JsonKey(name: "iso_3166_1")
  String isoTwo;
  String name;
  bool includeAdult;
  String username;

  AccountSate({
    required this.avatar,
    required this.id,
    required this.isoOne,
    required this.isoTwo,
    required this.name,
    required this.includeAdult,
    required this.username,
  });

  factory AccountSate.fromJson(Map<String, dynamic> json) => _$AccountSateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Avatar {
  Gravatar gravatar;
  Tmdb tmdb;

  Avatar({
    required this.gravatar,
    required this.tmdb,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Gravatar {
  String hash;

  Gravatar({
    required this.hash,
  });

  factory Gravatar.fromJson(Map<String, dynamic> json) => _$GravatarFromJson(json);

  Map<String, dynamic> toJson() => _$GravatarToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Tmdb {
  String? avatarPath;

  Tmdb({
    required this.avatarPath,
  });

  factory Tmdb.fromJson(Map<String, dynamic> json) => _$TmdbFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbToJson(this);
}
