import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/api_client/movie_api_client.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/state/item_state.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/helpers/event_helper.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
import 'package:the_movie_app/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsModel extends ChangeNotifier implements IBaseMediaDetailsModel {
  final _apiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  MediaDetails? _movieDetails;
  ItemState? _movieState;
  final _lists = <Lists>[];
  final int _movieId;
  final _dateFormat = DateFormat.yMMMd();
  bool _isFavorite = false;
  bool _isWatched = false;
  bool _isRated = false;
  // bool _isFBLinked = false;
  double _rate = 0;
  late int _currentPage;
  late int _totalPage;
  final _statuses = [1, 3, 5, 99];
  int? _currentStatus;
  final _localMediaTrackingService = LocalMediaTrackingService();

  @override
  MediaDetails? get mediaDetails => _movieDetails;

  ItemState? get movieState => _movieState;

  @override
  List<int> get statuses => _statuses;

  @override
  List<Lists> get lists => List.unmodifiable(_lists);

  @override
  bool get isFavorite => _isFavorite;

  @override
  bool get isWatched => _isWatched;

  @override
  bool get isRated => _isRated;

  @override
  double get rate => _rate;

  @override
  set rate(value) => _rate = value;

  // bool get isFBlinked => _isFBLinked;

  @override
  int? get currentStatus => _currentStatus;

  MovieDetailsModel(this._movieId);

  Future<void> loadMovieDetails() async {
    _movieDetails = await _apiClient.getMovieById(_movieId);
    _movieState = await _apiClient.getMovieState(_movieId);

    if(_movieState != null) {
      _isFavorite = _movieState?.favorite ?? false;
      _isWatched = _movieState?.watchlist ?? false;

      final rated = _movieState?.rated;
      if(rated != null) {
        _rate = rated.value ?? 0;
        _isRated = true;
      }
    }

    await _getMovieStatus();

    // await _getFBStatus();

    notifyListeners();
  }

  // Future<void> _getFBStatus() async {
  //   _isFBLinked = await AccountManager.getFBLinkStatus();
  // }

  Future<void> _getMovieStatus() async {
    final cachedMovie = await _localMediaTrackingService.getMovieById(
        _movieId);
    _currentStatus = cachedMovie?.status;
  }

  @override
  Future<void> toggleFavorite(BuildContext context) async {
    try {
      await _apiClient.addToFavorite(movieId: _movieId, isFavorite: !_isFavorite,);
      _isFavorite = !_isFavorite;
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: _isFavorite
            ? "The movie has been added to the favorite list."
            : "The movie has been removed from the favorite list."
      );
    } on ApiClientException catch (e) {
      if(e.type == ApiClientExceptionType.sessionExpired) {
        SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
        return;
      } else {
        SnackBarMessageHandler.showErrorSnackBar(context);
        return;
      }
    }
  }

  @override
  Future<void> toggleWatchlist(BuildContext context, int status) async {
    if(status != -1) {
      if(!_isWatched) {
        try {
          await _apiClient.addToWatchlist(movieId: _movieId, isWatched: true,);
        } on ApiClientException catch (e) {
          if(e.type == ApiClientExceptionType.sessionExpired) {
            SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
            return;
          } else {
            SnackBarMessageHandler.showErrorSnackBar(context);
            return;
          }
        }
      }

      final date =  DateTime.now();
      if(_currentStatus == null || _currentStatus == 0) {
        try {
          final movie = HiveMovies(
            movieId: _movieId,
            movieTitle: _movieDetails?.title,
            releaseDate: _movieDetails?.releaseDate,
            status: status,
            updatedAt: date,
            addedAt: date,
          );

          await _localMediaTrackingService.addMovieAndStatus(movie);
        } on Exception catch (e) {
          SnackBarMessageHandler.showErrorSnackBar(context);
          await _apiClient.addToWatchlist(movieId: _movieId, isWatched: false,);
          return;
        }
      } else {
        try {
          await _localMediaTrackingService.updateMovieStatus(
            movieId: _movieId,
            status: status,
            updatedAt: date.toString()
          );
          _currentStatus = status;
          SnackBarMessageHandler.showSuccessSnackBar(
            context: context,
            message: "The movie status has been updated.",
          );
          notifyListeners();
          return;
        } on Exception catch (e) {
          SnackBarMessageHandler.showErrorSnackBar(context);
          return;
        }
      }

      _isWatched = true;
      _currentStatus = status;
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: "The movie has been added to the watchlist.",
      );
      EventHelper.eventBus.fire(true);
    } else {
      try {
        await _apiClient.addToWatchlist(movieId: _movieId, isWatched: false,);
      } on ApiClientException catch (e) {
        if(e == ApiClientExceptionType.sessionExpired) {
          SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
          return;
        } else {
          SnackBarMessageHandler.showErrorSnackBar(context);
          return;
        }
      }
      try {
        await _localMediaTrackingService.deleteMovieStatus(_movieId);
      }
      catch (e) {
        SnackBarMessageHandler.showErrorSnackBar(context);
        await _apiClient.addToWatchlist(movieId: _movieId, isWatched: true,);
        return;
      }

      _isWatched = false;
      _currentStatus = null;
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: "The movie has been removed from the watchlist.",
      );
      EventHelper.eventBus.fire(true);
    }
  }

  @override
  Future<void> toggleAddRating(BuildContext context, double rate) async {
    try {
      await _apiClient.addRating(movieId: _movieId, rate: rate);
      if (_isRated == false) {
        _isRated = !_isRated;
      }
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "The movie rating has been added."
      );
    } on ApiClientException catch (e) {
      if(e.type == ApiClientExceptionType.sessionExpired) {
        SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
        return;
      } else {
        SnackBarMessageHandler.showErrorSnackBar(context);
        return;
      }
    }
  }

  @override
  Future<void> toggleDeleteRating(BuildContext context) async {
    if(_isRated) {
      try {
        await _apiClient.deleteRating(movieId: _movieId);
        _isRated = !_isRated;
        _rate = 0.0;
        notifyListeners();
        SnackBarMessageHandler.showSuccessSnackBar(
            context: context,
            message: context.l10n.theRatingWasDeletedSuccessfully,
        );
      } on ApiClientException catch (e) {
        if (e.type == ApiClientExceptionType.sessionExpired) {
          SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
          return;
        } else {
          SnackBarMessageHandler.showErrorSnackBar(context);
          return;
        }
      }
    }
  }

  @override
  Future<void> getAllUserLists(BuildContext context) async {
    if (lists.isEmpty) {
      _currentPage = 0;
      _totalPage = 1;

      // while (_currentPage < _totalPage) {
      // await getUserLists();
      // }

      await SnackBarHelper.handleErrorForUserLists(
        apiReq: () => _getUserLists(),
        context: context,
      );
    }
  }

  Future<void> _getUserLists() async {
    if (_currentPage >= _totalPage) return;

    final nextPage = _currentPage + 1;

    final userLists = await _accountApiClient.getUserLists(nextPage);
    _lists.addAll(userLists.results);
    _currentPage = userLists.page;
    _totalPage = userLists.totalPages;
    await _getUserLists();
  }

  @override
  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public}) async {
    await SnackBarHelper.handleErrorWithMessage(
      apiReq: () =>  _accountApiClient.addNewList(description: description, name: name, public: public),
      context: context,
      message: name,
      messageType: MessageType.listCreated,
    );

    _lists.clear();
    notifyListeners();
  }

  @override
  Future<void> addItemListToList({required BuildContext context, required int listId, required String name}) async {
    //todo find best solution
    final isSuccess = await _accountApiClient.isAddedToListToList(listId: listId, mediaType: MediaType.movie, mediaId: _movieId);

    if(isSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          context.l10n.movieExistsInListMessage(name),
          style: const TextStyle(fontSize: 20),),)
      );
    } else {
      await SnackBarHelper.handleErrorWithMessage(
        apiReq: () =>
            _accountApiClient.addItemListToList(
                listId: listId, mediaType: MediaType.movie, mediaId: _movieId),
        context: context,
        message: name,
        messageType: MessageType.movieAddedToList,
      );

      _lists.clear();
      notifyListeners();
    }
  }

  void onCastListScreen(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListScreen(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _movieDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onMediaDetailsScreen(BuildContext context, int index){
    final id = _movieDetails?.recommendations?.list[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void onCollectionScreen(BuildContext context) {
    final id = _movieDetails?.belongsToCollection?.id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.collection, arguments: id);
  }

  @override
  Future<void> launchYouTubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  String formatDate(String? date) =>
      date != "" ? _dateFormat.format(DateTime.parse(date ?? "")) : "";
}