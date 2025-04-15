// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseUserProfile _$FirebaseUserProfileFromJson(Map<String, dynamic> json) =>
    FirebaseUserProfile(
      firebaseUid: json['firebase_uid'] as String?,
      tmdbAccountId: json['tmdb_account_id'] as String?,
      email: json['email'] as String?,
      tmdbUsername: json['tmdb_username'] as String?,
      linkedAt: json['linked_at'] == null
          ? null
          : DateTime.parse(json['linked_at'] as String),
    );

Map<String, dynamic> _$FirebaseUserProfileToJson(
        FirebaseUserProfile instance) =>
    <String, dynamic>{
      'firebase_uid': instance.firebaseUid,
      'tmdb_account_id': instance.tmdbAccountId,
      'email': instance.email,
      'tmdb_username': instance.tmdbUsername,
      'linked_at': instance.linkedAt?.toIso8601String(),
    };
