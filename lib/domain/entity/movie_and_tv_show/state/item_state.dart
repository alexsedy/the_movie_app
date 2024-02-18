import 'package:json_annotation/json_annotation.dart';

part 'item_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ItemState {
  final int id;
  final bool favorite;
  final dynamic rated;
  final bool watchlist;

  ItemState(this.id, this.favorite, this.rated, this.watchlist);

  factory ItemState.fromJson(Map<String, dynamic> json) =>
      _$ItemStateFromJson(json);

  Map<String, dynamic> toJson() => _$ItemStateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Rated {
  final int? value;

  Rated(this.value);

  factory Rated.fromJson(Map<String, dynamic> json) =>
      _$RatedFromJson(json);

  Map<String, dynamic> toJson() => _$RatedToJson(this);
}