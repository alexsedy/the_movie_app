import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_movie_app/domain/entity/movie/details/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = MovieApiClient();
  MovieDetails? _movieDetails;
  ItemState? _movieState;
  final int _movieId;
  final _dateFormat = DateFormat.yMMMMd();
  bool _isFavorite = false;
  bool _isWatched = false;

  MovieDetails? get movieDetails => _movieDetails;
  ItemState? get movieState => _movieState;
  bool get isFavorite => _isFavorite;
  bool get isWatched => _isWatched;

  MovieDetailsModel(this._movieId);

  Future<void> loadMovieDetails() async {
    _movieDetails = await _apiClient.getMovieById(_movieId);
    _movieState = await _apiClient.getMovieState(_movieId);

    if(_movieState != null) {
      _isFavorite = _movieState?.favorite ?? false;
      _isWatched = _movieState?.watchlist ?? false;
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final result = await SnackBarHelper.handleError(
      apiReq: () => _apiClient.addToFavorite(movieId: _movieId, isFavorite: _isFavorite,),
      context: context,
    );
    if(result) {
      _isFavorite = !_isFavorite;
      notifyListeners();
    }
  }

  Future<void> toggleWatchlist(BuildContext context) async {
    final result = await SnackBarHelper.handleError(
      apiReq: () => _apiClient.addToWatchlist(movieId: _movieId, isWatched: _isWatched,),
      context: context,
    );
    if(result) {
      _isWatched = !_isWatched;
      notifyListeners();
    }
  }

  void onCastListTab(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListTab(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsTab(BuildContext context, int index) {
    final id = _movieDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
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