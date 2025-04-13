// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_lists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLists _$UserListsFromJson(Map<String, dynamic> json) => UserLists(
      (json['page'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => Lists.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$UserListsToJson(UserLists instance) => <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

Lists _$ListsFromJson(Map<String, dynamic> json) => Lists(
      json['account_object_id'] as String,
      (json['adult'] as num).toInt(),
      (json['average_rating'] as num).toDouble(),
      json['created_at'] as String,
      json['description'] as String,
      (json['featured'] as num).toInt(),
      (json['id'] as num).toInt(),
      json['iso_3166_1'] as String,
      json['iso_639_1'] as String,
      json['name'] as String,
      (json['number_of_items'] as num).toInt(),
      (json['public'] as num).toInt(),
      (json['sort_by'] as num).toInt(),
      json['updated_at'] as String,
      json['backdrop_path'] as String?,
      json['poster_path'] as String?,
    );

Map<String, dynamic> _$ListsToJson(Lists instance) => <String, dynamic>{
      'account_object_id': instance.accountObjectId,
      'adult': instance.adult,
      'average_rating': instance.averageRating,
      'created_at': instance.createdAt,
      'description': instance.description,
      'featured': instance.featured,
      'id': instance.id,
      'iso_3166_1': instance.isoOne,
      'iso_639_1': instance.isoTwo,
      'name': instance.name,
      'number_of_items': instance.numberOfItems,
      'public': instance.public,
      'sort_by': instance.sortBy,
      'updated_at': instance.updatedAt,
      'backdrop_path': instance.backdropPath,
      'poster_path': instance.posterPath,
    };
