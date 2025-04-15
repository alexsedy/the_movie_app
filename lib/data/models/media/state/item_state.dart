import 'package:json_annotation/json_annotation.dart';

part 'item_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ItemState {
  final int id;
  final bool favorite;
  @RatedConverter()
  final Rated? rated;
  final bool watchlist;

  ItemState(this.id, this.favorite, this.rated, this.watchlist);

  factory ItemState.fromJson(Map<String, dynamic> json) =>
      _$ItemStateFromJson(json);

  Map<String, dynamic> toJson() => _$ItemStateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Rated {
  final double? value;

  Rated(this.value);

  factory Rated.fromJson(Map<String, dynamic> json) =>
      _$RatedFromJson(json);

  Map<String, dynamic> toJson() => _$RatedToJson(this);
}

class RatedConverter implements JsonConverter<Rated?, Object?> {
  const RatedConverter();

  @override
  Rated? fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      return Rated.fromJson(json);
    } else if (json == false) {
      return null;
    } else {
      throw ArgumentError('Invalid JSON value for Rated');
    }
  }

  @override
  Object? toJson(Rated? instance) => instance?.toJson();
}