import 'package:hive/hive.dart';
import 'package:the_movie_app/data/models/firebase_entity/seasons/firebase_seasons.dart';
import 'package:the_movie_app/data/models/hive/hive_episodes/hive_episodes.dart';

part 'hive_seasons.g.dart';

@HiveType(typeId: 2)
class HiveSeasons extends HiveObject {
  @HiveField(0)
  final int seasonId;

  @HiveField(1)
  final String? airDate;

  @HiveField(2)
  final int status;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final int? episodeCount;

  @HiveField(5)
  final Map<int, HiveEpisodes>? episodes;

  HiveSeasons({
    required this.seasonId,
    this.airDate,
    required this.status,
    required this.updatedAt,
    this.episodeCount,
    this.episodes,
  });

  FirebaseSeasons toFirebaseSeason() {
    return FirebaseSeasons(
      seasonId: seasonId,
      airDate: airDate,
      status: status,
      updatedAt: updatedAt,
      episodeCount: episodeCount,
      episodes: episodes?.map((key, value) => MapEntry(key, value.toFirebaseEpisode())),
    );
  }
}