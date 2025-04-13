import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/models/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/data/models/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/data/models/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/season/season.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/data/repositories/i_tv_show_repository.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:url_launcher/url_launcher.dart';

class TvShowDetailsViewModel extends ChangeNotifier implements IBaseMediaDetailsModel {
  final int _seriesId;
  final ITvShowRepository _tvShowRepository;
  final IAccountRepository _accountRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  MediaDetails? _mediaDetails;
  final List<Lists> _lists = <Lists>[];
  final List<Season> _seasonsList = <Season>[];
  bool _isFavorite = false;
  bool _isWatched = false;
  bool _isRated = false;
  double _rate = 0;
  int? _currentStatus;
  final Map<int, int> _seasonWatchStatuses = {};
  bool _isLoading = true;
  bool _isListsLoading = false;
  StreamSubscription? _subscription;

  int _userListCurrentPage = 0;
  int _userListTotalPage = 1;

  bool _isFavoriteLoading = false;
  bool _isWatchlistLoading = false;
  bool _isRatingLoading = false;
  bool _isAddToLisLoading = false;

  @override
  MediaDetails? get mediaDetails => _mediaDetails;
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
  int? get currentStatus => _currentStatus;
  @override
  final List<int> statuses = const [1, 2, 3, 4, 5, 99];

  Map<int, int> get seasonWatchStatuses => Map.unmodifiable(_seasonWatchStatuses);
  bool get isLoading => _isLoading;
  bool get isListsLoading => _isListsLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  bool get isWatchlistLoading => _isWatchlistLoading;
  bool get isRatingLoading => _isRatingLoading;
  bool get isAddToLisLoading => _isAddToLisLoading;

  @override
  set rate(value) => _rate = value;

  TvShowDetailsViewModel(
      this._seriesId,
      this._tvShowRepository,
      this._accountRepository,
      this._localMediaTrackingService,
      ) {
    _initialize();
  }

  void _initialize() {
    _loadTvShowDetails();
    _subscribeToEvents();
  }

