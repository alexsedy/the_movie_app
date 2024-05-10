import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/domain/entity/media/content_ratings/content_ratings.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/release/release_date.dart';
import 'package:the_movie_app/domain/entity/media/video/video.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';

part 'media_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MediaDetails {
  final bool? adult;
  final String? backdropPath;
  final BelongsToCollection? belongsToCollection;
  final int? budget;
  final List<Genre>? genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompanie>? productionCompanies;
  final List<ProductionCountrie>? productionCountries;
  final String? releaseDate;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? title;
  final bool? video;
  final double voteAverage;
  final int voteCount;
  final ReleaseDateRoot? releaseDates;
  final Credits credits;
  final Videos videos;
  final List<CreatedBy>? createdBy;
  final List<int>? episodeRunTime;
  final String? firstAirDate;
  final bool? inProduction;
  final List<String>? languages;
  final String? lastAirDate;
  final LastEpisodeToAir? lastEpisodeToAir;
  final String? name;
  final NextEpisodeToAir? nextEpisodeToAir;
  final List<Network>? networks;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<String>? originCountry;
  final String? originalName;
  final List<Seasons>? seasons;
  final String? type;
  final ContentRatings? contentRatings;
  final String? airDate;
  final String? stillPath;
  final MediaListResponse? recommendations;

  MediaDetails(
      this.adult,
      this.backdropPath,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.productionCountries,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.releaseDates,
      this.credits,
      this.videos,
      this.createdBy,
      this.episodeRunTime,
      this.firstAirDate,
      this.inProduction,
      this.languages,
      this.lastAirDate,
      this.lastEpisodeToAir,
      this.name,
      this.nextEpisodeToAir,
      this.networks,
      this.numberOfEpisodes,
      this.numberOfSeasons,
      this.originCountry,
      this.originalName,
      this.seasons,
      this.type,
      this.contentRatings,
      this.airDate,
      this.stillPath,
      this.recommendations,);

  factory MediaDetails.fromJson(Map<String, dynamic> json) => _$MediaDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BelongsToCollection {
  final int id;
  final String? name;
  final String? posterPath;
  final String? backdropPath;

  BelongsToCollection(this.id, this.name, this.posterPath, this.backdropPath);

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) =>
      _$BelongsToCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BelongsToCollectionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Genre {
  final int id;
  final String name;
  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCompanie {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;
  ProductionCompanie({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompanie.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanieFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanieToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCountrie {
  @JsonKey(name: 'iso_3166_1')
  final String iso;
  final String name;
  ProductionCountrie({
    required this.iso,
    required this.name,
  });

  factory ProductionCountrie.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountrieFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountrieToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SpokenLanguage {
  @JsonKey(name: 'iso_639_1')
  final String iso;
  final String name;

  SpokenLanguage({
    required this.iso,
    required this.name,
  });
  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;

  CreatedBy(this.id, this.creditId, this.name, this.gender, this.profilePath);

  factory CreatedBy.fromJson(Map<String, dynamic> json) => _$CreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LastEpisodeToAir {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  LastEpisodeToAir(
      this.id,
      this.name,
      this.overview,
      this.voteAverage,
      this.voteCount,
      this.airDate,
      this.episodeNumber,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.showId,
      this.stillPath);

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) => _$LastEpisodeToAirFromJson(json);

  Map<String, dynamic> toJson() => _$LastEpisodeToAirToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NextEpisodeToAir {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  NextEpisodeToAir(
      this.id,
      this.name,
      this.overview,
      this.voteAverage,
      this.voteCount,
      this.airDate,
      this.episodeNumber,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.showId,
      this.stillPath);

  factory NextEpisodeToAir.fromJson(Map<String, dynamic> json) => _$NextEpisodeToAirFromJson(json);

  Map<String, dynamic> toJson() => _$NextEpisodeToAirToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Network {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Network(this.id, this.logoPath, this.name, this.originCountry);

  factory Network.fromJson(Map<String, dynamic> json) => _$NetworkFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany(this.id, this.logoPath, this.name, this.originCountry);

  factory ProductionCompany.fromJson(Map<String, dynamic> json) => _$ProductionCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCountry {
  @JsonKey(name: 'iso_3166_1')
  final String iso;
  final String name;

  ProductionCountry(this.iso, this.name);

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => _$ProductionCountryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Seasons {
  int? tvShowId;
  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Seasons(this.airDate, this.episodeCount, this.id, this.name, this.overview,
      this.posterPath, this.seasonNumber, this.voteAverage, this.tvShowId);

  factory Seasons.fromJson(Map<String, dynamic> json) => _$SeasonsFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonsToJson(this);
}
