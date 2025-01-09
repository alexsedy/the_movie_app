import 'package:json_annotation/json_annotation.dart';

part 'firebase_episodes.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FirebaseEpisodes {
  final int episodeId;
  final String? airDate;
  final int status;

  FirebaseEpisodes({
    required this.episodeId,
    required this.airDate,
    required this.status,
  });

  factory FirebaseEpisodes.fromJson(Map<String, dynamic> json) => _$FirebaseEpisodesFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseEpisodesToJson(this);
}