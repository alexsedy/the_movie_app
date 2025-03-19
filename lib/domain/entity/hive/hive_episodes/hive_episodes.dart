import 'package:hive/hive.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/episodes/firebase_episodes.dart';

part 'hive_episodes.g.dart';

@HiveType(typeId: 3)
class HiveEpisodes extends HiveObject {
  @HiveField(0)
  final int episodeId;

  @HiveField(1)
  final String? airDate;

  @HiveField(2)
  final int status;

  HiveEpisodes({
    required this.episodeId,
    required this.airDate,
    required this.status,
  });

  FirebaseEpisodes toFirebaseEpisode() {
    return FirebaseEpisodes(
      episodeId: episodeId,
      airDate: airDate,
      status: status,
    );
  }
}