import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthData {
  String? accountId;
  String? accessToken;

  AuthData({this.accountId, this.accessToken});

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);

}