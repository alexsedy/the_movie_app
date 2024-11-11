// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get homeText {
    return Intl.message(
      'Home',
      name: 'homeText',
      desc: '',
      args: [],
    );
  }

  /// `Movie`
  String get movieText {
    return Intl.message(
      'Movie',
      name: 'movieText',
      desc: '',
      args: [],
    );
  }

  /// `TV Shows`
  String get tvShowsText {
    return Intl.message(
      'TV Shows',
      name: 'tvShowsText',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileText {
    return Intl.message(
      'Profile',
      name: 'profileText',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchTextHint {
    return Intl.message(
      'Search',
      name: 'searchTextHint',
      desc: '',
      args: [],
    );
  }

  /// `Find anything`
  String get findAnythingWelcomeText {
    return Intl.message(
      'Find anything',
      name: 'findAnythingWelcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Search movie, TV, person`
  String get searchGlobalSearchHint {
    return Intl.message(
      'Search movie, TV, person',
      name: 'searchGlobalSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Trending movies`
  String get trendingMoviesText {
    return Intl.message(
      'Trending movies',
      name: 'trendingMoviesText',
      desc: '',
      args: [],
    );
  }

  /// `Trending TVs`
  String get trendingTvText {
    return Intl.message(
      'Trending TVs',
      name: 'trendingTvText',
      desc: '',
      args: [],
    );
  }

  /// `Trending persons`
  String get trendingPersonsText {
    return Intl.message(
      'Trending persons',
      name: 'trendingPersonsText',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get dayToggleText {
    return Intl.message(
      'Day',
      name: 'dayToggleText',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get weekToggleText {
    return Intl.message(
      'Week',
      name: 'weekToggleText',
      desc: '',
      args: [],
    );
  }

  /// `Movies`
  String get moviesSearchTabText {
    return Intl.message(
      'Movies',
      name: 'moviesSearchTabText',
      desc: '',
      args: [],
    );
  }

  /// `TV Shows`
  String get tvShowsSearchTabText {
    return Intl.message(
      'TV Shows',
      name: 'tvShowsSearchTabText',
      desc: '',
      args: [],
    );
  }

  /// `Persons`
  String get personsSearchTabText {
    return Intl.message(
      'Persons',
      name: 'personsSearchTabText',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collectionsSearchTabText {
    return Intl.message(
      'Collections',
      name: 'collectionsSearchTabText',
      desc: '',
      args: [],
    );
  }

  /// `No results.`
  String get noResultsEmptyListText {
    return Intl.message(
      'No results.',
      name: 'noResultsEmptyListText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'ua'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
