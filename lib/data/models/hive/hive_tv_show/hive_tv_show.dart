import 'package:hive/hive.dart';
import 'package:the_movie_app/data/models/firebase_entity/tv_shows/firebase_tv_shows.dart';
import 'package:the_movie_app/data/models/hive/hive_seasons/hive_seasons.dart';

part 'hive_tv_show.g.dart';

@HiveType(typeId: 1)
class HiveTvShow extends HiveObject {
  @HiveField(0)
  final int tvShowId;

  @HiveField(1)
  final String? tvShowName;

  @HiveField(2)
  final String? firstAirDate;

  @HiveField(3)
  final int status;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final DateTime? addedAt;

  @HiveField(6)
  final DateTime autoSyncDate;

  @HiveField(7)
  final Map<int, HiveSeasons>? seasons;

  HiveTvShow({
    required this.tvShowId,
    this.tvShowName,
    this.firstAirDate,
    required this.status,
    required this.updatedAt,
    required this.autoSyncDate,
    this.addedAt,
    this.seasons,
  });

  FirebaseTvShow toFirebaseTvShow() {
    return FirebaseTvShow(
      tvShowId: tvShowId,
      tvShowName: tvShowName,
      firstAirDate: firstAirDate,
      status: status,
      updatedAt: updatedAt,
      addedAt: addedAt,
      seasons: seasons?.map((key, value) => MapEntry(key, value.toFirebaseSeason())),
    );
  }
}