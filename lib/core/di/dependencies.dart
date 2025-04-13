import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/data/datasources/firebase/firebase_auth_service.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/account_api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/auth_api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/movie_api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/people_api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/search_api_client.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/repositories/account_repository_impl.dart';
import 'package:the_movie_app/data/repositories/auth_repository_impl.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/data/repositories/i_auth_repository.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/data/repositories/i_people_repository.dart';
import 'package:the_movie_app/data/repositories/i_search_repository.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:the_movie_app/data/repositories/people_repository_impl.dart';
import 'package:the_movie_app/data/repositories/search_repository_impl.dart';
import 'package:the_movie_app/data/repositories/tv_show_repository_impl.dart';
import 'package:the_movie_app/presentation/features/account_screen/viewmodel/account_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_feature_start_sreen/viewmodel/ai_feature_start_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_list_recommendation/viewmodel/ai_recommendation_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_description/viewmodel/ai_recommendation_by_description_viewmodel.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_genre/viewmodel/ai_recommendation_by_genre_viewmodel.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/cast_list_screen/viewmodel/cast_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/crew_list_screen/viewmodel/crew_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_search_viewmodel.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_details/viewmodel/details_user_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/viewmodel/user_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/features/movie_screens/collection_screen/viewmodel/media_collection_viewmodel.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_details_screen/viewmodel/movie_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_list_screen/viewmodel/movie_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/person_screen/viewmodel/people_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/season_details/viewmodel/season_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/seasons/viewmodel/seasons_list_view_model.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/series/viewmodel/series_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/viewmodel/tv_show_details_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_list_screen/viewmodel/tv_show_list_viewmodel.dart';

final getIt = GetIt.instance;
const _apiKey = String.fromEnvironment('GEMINI_API_KEY');

void setupDependencies() {
  ///Api clients
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<AccountApiClient>(() => AccountApiClient());
  getIt.registerLazySingleton<AuthApiClient>(() => AuthApiClient());
  getIt.registerLazySingleton<MovieApiClient>(() => MovieApiClient());
  getIt.registerLazySingleton<PeopleApiClient>(() => PeopleApiClient());
  getIt.registerLazySingleton<SearchApiClient>(() => SearchApiClient());
  getIt.registerLazySingleton<TvShowApiClient>(() => TvShowApiClient());
  getIt.registerLazySingleton<LocalMediaTrackingService>(
      () => LocalMediaTrackingService());
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  ///Singletons
  getIt.registerLazySingleton<IMovieRepository>(
    () => MovieRepositoryImpl(getIt<MovieApiClient>()),
  );
  getIt.registerLazySingleton<ITvShowRepository>(
    () => TvShowRepositoryImpl(getIt<TvShowApiClient>()),
  );
  getIt.registerLazySingleton<IAccountRepository>(
    () => AccountRepositoryImpl(getIt<AccountApiClient>()),
  );
  getIt.registerLazySingleton<IPeopleRepository>(
    () => PeopleRepositoryImpl(getIt<PeopleApiClient>()),
  );
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApiClient>()),
  );
  getIt.registerLazySingleton<GenerativeModel>(() => GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  ));
  getIt.registerLazySingleton<AccountViewModel>(
    () => AccountViewModel(
      getIt<IAuthRepository>(),
      getIt<IAccountRepository>(),
      getIt<FirebaseAuthService>(),
    ),
  );
  getIt.registerLazySingleton<HomeViewModel>(
    () => HomeViewModel(
      getIt<IMovieRepository>(),
      getIt<ITvShowRepository>(),
      getIt<IPeopleRepository>(),
    ),
  );
  getIt.registerLazySingleton<ISearchRepository>(
    () => SearchRepositoryImpl(getIt<SearchApiClient>()),
  );

  ///Factory
  getIt.registerFactory<MovieListViewModel>(
    () => MovieListViewModel(
      getIt<IMovieRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactory<TvShowListViewModel>(
    () => TvShowListViewModel(
      getIt<ITvShowRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<MovieDetailsViewModel, int, void>(
    (movieId, _) => MovieDetailsViewModel(
      movieId,
      getIt<IMovieRepository>(),
      getIt<IAccountRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<TvShowDetailsViewModel, int, void>(
    (tvShow, _) => TvShowDetailsViewModel(
      tvShow,
      getIt<ITvShowRepository>(),
      getIt<IAccountRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<PeopleDetailsViewModel, int, void>(
    (personId, _) => PeopleDetailsViewModel(
      personId,
      getIt<IPeopleRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<HomeSearchViewModel, int, void>(
    (initialIndex, _) => HomeSearchViewModel(
      initialIndex,
      getIt<ISearchRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<DefaultListsViewModel, ListType, void>(
    (listType, _) => DefaultListsViewModel(
      listType,
      getIt<IAccountRepository>(),
      getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactory<UserListsViewModel>(
    () => UserListsViewModel(getIt<IAccountRepository>()),
  );
  getIt.registerFactoryParam<DetailsUserListViewModel, int, void>(
        (listId, _) => DetailsUserListViewModel(
      listId,
      getIt<IAccountRepository>(),
    ),
  );
  getIt.registerFactoryParam<SeasonsListViewModel, Map<String, dynamic>, void>(
        (params, _) => SeasonsListViewModel(
      seasons: params[NavParamConst.seasons] as List<Seasons>,
      tvShowId: params[NavParamConst.tvShowId] as int,
      localMediaTrackingService: getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<SeasonDetailsViewModel, Map<String, dynamic>, void>(
        (params, _) => SeasonDetailsViewModel(
      tvShowId: params[NavParamConst.tvShowId],
      seasonNumber: params[NavParamConst.seasonNumber],
      tvShowRepository: getIt<ITvShowRepository>(),
      localMediaTrackingService: getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<SeriesDetailsViewModel, Map<String, dynamic>, void>(
        (params, _) => SeriesDetailsViewModel(
      seriesId: params[NavParamConst.tvShowId],
      seasonNumber: params[NavParamConst.seasonNumber],
      episodeNumber: params[NavParamConst.episodeNumber],
      tvShowRepository: getIt<ITvShowRepository>(),
      localMediaTrackingService: getIt<LocalMediaTrackingService>(),
    ),
  );
  getIt.registerFactoryParam<MediaCollectionViewModel, int, void>(
        (collectionId, _) => MediaCollectionViewModel(
      collectionId,
      getIt<IMovieRepository>(),
    ),
  );
  getIt.registerFactoryParam<CastListViewModel, List<Cast>, void>(
        (castList, _) => CastListViewModel(castList),
  );
  getIt.registerFactoryParam<CrewListViewModel, List<Crew>, void>(
        (crewList, _) => CrewListViewModel(crewList),
  );
  getIt.registerFactory<AiFeatureStartViewModel>(() => AiFeatureStartViewModel());
  getIt.registerFactory<AiRecommendationByGenreViewModel>(() => AiRecommendationByGenreViewModel());
  getIt.registerFactory<AiRecommendationByDescriptionViewModel>(() => AiRecommendationByDescriptionViewModel());
  getIt.registerFactoryParam<AiRecommendationListViewModel, Map<String, dynamic>, void>(
        (params, _) => AiRecommendationListViewModel(
      prompt: params[NavParamConst.prompt] as String,
      isMovie: params[NavParamConst.isMovie] as bool,
      isGenre: params[NavParamConst.isGenre] as bool,
      searchRepository: getIt<ISearchRepository>(),
      generativeModel: getIt<GenerativeModel>(),
    ),
  );
}
