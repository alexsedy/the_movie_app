import 'package:json_annotation/json_annotation.dart';

part 'season.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Season {
  final String? sId;
  final String? airDate;
  final List<Episode> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season(this.sId, this.airDate, this.episodes, this.name, this.overview,
      this.id, this.posterPath, this.seasonNumber, this.voteAverage);

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Episode {
  final String? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  // final List<Crew>? crew;
  // final List<GuestStar>? guestStars;

  Episode(
      this.airDate,
      this.episodeNumber,
      this.id,
      this.name,
      this.overview,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.showId,
      this.stillPath,
      this.voteAverage,
      this.voteCount,
      // this.crew,
      // this.guestStars
      );

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

// @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
// class GuestStar {
//   final String character;
//   final String creditId;
//   final int order;
//   final bool adult;
//   final int gender;
//   final int id;
//   final String knownForDepartment;
//   final String name;
//   final String originalName;
//   final double popularity;
//   final String profilePath;
//
//   GuestStar(
//       this.character,
//       this.creditId,
//       this.order,
//       this.adult,
//       this.gender,
//       this.id,
//       this.knownForDepartment,
//       this.name,
//       this.originalName,
//       this.popularity,
//       this.profilePath);
// }