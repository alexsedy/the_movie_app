// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      (json['id'] as num?)?.toInt(),
      (json['profiles'] as List<dynamic>)
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'profiles': instance.profiles.map((e) => e.toJson()).toList(),
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      (json['aspect_ratio'] as num).toDouble(),
      (json['height'] as num).toInt(),
      json['iso_639_1'] as String?,
      json['file_path'] as String,
      (json['vote_average'] as num).toDouble(),
      (json['vote_count'] as num).toInt(),
      (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'height': instance.height,
      'iso_639_1': instance.iso,
      'file_path': instance.filePath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
    };
