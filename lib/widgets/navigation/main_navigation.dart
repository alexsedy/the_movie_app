import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/credits_list_screen/cast_list_screen/cast_list_model.dart';
import 'package:the_movie_app/widgets/credits_list_screen/cast_list_screen/cast_list_widget.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_model.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_widget.dart';
import 'package:the_movie_app/widgets/list_screens/default_lists_model.dart';
import 'package:the_movie_app/widgets/list_screens/default_lists_widget.dart';
import 'package:the_movie_app/widgets/list_screens/details_user_list.dart';
import 'package:the_movie_app/widgets/list_screens/user_lists_model.dart';
import 'package:the_movie_app/widgets/list_screens/user_lists_widget.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_widget.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_widget.dart';
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
              create: () => CastListModel(casts),
              child: const CastListWidget()),
        );

      case MainNavigationRouteNames.crewList:
        final arguments = settings.arguments;
        final crew = arguments is List<Crew> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => CrewListModel(crew),
              child: const CrewListWidget()),
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
              create: () => UserListsModel(listId: listId),
              // model: MovieDetailsModel(movieId),
              child: const DetailsUserList()),
        );

      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}