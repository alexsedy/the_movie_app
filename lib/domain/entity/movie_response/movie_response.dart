import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_app/domain/entity/movie/movie.dart';

part "movie_response.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieResponse{
  final int page;
  @JsonKey(name: "results")
  final List<Movie> movies;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}