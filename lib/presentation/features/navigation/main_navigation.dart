import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/di/dependencies.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_feature_start_sreen/ai_feature_start_screen_view.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_feature_start_sreen/viewmodel/ai_feature_start_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_list_recommendation/ai_recommendation_list_screen_view.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_list_recommendation/viewmodel/ai_recommendation_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_description/ai_recommendation_by_description_screen_widget.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_description/viewmodel/ai_recommendation_by_description_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_genre/ai_recommendation_by_genre_screen_widget.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_genre/viewmodel/ai_recommendation_by_genre_viewmodel.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/cast_list_screen/cast_list_view.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/cast_list_screen/viewmodel/cast_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/crew_list_screen/crew_list_view.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/crew_list_screen/viewmodel/crew_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/home_screen/home_search_view.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_search_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/default_lists_view.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_details/details_user_list_view.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_details/viewmodel/details_user_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/user_lists_view.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/viewmodel/user_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/features/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/presentation/features/movie_screens/collection_screen/media_collection_view.dart';
import 'package:the_movie_app/presentation/features/movie_screens/collection_screen/viewmodel/media_collection_viewmodel.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_details_screen/movie_details_view.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_details_screen/viewmodel/movie_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/person_screen/people_details_screen/people_details_view.dart';
import 'package:the_movie_app/presentation/features/person_screen/viewmodel/people_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/season_details/season_details_view.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/season_details/viewmodel/season_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/seasons/seasons_list_widget.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/seasons/viewmodel/seasons_list_view_model.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/series/series_details_view.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/series/viewmodel/series_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/tv_show_details_view.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/viewmodel/tv_show_details_viewmodel.dart';

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
  static const aiFeatureStart = "/ai_feature_start";
  static const aiRecommendationByGenre = "/ai_recommendation_by_genre";
  static const aiRecommendationList = "/ai_recommendation_list";
  static const aiRecommendationByDescription = "/ai_recommendation_by_description";
  static const authApprove = "/auth_approve";
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainScreen : (context) => const MainScreenWidget(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => getIt<MovieDetailsViewModel>(param1: movieId),
            child: const MovieDetailsView(),
          ),
        );

      case MainNavigationRouteNames.castList:
        final arguments = settings.arguments;
        final cast = arguments is List<Cast> ? arguments : <Cast>[];

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<CastListViewModel>(param1: cast),
              child: const CastListView()),
        );

      case MainNavigationRouteNames.crewList:
        final arguments = settings.arguments;
        final crew = arguments is List<Crew> ? arguments : <Crew>[];

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<CrewListViewModel>(param1: crew),
              child: const CrewListView()),
        );

      case MainNavigationRouteNames.seasonsList:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<SeasonsListViewModel>(param1: settings.arguments,),
              child: const SeasonsListWidget()),
        );

      case MainNavigationRouteNames.tvShowDetails:
        final arguments = settings.arguments;
        final seriesId = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<TvShowDetailsViewModel>(param1: seriesId),
              child: const TvShowDetailsView()),
        );

      case MainNavigationRouteNames.personDetails:
        final arguments = settings.arguments;
        final personId = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<PeopleDetailsViewModel>(param1: personId),
              child: const PeopleDetailsView()),
        );

      case MainNavigationRouteNames.seasonDetails:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<SeasonDetailsViewModel>(param1: settings.arguments,),
              child: const SeasonDetailsView()),
        );

      case MainNavigationRouteNames.seriesDetails:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<SeriesDetailsViewModel>(param1: settings.arguments,),
              child: const SeriesDetailsView()),
        );

      case MainNavigationRouteNames.defaultList:
        final arguments = settings.arguments;
        final listType = arguments as ListType;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<DefaultListsViewModel>(param1: listType),
              child: const DefaultListsView()),
        );

      case MainNavigationRouteNames.userLists:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<UserListsViewModel>(),
              child: const UserListsView()),
        );

      case MainNavigationRouteNames.userListDetails:
        final arguments = settings.arguments;
        final listId = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<DetailsUserListViewModel>(param1: listId),
              child: const DetailsUserListView()),
        );

      case MainNavigationRouteNames.collection:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) =>  getIt<MediaCollectionViewModel>(param1: id),
              child: const MediaCollectionView()),
        );

      case MainNavigationRouteNames.homeSearch:
        final arguments = settings.arguments;
        final index = arguments is int ? arguments : 0;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => getIt<HomeSearchViewModel>(param1: index),
            child: const HomeSearchView(),
          ),
        );

      case MainNavigationRouteNames.aiFeatureStart:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<AiFeatureStartViewModel>(),
              child: const AiFeatureStartView(),),
        );

      case MainNavigationRouteNames.aiRecommendationByGenre:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<AiRecommendationByGenreViewModel>(),
              child: const AiRecommendationByGenreView()),
        );

      case MainNavigationRouteNames.aiRecommendationByDescription:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<AiRecommendationByDescriptionViewModel>(),
              child: const AiRecommendationByDescriptionView()),
        );

      case MainNavigationRouteNames.aiRecommendationList:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => getIt<AiRecommendationListViewModel>(param1: settings.arguments),
              child: const AiRecommendationListView()),
        );

      case MainNavigationRouteNames.authApprove:
        return null;

      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}