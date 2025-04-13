// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:the_movie_app/core/helpers/event_helper.dart';
// import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
// import 'package:the_movie_app/data/datasources/remote/api_client/account_api_client.dart';
// import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
// import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
// import 'package:the_movie_app/data/models/media/list/list.dart';
// import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
//
// class DefaultListsModel extends ChangeNotifier {
//   final ListType listType;
//   final ScrollController _scrollController = ScrollController();
//   final _accountApiClient = AccountApiClient();
//   int _movieCurrentPage = 0;
//   int _movieTotalPage = 1;
//   int _tvCurrentPage = 0;
//   int _tvTotalPage = 1;
//   final _movies = <MediaList>[];
//   final _tvs = <MediaList>[];
//   var _isMovieLoadingInProgress = false;
//   var _isTvShowLoadingInProgress = false;
//   final _localMediaTrackingService = LocalMediaTrackingService();
//   final _movieStatuses = <HiveMovies>[];
//   final _tvShowStatuses = <HiveTvShow>[];
//   StreamSubscription? _subscription;
//   bool _isDisposed = false;
//
//   DefaultListsModel(this.listType) {
//     if(!_isDisposed) {
//       if (listType == ListType.watchlist) {
//         _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
//           if (event) {
//             await fetchAllMediaData();
//           }
//         });
//       }
//     }
//   }
//
//   ScrollController get scrollController => _scrollController;
//   List<MediaList> get tvs => List.unmodifiable(_tvs);
//   List<MediaList> get movies => List.unmodifiable(_movies);
//   List<HiveMovies> get movieStatuses => List.unmodifiable(_movieStatuses);
//   List<HiveTvShow> get tvShowStatuses => List.unmodifiable(_tvShowStatuses);
//
//   Future<void> loadMovies() async {
//     if (_isMovieLoadingInProgress || _movieCurrentPage >= _movieTotalPage) return;
//     _isMovieLoadingInProgress = true;
//     final nextPage = _movieCurrentPage + 1;
//
//     try {
//       final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);
//
//       _movies.addAll(moviesResponse.list);
//       _movieCurrentPage = moviesResponse.page;
//       _movieTotalPage = moviesResponse.totalPages;
//       _isMovieLoadingInProgress = false;
//
//       notifyListeners();
//     } catch (e) {
//       _isMovieLoadingInProgress = false;
//     }
//   }
//
//   Future<void> loadTvShows() async {
//     if (_isTvShowLoadingInProgress || _tvCurrentPage >= _tvTotalPage) return;
//     _isTvShowLoadingInProgress = true;
//     final nextPage = _tvCurrentPage + 1;
//
//     try {
//       final tvShowResponse = await _accountApiClient.getDefaultTvShowLists(page: nextPage, listType: listType);
//
//       _tvs.addAll(tvShowResponse.list);
//       _tvCurrentPage = tvShowResponse.page;
//       _tvTotalPage = tvShowResponse.totalPages;
//       _isTvShowLoadingInProgress = false;
//
//       notifyListeners();
//     } catch (e) {
//       _isTvShowLoadingInProgress = false;
//     }
//   }
//
//   Future<void> fetchAllMediaData() async {
//     await _loadAllMovies();
//     await _loadAllTvShows();
//     notifyListeners();
//   }
//
//   Future<void> _loadAllMovies() async {
//     await _getMovieStatuses();
//
//     _movieCurrentPage = 0;
//     _movieTotalPage = 1;
//     _movies.clear();
//     try {
//       while (_movieCurrentPage < _movieTotalPage) {
//         final nextPage = _movieCurrentPage + 1;
//         final moviesResponse = await _accountApiClient.getDefaultMovieLists(page: nextPage, listType: listType);
//
//         _movies.addAll(moviesResponse.list);
//         _movieCurrentPage = moviesResponse.page;
//         _movieTotalPage = moviesResponse.totalPages;
//       }
//     } catch (e) {
//       print('Error loading movies: $e');
//     }
//   }
//
//   Future<void> _loadAllTvShows() async {
//     await _getTvShowStatuses();
//
//     _tvCurrentPage = 0;
//     _tvTotalPage = 1;
//     _tvs.clear();
//     try {
//       while (_tvCurrentPage < _tvTotalPage) {
//         final nextPage = _tvCurrentPage + 1;
//         final tvsResponse = await _accountApiClient
//             .getDefaultTvShowLists(page: nextPage, listType: listType);
//
//         _tvs.addAll(tvsResponse.list);
//         _tvCurrentPage = tvsResponse.page;
//         _tvTotalPage = tvsResponse.totalPages;
//       }
//     } catch (e) {
//       print('Error loading movies: $e');
//     }
//   }
//
//   Future<void> _getMovieStatuses() async {
//     _movieStatuses.clear();
//     final movies = await _localMediaTrackingService.getAllMovies();
//     _movieStatuses.addAll(movies);
//   }
//
//   Future<void> _getTvShowStatuses() async {
//     _tvShowStatuses.clear();
//     final tvShows = await _localMediaTrackingService.getAllTVShows();
//     _tvShowStatuses.addAll(tvShows);
//   }
//
//   void onTvShowScreen(BuildContext context, int index) {
//     final id = _tvs[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
//   }
//
//   void onMovieScreen(BuildContext context, int index) {
//     final id = _movies[index].id;
//     Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
//   }
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//     _subscription?.cancel();
//     super.dispose();
//   }
// }
//
// enum ListType {
//   favorites, watchlist, rated, recommendations
// }
