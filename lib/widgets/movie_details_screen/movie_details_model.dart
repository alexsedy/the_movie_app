import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/movie/movie_details.dart';
import 'package:the_movie_app/domain/entity/movie/movie_release_date.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  MovieDetails? _movieDetails;
  ReleaseDateRoot? _releaseDateRoot;
  final int _movieId;
  final _dateFormat = DateFormat.yMMMMd();

  MovieDetails? get movieDetails => _movieDetails;
  ReleaseDateRoot? get releaseDateRoot => _releaseDateRoot;

  MovieDetailsModel(this._movieId);

  Future<void> loadMovieDetails() async {
    _movieDetails = await _apiClient.getMovieById(_movieId);
    _releaseDateRoot = await _apiClient.getMovieDetailsReleaseDateId(_movieId);
    notifyListeners();
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "";
}