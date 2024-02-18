import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/auth_screen/auth_model.dart';
import 'package:the_movie_app/widgets/auth_screen/auth_widget.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = "auth";
  static const mainScreen = "/";
  static const movieDetails = "/movie_details";
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
      case MainNavigationRouteNames.tvShowDetails:
        final arguments = settings.arguments;
        final seriesId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => MovieDetailsModel(seriesId),
              // model: MovieDetailsModel(movieId),
              child: const MovieDetailsWidget()),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}