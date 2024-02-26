import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/people_api_client.dart';
import 'package:the_movie_app/domain/entity/credits/credits_people/credits_people.dart';
import 'package:the_movie_app/domain/entity/person/details/person_details.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleDetailsModel extends ChangeNotifier{
  final _apiClient = PeopleApiClient();
  final int _personId;
  PersonDetails? _personDetails;
  final _dateFormat = DateFormat.yMMMMd();
  final List<CreditList> _creditList = [];

  List<CreditList> get movieCreditList {
    final movieCredits = _personDetails?.movieCredits;
    if(movieCredits == null) {
      return _creditList;
    }

    _creditList.addAll(movieCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _creditList.addAll(movieCredits.crew.map((crew) => CreditList.fromCrew(crew)));

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

    _creditList.sort((a, b) => (order[a.department] ?? 99) - (order[b.department] ?? 99));
    return _creditList;
  }
  List<CreditList> get tvShowCreditList {
    final movieCredits = _personDetails?.tvCredits;
    if(movieCredits == null) {
      return _creditList;
    }

    _creditList.addAll(movieCredits.cast.map((cast) => CreditList.fromCast(cast)));
    _creditList.addAll(movieCredits.crew.map((crew) => CreditList.fromCrew(crew)));

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

    _creditList.sort((a, b) => (order[a.department] ?? 99) - (order[b.department] ?? 99));

    return _creditList;
  }
  PersonDetails? get personDetails => _personDetails;

  PeopleDetailsModel(this._personId);

  Future<void> loadPersonDetails() async {
    _personDetails = await _apiClient.getPersonById(_personId);

    notifyListeners();
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
}