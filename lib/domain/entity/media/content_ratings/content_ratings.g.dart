// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_ratings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentRatings _$ContentRatingsFromJson(Map<String, dynamic> json) =>
    ContentRatings(
      (json['results'] as List<dynamic>)
          .map((e) => Ratings.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int?,
    );

Map<String, dynamic> _$ContentRatingsToJson(ContentRatings instance) =>
    <String, dynamic>{
      'results': instance.ratingsList.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

Ratings _$RatingsFromJson(Map<String, dynamic> json) => Ratings(
      json['descriptors'] as List<dynamic>,
      json['iso_3166_1'] as String,
      json['rating'] as String,
    );

Map<String, dynamic> _$RatingsToJson(Ratings instance) => <String, dynamic>{
      'descriptors': instance.descriptors,
      'iso_3166_1': instance.iso,
      'rating': instance.rating,
    };
