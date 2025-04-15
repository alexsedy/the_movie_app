import 'package:json_annotation/json_annotation.dart';

part 'remove_items.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ListOfItemsToRemove {
  final List<ItemToRemove> items;

  ListOfItemsToRemove(this.items);

  factory ListOfItemsToRemove.fromJson(Map<String, dynamic> json) => _$ListOfItemsToRemoveFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfItemsToRemoveToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ItemToRemove {
  final String mediaType;
  final int mediaId;

  ItemToRemove(this.mediaType, this.mediaId);

  factory ItemToRemove.fromJson(Map<String, dynamic> json) => _$ItemToRemoveFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToRemoveToJson(this);
}