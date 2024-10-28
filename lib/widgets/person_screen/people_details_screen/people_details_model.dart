import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/people_api_client.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/domain/entity/person/details/person_details.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleDetailsModel extends ChangeNotifier{
  final _apiClient = PeopleApiClient();
  final int _personId;
  PersonDetails? _personDetails;
  final _dateFormat = DateFormat.yMMMMd();
  final List<CreditList> _movieCreditList = [];
  final List<CreditList> _tvShowCreditList = [];
  final order = {
    'Actor': 0,
    'Directing': 1,
    'Writing': 2,
    'Production': 3,
    'Sound': 4,
    'Camera': 5,
    'Editing': 6,
    'Visual Effects': 7,
    'Art': 8,
    'Costume & Make-Up': 9,
    'Crew': 10,
    'Lighting': 11,
  };

  List<CreditList> get movieCreditList => _movieCreditList;
  List<CreditList> get tvShowCreditList => _tvShowCreditList;
  PersonDetails? get personDetails => _personDetails;

  PeopleDetailsModel(this._personId);

  Future<void> loadPersonDetails() async {
    _personDetails = await _apiClient.getPersonById(_personId);
    notifyListeners();

    await _addAndSortMovieCredits();
    await _addAndSortTvShowCredits();
  }

  Future<void> _addAndSortMovieCredits() async {
    final movieCredits = _personDetails?.movieCredits;
    if(movieCredits == null) {
      return;
    }
    _movieCreditList.addAll(movieCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _movieCreditList.addAll(movieCredits.crew.map((crew) => CreditList.fromCrew(crew)));

    // _movieCreditList.sort((a, b) => (b.releaseDate ?? '') .compareTo(a.releaseDate ?? ''));

    _movieCreditList.sort((a, b) {
      int departmentComparison = a.department.compareTo(b.department);
      if (departmentComparison == 0) {
        return b.releaseDate?.compareTo(a.releaseDate ?? "") ?? 1;
      }
      return departmentComparison;
    });
  }

  Future<void> _addAndSortTvShowCredits() async {
    final tvCredits = _personDetails?.tvCredits;
    if(tvCredits == null) {
      return;
    }
    _tvShowCreditList.addAll(tvCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _tvShowCreditList.addAll(tvCredits.crew.map((crew) => CreditList.fromCrew(crew)));

    _tvShowCreditList.sort((a, b) {
      int departmentComparison = a.department.compareTo(b.department);
      if (departmentComparison == 0) {
        return b.firstAirDate?.compareTo(a.firstAirDate ?? "") ?? 1;
      }
      return departmentComparison;
    });
  }

  void onMovieDetailsTab(BuildContext context, int index) {
    final id = _movieCreditList[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowDetailsTab(BuildContext context, int index) {
    final id = _tvShowCreditList[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  Future<void> launchImdbProfile(String imdbId) async {
    final Uri url = Uri.parse("https://www.imdb.com/name/$imdbId/");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchInstagramProfile(String instagramId) async {
    final Uri url = Uri.parse("https://www.instagram.com/$instagramId/");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchTwitterProfile(String twitterId) async {
    final Uri url = Uri.parse("https://twitter.com/$twitterId");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchWikidataProfile(String wikidataId) async {
    final Uri url = Uri.parse("https://www.wikidata.org/wiki/$wikidataId");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchTiktokProfile(String tiktokId) async {
    final Uri url = Uri.parse("https://www.tiktok.com/@$tiktokId");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchYoutubeProfile(String youtubeId) async {
    final Uri url = Uri.parse("https://www.youtube.com/$youtubeId");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchFacebookProfile(String facebookId) async {
    final Uri url = Uri.parse("https://www.facebook.com/$facebookId");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchPersonHomepage(String homepage) async {
    final Uri url = Uri.parse(homepage);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String formatDate(String? date) =>
      date != null ? _dateFormat.format(DateTime.parse(date)) : "";

  String formatDateInString(String? releaseDate) {
    if(releaseDate == null || releaseDate.isEmpty) {
      return "";
    }

    return releaseDate.substring(0, 4);
  }
}