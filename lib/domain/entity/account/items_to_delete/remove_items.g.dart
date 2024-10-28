// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfItemsToRemove _$ListOfItemsToRemoveFromJson(Map<String, dynamic> json) =>
    ListOfItemsToRemove(
      (json['items'] as List<dynamic>)
          .map((e) => ItemToRemove.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOfItemsToRemoveToJson(
        ListOfItemsToRemove instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

ItemToRemove _$ItemToRemoveFromJson(Map<String, dynamic> json) => ItemToRemove(
      json['media_type'] as String,
      (json['media_id'] as num).toInt(),
    );

Map<String, dynamic> _$ItemToRemoveToJson(ItemToRemove instance) =>
    <String, dynamic>{
      'media_type': instance.mediaType,
      'media_id': instance.mediaId,
    };
