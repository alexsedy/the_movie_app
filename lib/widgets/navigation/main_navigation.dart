import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/credits_list_screen/cast_list_screen/cast_list_model.dart';
import 'package:the_movie_app/widgets/credits_list_screen/cast_list_screen/cast_list_widget.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_model.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_widget.dart';
import 'package:the_movie_app/widgets/home_screen/home_search_screen/home_search_model.dart';
import 'package:the_movie_app/widgets/home_screen/home_search_screen/home_search_widget.dart';
import 'package:the_movie_app/widgets/list_screens/default_list/default_lists_model.dart';
import 'package:the_movie_app/widgets/list_screens/default_list/default_lists_widget.dart';
import 'package:the_movie_app/widgets/list_screens/user_list/list_details/details_user_list.dart';
import 'package:the_movie_app/widgets/list_screens/user_list/list_details/list_details_model.dart';
import 'package:the_movie_app/widgets/list_screens/user_list/user_lists_model.dart';
import 'package:the_movie_app/widgets/list_screens/user_list/user_lists_widget.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/collection_screen/media_collection_model.dart';
import 'package:the_movie_app/widgets/movie_screens/collection_screen/media_collection_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_widget.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/season_details/season_details_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/season_details/season_details_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/seasons/seasons_list_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/seasons/seasons_list_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/series/series_details_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/series/series_details_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_widget.dart';

abstract class MainNavigationRouteNames {
  static const mainScreen = "/";
  static const movieDetails = "/movie_details";
  static const tvShowDetails = "/tv_show_details";
  static const castList = "/cast_list";
  static const crewList = "/crew_list";
  static const personDetails = "/person_details";
  static const defaultList = "/default_list";
  static const userLists = "/user_lists";
  static const userListDetails = "/user_list_details";
  static const seasonsList = "/seasons_list";
  static const seasonDetails = "/season_details";
  static const seriesDetails = "/series_details";
  static const collection = "/collection";
  static const homeSearch = "/home_search";
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainScreen : (context) => const MainScreenWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => MovieDetailsModel(movieId),
            // model: MovieDetailsModel(movieId),
            child: const MovieDetailsWidget()),
        );

      case MainNavigationRouteNames.castList:
        final arguments = settings.arguments;
        final casts = arguments is List<Cast> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => CastListModel(casts ?? []),
              child: const CastListWidget()),
        );

      case MainNavigationRouteNames.crewList:
        final arguments = settings.arguments;
        final crew = arguments is List<Crew> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => CrewListModel(crew ?? []),
              child: const CrewListWidget()),
        );

      case MainNavigationRouteNames.seasonsList:
        final arguments = settings.arguments;
        final seasons = arguments is List<Seasons> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => SeasonsListModel(seasons ?? []),
              child: const SeasonsListWidget()),
        );

      case MainNavigationRouteNames.tvShowDetails:
        final arguments = settings.arguments;
        final seriesId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => TvShowDetailsModel(seriesId),
              // model: MovieDetailsModel(movieId),
              child: const TvShowDetailsWidget()),
        );

      case MainNavigationRouteNames.personDetails:
        final arguments = settings.arguments;
        final personId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => PeopleDetailsModel(personId),
              // model: MovieDetailsModel(movieId),
              child: const PeopleDetailsWidget()),
        );

      case MainNavigationRouteNames.seasonDetails:
        final arguments = settings.arguments as List;
        final tvShowId = arguments.first;
        final seasonNumber = arguments.last;

        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => SeasonDetailsModel(tvShowId, seasonNumber),
              child: const SeasonDetailsWidget()),
        );

      case MainNavigationRouteNames.seriesDetails:
        final arguments = settings.arguments as List;
        final tvShowId = arguments[0];
        final seasonNumber = arguments[1];
        final seriesNumber = arguments[2];

        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => SeriesDetailsModel(tvShowId, seasonNumber, seriesNumber),
              child: const SeriesDetailsWidget()),
        );


      case MainNavigationRouteNames.defaultList:
        final arguments = settings.arguments;
        final listType = arguments as ListType;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => DefaultListsModel(listType),
              // model: MovieDetailsModel(movieId),
              child: const DefaultListsWidget()),
        );

      case MainNavigationRouteNames.userLists:
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => UserListsModel(),
              // model: MovieDetailsModel(movieId),
              child: const UserListsWidget()),
        );

      case MainNavigationRouteNames.userListDetails:
        final arguments = settings.arguments;
        final listId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => ListDetailsModel(listId: listId),
              // model: MovieDetailsModel(movieId),
              child: const DetailsUserList()),
        );

      case MainNavigationRouteNames.collection:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => MediaCollectionModel(id),
              // model: MovieDetailsModel(movieId),
              child: const MediaCollectionWidget()),
        );

      case MainNavigationRouteNames.homeSearch:
        final arguments = settings.arguments;
        // final searchController = arguments is TextEditingController ? arguments : TextEditingController();
        final args = arguments is Map ? arguments : {};
        final searchController = args["searchController"];
        final index = args["index"];

        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => HomeSearchModel(searchController, index),
              // model: MovieDetailsModel(movieId),
              child: const HomeSearchWidget()),
        );

      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}