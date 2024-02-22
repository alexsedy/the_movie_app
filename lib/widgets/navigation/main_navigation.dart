import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/auth_screen/auth_model.dart';
import 'package:the_movie_app/widgets/auth_screen/auth_widget.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_cast_screen/movie_cast_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_cast_screen/movie_cast_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_crew_screen/movie_crew_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_crew_screen/movie_crew_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = "auth";
  static const mainScreen = "/";
  static const movieDetails = "/movie_details";
  static const movieCast = "/movie_details/movie_cast";
  static const movieCrew = "/movie_details/movie_crew";
  static const tvShowDetails = "/tv_show_details";
}

class MainNavigation {
  String initialRouts(bool isAuth) => isAuth ? MainNavigationRouteNames.mainScreen : MainNavigationRouteNames.auth;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth : (context) => NotifierProvider(
      create: () => AuthModel(),
      // model: AuthModel(),
      child: const AuthWidget(),
    ), //AuthWidget(),
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

      case MainNavigationRouteNames.movieCast:
        final arguments = settings.arguments;
        final casts = arguments is List<Cast> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => MovieCastModel(casts),
              child: const MovieCastWidget()),
        );

      case MainNavigationRouteNames.movieCrew:
        final arguments = settings.arguments;
        final crew = arguments is List<Crew> ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => MovieCrewModel(crew),
              child: const MovieCrewWidget()),
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

      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}