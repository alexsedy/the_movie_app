// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSate _$AccountSateFromJson(Map<String, dynamic> json) => AccountSate(
      avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      id: json['id'] as int,
      isoOne: json['iso_639_1'] as String,
      isoTwo: json['iso_3166_1'] as String,
      name: json['name'] as String,
      includeAdult: json['include_adult'] as bool,
      username: json['username'] as String,
    );

Map<String, dynamic> _$AccountSateToJson(AccountSate instance) =>
    <String, dynamic>{
      'avatar': instance.avatar.toJson(),
      'id': instance.id,
      'iso_639_1': instance.isoOne,
      'iso_3166_1': instance.isoTwo,
      'name': instance.name,
      'include_adult': instance.includeAdult,
      'username': instance.username,
    };

Avatar _$AvatarFromJson(Map<String, dynamic> json) => Avatar(
      gravatar: Gravatar.fromJson(json['gravatar'] as Map<String, dynamic>),
      tmdb: Tmdb.fromJson(json['tmdb'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'gravatar': instance.gravatar.toJson(),
      'tmdb': instance.tmdb.toJson(),
    };

Gravatar _$GravatarFromJson(Map<String, dynamic> json) => Gravatar(
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$GravatarToJson(Gravatar instance) => <String, dynamic>{
      'hash': instance.hash,
    };

Tmdb _$TmdbFromJson(Map<String, dynamic> json) => Tmdb(
      avatarPath: json['avatar_path'] as String?,
    );

Map<String, dynamic> _$TmdbToJson(Tmdb instance) => <String, dynamic>{
      'avatar_path': instance.avatarPath,
    };
