import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/seasons/firebase_seasons.dart';

part 'firebase_tv_shows.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FirebaseTvShow {
  final int tvShowId;
  final String? tvShowName;
  final String? firstAirDate;
  final int status;
  final DateTime updatedAt;
  final DateTime? addedAt;
  final Map<int, FirebaseSeasons>? seasons;


  FirebaseTvShow({
      required this.tvShowId,
      this.tvShowName,
      this.firstAirDate,
      required this.status,
      required this.updatedAt,
      this.addedAt,
      this.seasons
  });

  factory FirebaseTvShow.fromJson(Map<String, dynamic> json) => _$FirebaseTvShowFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseTvShowToJson(this);
}