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
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Movies`
  String get movies {
    return Intl.message(
      'Movies',
      name: 'movies',
      desc: '',
      args: [],
    );
  }

  /// `TV Shows`
  String get tvShows {
    return Intl.message(
      'TV Shows',
      name: 'tvShows',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Find anything`
  String get findAnythingWelcome {
    return Intl.message(
      'Find anything',
      name: 'findAnythingWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Search Movies, TVs, Persons`
  String get searchGlobalSearchHint {
    return Intl.message(
      'Search Movies, TVs, Persons',
      name: 'searchGlobalSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Trending movies`
  String get trendingMovies {
    return Intl.message(
      'Trending movies',
      name: 'trendingMovies',
      desc: '',
      args: [],
    );
  }

  /// `Trending TVs`
  String get trendingTvs {
    return Intl.message(
      'Trending TVs',
      name: 'trendingTvs',
      desc: '',
      args: [],
    );
  }

  /// `Trending persons`
  String get trendingPersons {
    return Intl.message(
      'Trending persons',
      name: 'trendingPersons',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Persons`
  String get persons {
    return Intl.message(
      'Persons',
      name: 'persons',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collections {
    return Intl.message(
      'Collections',
      name: 'collections',
      desc: '',
      args: [],
    );
  }

  /// `No results.`
  String get noResults {
    return Intl.message(
      'No results.',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `Hello,`
  String get hello {
    return Intl.message(
      'Hello,',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Lists not available. Please login.`
  String get noLoginAccountMessage {
    return Intl.message(
      'Lists not available. Please login.',
      name: 'noLoginAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to leave?`
  String get confirmLeaveMessage {
    return Intl.message(
      'Do you really want to leave?',
      name: 'confirmLeaveMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `User lists`
  String get userLists {
    return Intl.message(
      'User lists',
      name: 'userLists',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Watchlist`
  String get watchlist {
    return Intl.message(
      'Watchlist',
      name: 'watchlist',
      desc: '',
      args: [],
    );
  }

  /// `Rated`
  String get rated {
    return Intl.message(
      'Rated',
      name: 'rated',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation`
  String get recommendation {
    return Intl.message(
      'Recommendation',
      name: 'recommendation',
      desc: '',
      args: [],
    );
  }

  /// `AI Recommendation`
  String get aiRecommendation {
    return Intl.message(
      'AI Recommendation',
      name: 'aiRecommendation',
      desc: '',
      args: [],
    );
  }

  /// `Discover the possibilities with Gemini AI`
  String get discoverGeminiAiMessage {
    return Intl.message(
      'Discover the possibilities with Gemini AI',
      name: 'discoverGeminiAiMessage',
      desc: '',
      args: [],
    );
  }

  /// `Generate list by genres`
  String get generateListByGenres {
    return Intl.message(
      'Generate list by genres',
      name: 'generateListByGenres',
      desc: '',
      args: [],
    );
  }

  /// `Generate list by description`
  String get generateListByDescription {
    return Intl.message(
      'Generate list by description',
      name: 'generateListByDescription',
      desc: '',
      args: [],
    );
  }

  /// `AI Recommendation List`
  String get aiRecommendationList {
    return Intl.message(
      'AI Recommendation List',
      name: 'aiRecommendationList',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message(
      'No data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Write a description that is as detailed as possible`
  String get writeADescriptionAiMessage {
    return Intl.message(
      'Write a description that is as detailed as possible',
      name: 'writeADescriptionAiMessage',
      desc: '',
      args: [],
    );
  }

  /// `Select max number of items`
  String get selectMaxNumberOfItems {
    return Intl.message(
      'Select max number of items',
      name: 'selectMaxNumberOfItems',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }

  /// `Select Movie or TV`
  String get selectMovieOrTv {
    return Intl.message(
      'Select Movie or TV',
      name: 'selectMovieOrTv',
      desc: '',
      args: [],
    );
  }

  /// `Select one or more genres`
  String get selectOneOrMoreGenres {
    return Intl.message(
      'Select one or more genres',
      name: 'selectOneOrMoreGenres',
      desc: '',
      args: [],
    );
  }

  /// `Cast`
  String get cast {
    return Intl.message(
      'Cast',
      name: 'cast',
      desc: '',
      args: [],
    );
  }

  /// `Crew`
  String get crew {
    return Intl.message(
      'Crew',
      name: 'crew',
      desc: '',
      args: [],
    );
  }

  /// `The list is empty.`
  String get theListIsEmpty {
    return Intl.message(
      'The list is empty.',
      name: 'theListIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Delete selected items?`
  String get deleteSelectedItems {
    return Intl.message(
      'Delete selected items?',
      name: 'deleteSelectedItems',
      desc: '',
      args: [],
    );
  }

  /// `Created by {username}.`
  String createdByUsername(Object username) {
    return Intl.message(
      'Created by $username.',
      name: 'createdByUsername',
      desc: '',
      args: [username],
    );
  }

  /// `Items: {itemCount}.`
  String itemsCount(Object itemCount) {
    return Intl.message(
      'Items: $itemCount.',
      name: 'itemsCount',
      desc: '',
      args: [itemCount],
    );
  }

  /// `New list`
  String get newList {
    return Intl.message(
      'New list',
      name: 'newList',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete the "{name}" list?`
  String deleteTheNameList(Object name) {
    return Intl.message(
      'Delete the "$name" list?',
      name: 'deleteTheNameList',
      desc: '',
      args: [name],
    );
  }

  /// `Item: {numberOfItems}`
  String itemNumberOfItems(Object numberOfItems) {
    return Intl.message(
      'Item: $numberOfItems',
      name: 'itemNumberOfItems',
      desc: '',
      args: [numberOfItems],
    );
  }

  /// `Update the "{name}" list`
  String updateTheNameList(Object name) {
    return Intl.message(
      'Update the "$name" list',
      name: 'updateTheNameList',
      desc: '',
      args: [name],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public {
    return Intl.message(
      'Public',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `List View with Selection`
  String get listViewWithSelection {
    return Intl.message(
      'List View with Selection',
      name: 'listViewWithSelection',
      desc: '',
      args: [],
    );
  }

  /// `Movie Crew`
  String get movieCrew {
    return Intl.message(
      'Movie Crew',
      name: 'movieCrew',
      desc: '',
      args: [],
    );
  }

  /// `Movie Cast`
  String get movieCast {
    return Intl.message(
      'Movie Cast',
      name: 'movieCast',
      desc: '',
      args: [],
    );
  }

  /// `Production Companies`
  String get productionCompanies {
    return Intl.message(
      'Production Companies',
      name: 'productionCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation Movies`
  String get recommendationMovies {
    return Intl.message(
      'Recommendation Movies',
      name: 'recommendationMovies',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min {
    return Intl.message(
      'min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `Image gallery`
  String get imageGallery {
    return Intl.message(
      'Image gallery',
      name: 'imageGallery',
      desc: '',
      args: [],
    );
  }

  /// `Other projects`
  String get otherProjects {
    return Intl.message(
      'Other projects',
      name: 'otherProjects',
      desc: '',
      args: [],
    );
  }

  /// `No other movie projects`
  String get noOtherMovieProjects {
    return Intl.message(
      'No other movie projects',
      name: 'noOtherMovieProjects',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `No other TV show projects`
  String get noOtherTvShowProjects {
    return Intl.message(
      'No other TV show projects',
      name: 'noOtherTvShowProjects',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1 {({count} episode)} other {({count} episodes)}}`
  String countEpisode(num count) {
    return Intl.plural(
      count,
      one: '($count episode)',
      other: '($count episodes)',
      name: 'countEpisode',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1 {Known For:} =2 {Known For:} other {Known For:}}`
  String knownFor(num count) {
    return Intl.plural(
      count,
      one: 'Known For:',
      two: 'Known For:',
      other: 'Known For:',
      name: 'knownFor',
      desc: '',
      args: [count],
    );
  }

  /// `Gender:`
  String get gender {
    return Intl.message(
      'Gender:',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1 {Female} =2 {Male} other {Not specified}}`
  String genderType(num count) {
    return Intl.plural(
      count,
      one: 'Female',
      two: 'Male',
      other: 'Not specified',
      name: 'genderType',
      desc: '',
      args: [count],
    );
  }

  /// `Date of Birth:`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth:',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Place Of Birth:`
  String get placeOfBirth {
    return Intl.message(
      'Place Of Birth:',
      name: 'placeOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Date of death:`
  String get dateOfDeath {
    return Intl.message(
      'Date of death:',
      name: 'dateOfDeath',
      desc: '',
      args: [],
    );
  }

  /// `Social Network`
  String get socialNetwork {
    return Intl.message(
      'Social Network',
      name: 'socialNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Biography`
  String get biography {
    return Intl.message(
      'Biography',
      name: 'biography',
      desc: '',
      args: [],
    );
  }

  /// `Episodes: {seriesCount} • {date}`
  String episodesSeriesCountDate(Object seriesCount, Object date) {
    return Intl.message(
      'Episodes: $seriesCount • $date',
      name: 'episodesSeriesCountDate',
      desc: '',
      args: [seriesCount, date],
    );
  }

  /// `Seasons`
  String get seasons {
    return Intl.message(
      'Seasons',
      name: 'seasons',
      desc: '',
      args: [],
    );
  }

  /// `Episode`
  String get episode {
    return Intl.message(
      'Episode',
      name: 'episode',
      desc: '',
      args: [],
    );
  }

  /// `Series Crew`
  String get seriesCrew {
    return Intl.message(
      'Series Crew',
      name: 'seriesCrew',
      desc: '',
      args: [],
    );
  }

  /// `Series Cast`
  String get seriesCast {
    return Intl.message(
      'Series Cast',
      name: 'seriesCast',
      desc: '',
      args: [],
    );
  }

  /// `Series Guest Stars`
  String get seriesGuestStars {
    return Intl.message(
      'Series Guest Stars',
      name: 'seriesGuestStars',
      desc: '',
      args: [],
    );
  }

  /// `TV Show Crew`
  String get tvShowCrew {
    return Intl.message(
      'TV Show Crew',
      name: 'tvShowCrew',
      desc: '',
      args: [],
    );
  }

  /// `TV Show Cast`
  String get tvShowCast {
    return Intl.message(
      'TV Show Cast',
      name: 'tvShowCast',
      desc: '',
      args: [],
    );
  }

  /// `Networks`
  String get networks {
    return Intl.message(
      'Networks',
      name: 'networks',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation TV Shows`
  String get recommendationTvShows {
    return Intl.message(
      'Recommendation TV Shows',
      name: 'recommendationTvShows',
      desc: '',
      args: [],
    );
  }

  /// `Add to the list`
  String get addToTheList {
    return Intl.message(
      'Add to the list',
      name: 'addToTheList',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message(
      'Rate',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Rate movie`
  String get rateMovie {
    return Intl.message(
      'Rate movie',
      name: 'rateMovie',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watch {
    return Intl.message(
      'Watch',
      name: 'watch',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `User Score`
  String get userScore {
    return Intl.message(
      'User Score',
      name: 'userScore',
      desc: '',
      args: [],
    );
  }

  /// `Trailers`
  String get trailers {
    return Intl.message(
      'Trailers',
      name: 'trailers',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Play Trailer`
  String get playTrailer {
    return Intl.message(
      'Play Trailer',
      name: 'playTrailer',
      desc: '',
      args: [],
    );
  }

  /// `No Trailer`
  String get noTrailer {
    return Intl.message(
      'No Trailer',
      name: 'noTrailer',
      desc: '',
      args: [],
    );
  }

  /// `Create a new list`
  String get createANewList {
    return Intl.message(
      'Create a new list',
      name: 'createANewList',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `You are not logged in.`
  String get youAreNotLoggedIn {
    return Intl.message(
      'You are not logged in.',
      name: 'youAreNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred. Please try again later.`
  String get anErrorHasOccurredTryAgainLater {
    return Intl.message(
      'An error has occurred. Please try again later.',
      name: 'anErrorHasOccurredTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error. Please try again later.`
  String get unknownErrorPleaseTryAgainLater {
    return Intl.message(
      'Unknown error. Please try again later.',
      name: 'unknownErrorPleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `The "{message}" list has been created.`
  String listCreatedMessage(Object message) {
    return Intl.message(
      'The "$message" list has been created.',
      name: 'listCreatedMessage',
      desc: '',
      args: [message],
    );
  }

  /// `This movie has been added to the "{message}" list`
  String movieAddedToListMessage(Object message) {
    return Intl.message(
      'This movie has been added to the "$message" list',
      name: 'movieAddedToListMessage',
      desc: '',
      args: [message],
    );
  }

  /// `This tv show has been added to the "{message}" list`
  String tvAddedToListMessage(Object message) {
    return Intl.message(
      'This tv show has been added to the "$message" list',
      name: 'tvAddedToListMessage',
      desc: '',
      args: [message],
    );
  }

  /// `The list has been removed`
  String get theListRemovedMessage {
    return Intl.message(
      'The list has been removed',
      name: 'theListRemovedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Release Dates`
  String get releaseDates {
    return Intl.message(
      'Release Dates',
      name: 'releaseDates',
      desc: '',
      args: [],
    );
  }

  /// `Please enter correct date`
  String get pleaseEnterCorrectDate {
    return Intl.message(
      'Please enter correct date',
      name: 'pleaseEnterCorrectDate',
      desc: '',
      args: [],
    );
  }

  /// `Clear all`
  String get clearAll {
    return Intl.message(
      'Clear all',
      name: 'clearAll',
      desc: '',
      args: [],
    );
  }

  /// `The rating was deleted successfully.`
  String get theRatingWasDeletedSuccessfully {
    return Intl.message(
      'The rating was deleted successfully.',
      name: 'theRatingWasDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `This movie already exists on the "{name}" list.`
  String movieExistsInListMessage(Object name) {
    return Intl.message(
      'This movie already exists on the "$name" list.',
      name: 'movieExistsInListMessage',
      desc: '',
      args: [name],
    );
  }

  /// `This TV show already exists on the "{name}" list.`
  String tvExistsInListMessage(Object name) {
    return Intl.message(
      'This TV show already exists on the "$name" list.',
      name: 'tvExistsInListMessage',
      desc: '',
      args: [name],
    );
  }

  /// `{status, select, status_0 {No status} status_1 {Watched} status_2 {Watching} status_3 {Going to Watch} status_4 {Stopped Watching} status_5 {Won't Watch}}`
  String mediaStatus(Object status) {
    return Intl.select(
      status,
      {
        'status_0': 'No status',
        'status_1': 'Watched',
        'status_2': 'Watching',
        'status_3': 'Going to Watch',
        'status_4': 'Stopped Watching',
        'status_5': 'Won\'t Watch',
      },
      name: 'mediaStatus',
      desc: '',
      args: [status],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uk'),
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
