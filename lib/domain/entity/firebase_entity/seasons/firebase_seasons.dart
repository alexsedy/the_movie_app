import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/episodes/firebase_episodes.dart';

part 'firebase_seasons.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FirebaseSeasons {
  final int seasonId;
  final String? airDate;
  final int status;
  final DateTime updatedAt;
  final int? episodeCount;
  final Map<int, FirebaseEpisodes>? episodes;


  FirebaseSeasons({
      required this.seasonId,
      this.airDate,
      required this.status,
      required this.updatedAt,
      required this.episodeCount,
      this.episodes,
  });

  factory FirebaseSeasons.fromJson(Map<String, dynamic> json) => _$FirebaseSeasonsFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSeasonsToJson(this);
}