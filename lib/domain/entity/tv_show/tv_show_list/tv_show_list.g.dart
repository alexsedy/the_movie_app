// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowResponse _$TvShowResponseFromJson(Map<String, dynamic> json) =>
    TvShowResponse(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => TvShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$TvShowResponseToJson(TvShowResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.tvShows.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

TvShow _$TvShowFromJson(Map<String, dynamic> json) => TvShow(
      json['backdrop_path'] as String?,
      json['first_air_date'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      json['name'] as String,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['original_language'] as String,
      json['original_name'] as String,
      json['overview'] as String,
      (json['popularity'] as num).toDouble(),
      json['poster_path'] as String?,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
    );

Map<String, dynamic> _$TvShowToJson(TvShow instance) => <String, dynamic>{
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'name': instance.name,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
