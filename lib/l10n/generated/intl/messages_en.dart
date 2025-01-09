// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '(${count} episode)', other: '(${count} episodes)')}";

  static String m1(username) => "Created by ${username}.";

  static String m2(name) => "Delete the \"${name}\" list?";

  static String m3(seriesCount, date) => "Episodes: ${seriesCount} • ${date}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'Female', two: 'Male', other: 'Not specified')}";

  static String m5(numberOfItems) => "Item: ${numberOfItems}";

  static String m6(itemCount) => "Items: ${itemCount}.";

  static String m7(count) =>
      "${Intl.plural(count, one: 'Known For:', two: 'Known For:', other: 'Known For:')}";

  static String m8(message) => "The \"${message}\" list has been created.";

  static String m9(status) => "${Intl.select(status, {
            'status_0': 'No status',
            'status_1': 'Watched',
            'status_2': 'Watching',
            'status_3': 'Going to Watch',
            'status_4': 'Stopped Watching',
            'status_5': 'Won\'t Watch',
          })}";

  static String m10(message) =>
      "This movie has been added to the \"${message}\" list";

  static String m11(name) =>
      "This movie already exists on the \"${name}\" list.";

  static String m12(message) =>
      "This tv show has been added to the \"${message}\" list";

  static String m13(name) =>
      "This TV show already exists on the \"${name}\" list.";

  static String m14(name) => "Update the \"${name}\" list";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addToTheList": MessageLookupByLibrary.simpleMessage("Add to the list"),
        "aiRecommendation":
            MessageLookupByLibrary.simpleMessage("AI Recommendation"),
        "aiRecommendationList":
            MessageLookupByLibrary.simpleMessage("AI Recommendation List"),
        "anErrorHasOccurredTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "An error has occurred. Please try again later."),
        "biography": MessageLookupByLibrary.simpleMessage("Biography"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cast": MessageLookupByLibrary.simpleMessage("Cast"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearAll": MessageLookupByLibrary.simpleMessage("Clear all"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "collections": MessageLookupByLibrary.simpleMessage("Collections"),
        "confirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
            "Do you really want to leave?"),
        "countEpisode": m0,
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createANewList":
            MessageLookupByLibrary.simpleMessage("Create a new list"),
        "createdByUsername": m1,
        "crew": MessageLookupByLibrary.simpleMessage("Crew"),
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("Date of Birth:"),
        "dateOfDeath": MessageLookupByLibrary.simpleMessage("Date of death:"),
        "day": MessageLookupByLibrary.simpleMessage("Day"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteSelectedItems":
            MessageLookupByLibrary.simpleMessage("Delete selected items?"),
        "deleteTheNameList": m2,
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "discoverGeminiAiMessage": MessageLookupByLibrary.simpleMessage(
            "Discover the possibilities with Gemini AI"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "episode": MessageLookupByLibrary.simpleMessage("Episode"),
        "episodesSeriesCountDate": m3,
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "findAnythingWelcome":
            MessageLookupByLibrary.simpleMessage("Find anything"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender:"),
        "genderType": m4,
        "generate": MessageLookupByLibrary.simpleMessage("Generate"),
        "generateListByDescription": MessageLookupByLibrary.simpleMessage(
            "Generate list by description"),
        "generateListByGenres":
            MessageLookupByLibrary.simpleMessage("Generate list by genres"),
        "guest": MessageLookupByLibrary.simpleMessage("Guest"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello,"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "imageGallery": MessageLookupByLibrary.simpleMessage("Image gallery"),
        "itemNumberOfItems": m5,
        "itemsCount": m6,
        "knownFor": m7,
        "list": MessageLookupByLibrary.simpleMessage("List"),
        "listCreatedMessage": m8,
        "listViewWithSelection":
            MessageLookupByLibrary.simpleMessage("List View with Selection"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "mediaStatus": m9,
        "min": MessageLookupByLibrary.simpleMessage("min"),
        "movieAddedToListMessage": m10,
        "movieCast": MessageLookupByLibrary.simpleMessage("Movie Cast"),
        "movieCrew": MessageLookupByLibrary.simpleMessage("Movie Crew"),
        "movieExistsInListMessage": m11,
        "movies": MessageLookupByLibrary.simpleMessage("Movies"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "networks": MessageLookupByLibrary.simpleMessage("Networks"),
        "newList": MessageLookupByLibrary.simpleMessage("New list"),
        "noData": MessageLookupByLibrary.simpleMessage("No data"),
        "noLoginAccountMessage": MessageLookupByLibrary.simpleMessage(
            "Lists not available. Please login."),
        "noOtherMovieProjects":
            MessageLookupByLibrary.simpleMessage("No other movie projects"),
        "noOtherTvShowProjects":
            MessageLookupByLibrary.simpleMessage("No other TV show projects"),
        "noResults": MessageLookupByLibrary.simpleMessage("No results."),
        "noTrailer": MessageLookupByLibrary.simpleMessage("No Trailer"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "otherProjects": MessageLookupByLibrary.simpleMessage("Other projects"),
        "overview": MessageLookupByLibrary.simpleMessage("Overview"),
        "persons": MessageLookupByLibrary.simpleMessage("Persons"),
        "placeOfBirth": MessageLookupByLibrary.simpleMessage("Place Of Birth:"),
        "playTrailer": MessageLookupByLibrary.simpleMessage("Play Trailer"),
        "pleaseEnterCorrectDate":
            MessageLookupByLibrary.simpleMessage("Please enter correct date"),
        "productionCompanies":
            MessageLookupByLibrary.simpleMessage("Production Companies"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "public": MessageLookupByLibrary.simpleMessage("Public"),
        "rate": MessageLookupByLibrary.simpleMessage("Rate"),
        "rateMovie": MessageLookupByLibrary.simpleMessage("Rate movie"),
        "rated": MessageLookupByLibrary.simpleMessage("Rated"),
        "recommendation":
            MessageLookupByLibrary.simpleMessage("Recommendation"),
        "recommendationMovies":
            MessageLookupByLibrary.simpleMessage("Recommendation Movies"),
        "recommendationTvShows":
            MessageLookupByLibrary.simpleMessage("Recommendation TV Shows"),
        "releaseDates": MessageLookupByLibrary.simpleMessage("Release Dates"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "searchGlobalSearchHint":
            MessageLookupByLibrary.simpleMessage("Search Movies, TVs, Persons"),
        "seasons": MessageLookupByLibrary.simpleMessage("Seasons"),
        "selectMaxNumberOfItems":
            MessageLookupByLibrary.simpleMessage("Select max number of items"),
        "selectMovieOrTv":
            MessageLookupByLibrary.simpleMessage("Select Movie or TV"),
        "selectOneOrMoreGenres":
            MessageLookupByLibrary.simpleMessage("Select one or more genres"),
        "seriesCast": MessageLookupByLibrary.simpleMessage("Series Cast"),
        "seriesCrew": MessageLookupByLibrary.simpleMessage("Series Crew"),
        "seriesGuestStars":
            MessageLookupByLibrary.simpleMessage("Series Guest Stars"),
        "socialNetwork": MessageLookupByLibrary.simpleMessage("Social Network"),
        "theListIsEmpty":
            MessageLookupByLibrary.simpleMessage("The list is empty."),
        "theListRemovedMessage":
            MessageLookupByLibrary.simpleMessage("The list has been removed"),
        "theRatingWasDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "The rating was deleted successfully."),
        "trailers": MessageLookupByLibrary.simpleMessage("Trailers"),
        "trendingMovies":
            MessageLookupByLibrary.simpleMessage("Trending movies"),
        "trendingPersons":
            MessageLookupByLibrary.simpleMessage("Trending persons"),
        "trendingTvs": MessageLookupByLibrary.simpleMessage("Trending TVs"),
        "tvAddedToListMessage": m12,
        "tvExistsInListMessage": m13,
        "tvShowCast": MessageLookupByLibrary.simpleMessage("TV Show Cast"),
        "tvShowCrew": MessageLookupByLibrary.simpleMessage("TV Show Crew"),
        "tvShows": MessageLookupByLibrary.simpleMessage("TV Shows"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownErrorPleaseTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "Unknown error. Please try again later."),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateTheNameList": m14,
        "userLists": MessageLookupByLibrary.simpleMessage("User lists"),
        "userScore": MessageLookupByLibrary.simpleMessage("User Score"),
        "watch": MessageLookupByLibrary.simpleMessage("Watch"),
        "watchlist": MessageLookupByLibrary.simpleMessage("Watchlist"),
        "week": MessageLookupByLibrary.simpleMessage("Week"),
        "writeADescriptionAiMessage": MessageLookupByLibrary.simpleMessage(
            "Write a description that is as detailed as possible"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("You are not logged in.")
      };
}