  Future<void> _loadTvShowDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _tvShowRepository.getTvShowById(_seriesId),
        _tvShowRepository.getTvShowState(_seriesId), // Может вернуть null, если не залогинен
        _localMediaTrackingService.getTVShowById(_seriesId),
      ]);

      _mediaDetails = results[0] as MediaDetails;
      final tvShowState = results[1] as ItemState?;
      final cachedTvShow = results[2] as HiveTvShow?;

      if (tvShowState != null) {
        _isFavorite = tvShowState.favorite;
        _isWatched = tvShowState.watchlist;
        final ratedState = tvShowState.rated;
        if (ratedState != null) {
          _rate = ratedState.value ?? 0;
          _isRated = true;
        } else {
          _isRated = false;
          _rate = 0;
        }
      }

      _updateLocalStatuses(cachedTvShow);

      await _loadSeasonDetails();

    } catch (e) {
      print("Error loading TV show details: $e");
      // TODO: Add error handling for the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSeasonDetails() async {
    final seasonsSummary = _mediaDetails?.seasons;
    if (seasonsSummary == null || seasonsSummary.isEmpty) return;

    try {
      final futures = seasonsSummary.map((s) {
        return _tvShowRepository.getSeason(_seriesId, s.seasonNumber);
      }).toList();

      final seasonDetailsList = await Future.wait(futures);
      _seasonsList.clear();
      _seasonsList.addAll(seasonDetailsList);
    } catch (e) {
      print("Error loading season details: $e");
      // Ошибка загрузки деталей сезонов не должна блокировать остальное
    }
    // notifyListeners();
  }

  void _updateLocalStatuses(HiveTvShow? cachedTvShow) {
    _currentStatus = cachedTvShow?.status;
    _seasonWatchStatuses.clear();
    cachedTvShow?.seasons?.values.forEach((s) {
      _seasonWatchStatuses[s.seasonId] = s.status;
    });
  }

  void _subscribeToEvents() {
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if (event) {
        final cachedTvShow = await _localMediaTrackingService.getTVShowById(_seriesId);
        _updateLocalStatuses(cachedTvShow);
        notifyListeners();
      }
    });
  }


  @override
  Future<void> toggleFavorite(BuildContext context) async {
    _isFavoriteLoading = true;
    notifyListeners();
    try {
      await _tvShowRepository.makeFavorite(tvShowId: _seriesId, isFavorite: !_isFavorite);
      _isFavorite = !_isFavorite;
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: _isFavorite
              ? "TV show added to favorites." // TODO: Localize
              : "TV show removed from favorites." // TODO: Localize
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _isFavoriteLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleWatchlist(BuildContext context, int status) async {
    if(status != -1) {
      if(!_isWatched) {
        try{
          await _tvShowRepository.addToWatchlist(tvShowId: _seriesId, isWatched: true);
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

      final date = DateTime.now();

      if (_currentStatus == null || _currentStatus == 0 || status == 1) {
        try {
          var hiveSeasons = {
            for (var season in _seasonsList)
              season.seasonNumber: HiveSeasons(
                seasonId: season.id,
                airDate: season.airDate,
                status: _determineStatus(status, season.airDate, date),
                updatedAt: date,
                episodeCount: season.episodes.length,
                episodes: {
                  for (var episode in season.episodes)
                    episode.episodeNumber: HiveEpisodes(
                      episodeId: episode.id,
                      airDate: episode.airDate,
                      status: _determineStatus(status, episode.airDate, date),
                    ),
                },
              ),
          };

          if(status == 1) {
            hiveSeasons = {
              for (var entry in hiveSeasons.entries)
                entry.key: entry.value.episodes!.values.every((episode) => episode.status == 0)
                    ? HiveSeasons(
                  seasonId: entry.value.seasonId,
                  airDate: entry.value.airDate,
                  status: 0,
                  updatedAt: entry.value.updatedAt,
                  episodeCount: entry.value.episodeCount,
                  episodes: entry.value.episodes,
                )
                    : entry.value.episodes!.values.any((episode) => episode.status == 0)
                    ? HiveSeasons(
                  seasonId: entry.value.seasonId,
                  airDate: entry.value.airDate,
                  status: 2,
                  updatedAt: entry.value.updatedAt,
                  episodeCount: entry.value.episodeCount,
                  episodes: entry.value.episodes,
                )
                    : entry.value,
            };
          }

          final hiveTvShow = HiveTvShow(
            tvShowId: _seriesId,
            status: status,
            updatedAt: date,
            addedAt: date,
            tvShowName: _mediaDetails?.name,
            firstAirDate: _mediaDetails?.firstAirDate,
            seasons: hiveSeasons,
            autoSyncDate: date,
          );

          await _localMediaTrackingService.addTVShowDataAndStatus(hiveTvShow);
        } on Exception catch (e) {
          SnackBarMessageHandler.showErrorSnackBar(context);
          await _tvShowRepository.addToWatchlist(tvShowId: _seriesId, isWatched: false,);
          return;
        }
      } else {
        try {
          await _localMediaTrackingService.updateTVShowStatus(
            status: status,
            tvShowId: _seriesId,
            updatedAt: date,
          );
          _currentStatus = status;
          SnackBarMessageHandler.showSuccessSnackBar(
            context: context,
            message: "The TV show status has been updated.",
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
        message: "The TV show has been added to the watchlist.",
      );
      EventHelper.eventBus.fire(true);
    } else {
      try {
        await _tvShowRepository.addToWatchlist(tvShowId: _seriesId, isWatched: false,);
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
        await _localMediaTrackingService.deleteTVShowStatus(_seriesId);
      }
      catch (e) {
        await _tvShowRepository.addToWatchlist(tvShowId: _seriesId, isWatched: true,);
        SnackBarMessageHandler.showErrorSnackBar(context);
        return;
      }

      _isWatched = false;
      _currentStatus = null;
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: "The TV show has been removed from the watchlist.",
      );
      EventHelper.eventBus.fire(true);
    }
  }

  int _determineStatus( int status, String? airDate, DateTime date) {
    if(status == 1) {
      if ((airDate == null ||
          airDate.isEmpty ||
          DateTime.tryParse(airDate)?.isAfter(date) == true)) {
        return 0;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }

  @override
  Future<void> toggleAddRating(BuildContext context, double newRate) async {
    _isRatingLoading = true;
    notifyListeners();
    try {
      await _tvShowRepository.addRating(tvShowId: _seriesId, rate: newRate);
      _isRated = true;
      _rate = newRate;
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "TV show rated." // TODO: Localize
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _isRatingLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleDeleteRating(BuildContext context) async {
    if (!_isRated) return;
    _isRatingLoading = true;
    notifyListeners();
    try {
      await _tvShowRepository.deleteRating(tvShowId: _seriesId);
      _isRated = false;
      _rate = 0.0;
      SnackBarMessageHandler.showSuccessSnackBar(
        context: context,
        message: context.l10n.theRatingWasDeletedSuccessfully,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _isRatingLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> getAllUserLists(BuildContext context) async {
    if (_lists.isNotEmpty && !_isListsLoading) return;

    _isListsLoading = true;
    notifyListeners();

    _userListCurrentPage = 0;
    _userListTotalPage = 1;
    _lists.clear();

    try {
      while (_userListCurrentPage < _userListTotalPage) {
        final nextPage = _userListCurrentPage + 1;
        final userListsResponse = await _accountRepository.getUserLists(nextPage);
        _lists.addAll(userListsResponse.results);
        _userListCurrentPage = userListsResponse.page;
        _userListTotalPage = userListsResponse.totalPages;
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
      Navigator.of(context).pop();
    } catch(e) {
      print("Error loading user lists: $e");
      SnackBarMessageHandler.showErrorSnackBar(context);
      Navigator.of(context).pop();
    } finally {
      _isListsLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public}) async {
    _isAddToLisLoading = true;
    notifyListeners();
    try {
      await _accountRepository.addNewList(description: description, name: name, public: public);
      SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.listCreatedMessage(name));
      _lists.clear();
      Navigator.of(context).pop();
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch(e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _isAddToLisLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> addItemListToList({required BuildContext context, required int listId, required String name}) async {
    _isAddToLisLoading = true;
    notifyListeners();
    try {
      final isAdded = await _accountRepository.isAddedToListToList(
          listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId
      );

      if (isAdded) {
        SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.tvExistsInListMessage(name));
        Navigator.pop(context);
      } else {
        await _accountRepository.addItemListToList(
            listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId
        );
        SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.tvAddedToListMessage(name));
        final index = _lists.indexWhere((list) => list.id == listId);
        if (index != -1) {
          _lists[index].numberOfItems++;
        }
        Navigator.pop(context);
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
    } finally {
      _isAddToLisLoading = false;
      notifyListeners();
    }
  }

  void _handleApiClientException(ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
        break;
      default:
        SnackBarMessageHandler.showErrorSnackBar(context);
    }
  }

  void onCastListScreen(BuildContext context, List<Cast> cast) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.castList, arguments: cast);
  }

  void onCrewListScreen(BuildContext context, List<Crew> crew) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.crewList, arguments: crew);
  }

  void onPeopleDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onSeasonsListScreen(BuildContext context, List<Seasons>? seasons) {
    if (seasons == null) return;
    seasons.forEach((element) { element.tvShowId = _seriesId; });
    final argument = { NavParamConst.seasons: seasons, NavParamConst.tvShowId: _seriesId };
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonsList, arguments: argument);
  }

  void onSeasonDetailsScreen(BuildContext context, int index) {
    final seasonNumber = _mediaDetails?.seasons?[index].seasonNumber;
    if (seasonNumber == null) return;
    Navigator.of(context).pushNamed(
        MainNavigationRouteNames.seasonDetails,
        arguments: {NavParamConst.tvShowId: _seriesId, NavParamConst.seasonNumber: seasonNumber},
    );
  }

  void onMediaDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.recommendations?.list[index].id;
    final mediaType = _mediaDetails?.recommendations?.list[index].mediaType ?? 'tv';
    if (id == null) return;

    if (mediaType == 'movie') {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
    } else {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
    }
  }

  @override
  void onCollectionScreen(BuildContext context) {
    final id = _mediaDetails?.belongsToCollection?.id;
    if (id == null) return;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.collection, arguments: id);
  }

  @override
  Future<void> launchYouTubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(url, mode: LaunchMode.platformDefault)){
        print('Could not launch $url');
        // TODO: Show an error to user
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}