// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDetails _$PersonDetailsFromJson(Map<String, dynamic> json) =>
    PersonDetails(
      json['adult'] as bool,
      (json['also_known_as'] as List<dynamic>).map((e) => e as String).toList(),
      json['biography'] as String,
      json['birthday'] as String?,
      json['deathday'] as String?,
      json['gender'] as int,
      json['homepage'] as String?,
      json['id'] as int,
      json['imdb_id'] as String?,
      json['known_for_department'] as String,
      json['name'] as String,
      json['place_of_birth'] as String?,
      (json['popularity'] as num).toDouble(),
      json['profile_path'] as String?,
      ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>),
      json['images'] == null
          ? null
          : Images.fromJson(json['images'] as Map<String, dynamic>),
      Credits.fromJson(json['movie_credits'] as Map<String, dynamic>),
      Credits.fromJson(json['tv_credits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonDetailsToJson(PersonDetails instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'also_known_as': instance.alsoKnownAs,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'gender': instance.gender,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'place_of_birth': instance.placeOfBirth,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'external_ids': instance.externalIds.toJson(),
      'images': instance.images?.toJson(),
      'movie_credits': instance.movieCredits.toJson(),
      'tv_credits': instance.tvCredits.toJson(),
    };
