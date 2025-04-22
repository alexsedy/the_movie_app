import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/models/person/details/person_details.dart';
import 'package:the_movie_app/data/repositories/i_people_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleDetailsViewModel extends ChangeNotifier {
  final int _personId;
  final IPeopleRepository _peopleRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  PersonDetails? _personDetails;
  final List<CreditList> _movieCreditList = [];
  final List<CreditList> _tvShowCreditList = [];
  final _movieStatuses = <HiveMovies>[];
  final _tvShowStatuses = <HiveTvShow>[];
  bool _isLoading = true;
  final _order = const {
    'Actor': 0, 'Directing': 1, 'Writing': 2, 'Production': 3,
    'Sound': 4, 'Camera': 5, 'Editing': 6, 'Visual Effects': 7,
    'Art': 8, 'Costume & Make-Up': 9, 'Crew': 10, 'Lighting': 11,
  };


  PersonDetails? get personDetails => _personDetails;
  List<CreditList> get movieCreditList => List.unmodifiable(_movieCreditList);
  List<CreditList> get tvShowCreditList => List.unmodifiable(_tvShowCreditList);
  List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);
  List<HiveTvShow> get tvShowStatuses => List.unmodifiable(_tvShowStatuses);
  bool get isLoading => _isLoading;


  PeopleDetailsViewModel(
      this._personId,
      this._peopleRepository,
      this._localMediaTrackingService,
      ) {
    _loadDetails();
  }


  Future<void> _loadDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _personDetails = await _peopleRepository.getPersonById(_personId);
      _movieCreditList.clear();
      _tvShowCreditList.clear();
      _addAndSortMovieCredits();
      _addAndSortTvShowCredits();
      await _getMovieStatuses();
      await _getTvShowStatuses();

    } catch (e) {
      print("Error loading person details: $e");
      // TODO: Обработка ошибок
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addAndSortMovieCredits() {
    final movieCredits = _personDetails?.movieCredits;
    if (movieCredits == null) return;

    _movieCreditList.addAll(movieCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _movieCreditList.addAll(movieCredits.crew.map((crew) => CreditList.fromCrew(crew)));

    _movieCreditList.sort((a, b) {
      int departmentComparison = (_order[a.department] ?? 99) - (_order[b.department] ?? 99);
      if (departmentComparison == 0) {
        return (b.releaseDate ?? "0").compareTo(a.releaseDate ?? "0");
      }
      return departmentComparison;
    });
  }

  void _addAndSortTvShowCredits() {
    final tvCredits = _personDetails?.tvCredits;
    if (tvCredits == null) return;

    _tvShowCreditList.addAll(tvCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _tvShowCreditList.addAll(tvCredits.crew.map((crew) => CreditList.fromCrew(crew)));

    _tvShowCreditList.sort((a, b) {
      int departmentComparison = (_order[a.department] ?? 99) - (_order[b.department] ?? 99);
      if (departmentComparison == 0) {
        return (b.firstAirDate ?? "0").compareTo(a.firstAirDate ?? "0");
      }
      return departmentComparison;
    });
  }


  Future<void> _getMovieStatuses() async {
    _movieStatuses.clear();
    final movies = await _localMediaTrackingService.getAllMovies();
    _movieStatuses.addAll(movies);
  }

  Future<void> _getTvShowStatuses() async {
    _tvShowStatuses.clear();
    final tvShows = await _localMediaTrackingService.getAllTVShows();
    _tvShowStatuses.addAll(tvShows);
  }

  // --- Навигация ---
  void onMovieDetailsTab(BuildContext context, int index) {
    final id = _movieCreditList[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowDetailsTab(BuildContext context, int index) {
    final id = _tvShowCreditList[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  Future<void> _launchUrlHelper(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $urlString');
      // TODO: Show an error to user
    }
  }

  Future<void> launchImdbProfile(String imdbId) => _launchUrlHelper("https://www.imdb.com/name/$imdbId/");
  Future<void> launchInstagramProfile(String instagramId) => _launchUrlHelper("https://www.instagram.com/$instagramId/");
  Future<void> launchTwitterProfile(String twitterId) => _launchUrlHelper("https://twitter.com/$twitterId");
  Future<void> launchWikidataProfile(String wikidataId) => _launchUrlHelper("https://www.wikidata.org/wiki/$wikidataId");
  Future<void> launchTiktokProfile(String tiktokId) => _launchUrlHelper("https://www.tiktok.com/@$tiktokId");
  Future<void> launchYoutubeProfile(String youtubeId) => _launchUrlHelper("https://www.youtube.com/channel/$youtubeId");
  Future<void> launchFacebookProfile(String facebookId) => _launchUrlHelper("https://www.facebook.com/$facebookId");
  Future<void> launchPersonHomepage(String? homepage) {
    if (homepage == null || homepage.isEmpty) return Future.value();
    return _launchUrlHelper(homepage);
  }

  String formatDateInString(String? date) {
    return DateFormatHelper.yearOnly(date);
  }
}