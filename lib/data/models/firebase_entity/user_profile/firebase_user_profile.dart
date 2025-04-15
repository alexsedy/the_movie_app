import 'package:json_annotation/json_annotation.dart';

part 'firebase_user_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FirebaseUserProfile {
  String? firebaseUid;
  String? tmdbAccountId;
  String? email;
  String? tmdbUsername;
  DateTime? linkedAt;

  FirebaseUserProfile({
    this.firebaseUid,
    this.tmdbAccountId,
    this.email,
    this.tmdbUsername,
    this.linkedAt
  });

  factory FirebaseUserProfile.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseUserProfileToJson(this);
}