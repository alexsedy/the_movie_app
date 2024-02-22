import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_movie_app/domain/entity/movie/details/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = MovieApiClient();
  MovieDetails? _movieDetails;
  ItemState? _movieState;
  AccountSate? _accountSate;
  final int _movieId;
  final _dateFormat = DateFormat.yMMMMd();
  bool _isFavorite = false;

  MovieDetails? get movieDetails => _movieDetails;
  ItemState? get movieState => _movieState;
  bool get isFavorite => _isFavorite;

  MovieDetailsModel(this._movieId);

  Future<void> loadMovieDetails() async {
    _movieDetails = await _apiClient.getMovieById(_movieId);
    _movieState = await _apiClient.getMovieState(_movieId);

    final favorite = _movieState?.favorite;
    if(favorite != null) {
      _isFavorite = favorite;
    }

    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    _accountSate = await AccountManager.getAccountData();
    final accountId = _accountSate?.id;
    if(accountId == null) {
      return;
    }

    _isFavorite = !_isFavorite;

    await _apiClient.makeFavorite(
      accountId: accountId,
      movieId: _movieId,
      isFavorite: _isFavorite,
    );

    notifyListeners();
  }

  void onMovieCast(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieCast, arguments: cast);
  }

  void onMovieCrew(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieCrew, arguments: crew);
  }

  Future<void> launchYouTubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "";
}