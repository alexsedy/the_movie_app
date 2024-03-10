import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/state/item_state.dart';
import 'package:the_movie_app/domain/entity/tv_show/details/tv_show_details.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';


class TvShowDetailsModel extends ChangeNotifier {
  final _apiClient = TvShowApiClient();
  TvShowDetails? _tvShowDetails;
  ItemState? _tvShowState;
  AccountSate? _accountSate;
  final int _seriesId;
  final _dateFormat = DateFormat.yMMMMd();
  final _dateFormatTwo = DateFormat.yMMMd();
  bool _isFavorite = false;

  TvShowDetails? get tvShowDetails => _tvShowDetails;
  ItemState? get tvShowState => _tvShowState;
  bool get isFavorite => _isFavorite;

  TvShowDetailsModel(this._seriesId);

  Future<void> loadTvShowDetails() async {
    _tvShowDetails = await _apiClient.getTvShowById(_seriesId);
    _tvShowState = await _apiClient.getTvShowState(_seriesId);

    final favorite = _tvShowState?.favorite;
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
      tvShowId: _seriesId,
      isFavorite: _isFavorite,
    );

    notifyListeners();
  }

  void onCastListTab(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListTab(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsTab(BuildContext context, int index) {
    final id = _tvShowDetails?.credits.cast[index].id;
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


  String formatDateTwo(String? date) =>
      date != "" ? _dateFormatTwo.format(DateTime.parse(date ?? "")) : "";
}