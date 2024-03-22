// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemState _$ItemStateFromJson(Map<String, dynamic> json) => ItemState(
      json['id'] as int,
      json['favorite'] as bool,
      const RatedConverter().fromJson(json['rated']),
      json['watchlist'] as bool,
    );

Map<String, dynamic> _$ItemStateToJson(ItemState instance) => <String, dynamic>{
      'id': instance.id,
      'favorite': instance.favorite,
      'rated': const RatedConverter().toJson(instance.rated),
      'watchlist': instance.watchlist,
    };

Rated _$RatedFromJson(Map<String, dynamic> json) => Rated(
      (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RatedToJson(Rated instance) => <String, dynamic>{
      'value': instance.value,
    };
