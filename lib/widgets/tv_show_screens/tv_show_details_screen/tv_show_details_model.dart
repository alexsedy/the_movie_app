import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/hive/hive_episodes/hive_episodes.dart';
import 'package:the_movie_app/domain/entity/hive/hive_seasons/hive_seasons.dart';
import 'package:the_movie_app/domain/entity/hive/hive_tv_show/hive_tv_show.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
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


class TvShowDetailsModel extends ChangeNotifier implements IBaseMediaDetailsModel{
  final _apiClient = TvShowApiClient();
  final _accountApiClient = AccountApiClient();
  MediaDetails? _tvShowDetails;
  ItemState? _tvShowState;
  AccountSate? _accountSate;
  final int _seriesId;
  final _lists = <Lists>[];
  final _seasonsList = <Season>[];
  final _dateFormat = DateFormat.yMMMd();
  bool _isFavorite = false;
  bool _isWatched = false;
  bool _isRated = false;
  // bool _isFBLinked = false;
  double _rate = 0;
  late int _currentPage;
  late int _totalPage;
  final _statuses = [1, 2, 3, 4, 5, 99];
  int? _currentStatus;
  final _localMediaTrackingService = LocalMediaTrackingService();
  final _seasonWatchStatuses = <int, int>{};
  StreamSubscription? _subscription;

  @override
  List<int> get statuses => _statuses;

  @override
  MediaDetails? get mediaDetails => _tvShowDetails;

  ItemState? get tvShowState => _tvShowState;

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

  Map<int, int> get seasonWatchStatuses => _seasonWatchStatuses;

  TvShowDetailsModel(this._seriesId){
    _subscription = EventHelper.eventBus.on<bool>().listen((event) async {
      if(event) {
        await _getTvShowStatus();
        notifyListeners();
      }
    });
  }

  Future<void> loadTvShowDetails() async {
    _tvShowDetails = await _apiClient.getTvShowById(_seriesId);
    _tvShowState = await _apiClient.getTvShowState(_seriesId);
    
    if(_tvShowState != null) {
      _isFavorite = _tvShowState?.favorite ?? false;
      _isWatched = _tvShowState?.watchlist ?? false;

      final rated = _tvShowState?.rated;
      if(rated != null) {
        _rate = rated.value ?? 0;
        _isRated = true;
      }
    }

    final seasons = await _tvShowDetails?.seasons;
    if (seasons != null) {
      final futures = seasons.map((s) {
        return _apiClient.getSeason(_seriesId, s.seasonNumber);
      }).toList();

      final seasonDetails = await Future.wait(futures);
      _seasonsList.addAll(seasonDetails);
    }

    await _getTvShowStatus();

    // await _getFBStatus();

    notifyListeners();
  }

  // Future<void> _getFBStatus() async {
  //   _isFBLinked = await AccountManager.getFBLinkStatus();
  // }

  Future<void> _getTvShowStatus() async {
    final cachedTvShow = await _localMediaTrackingService
        .getTVShowById(_seriesId);

    cachedTvShow?.seasons?.values.forEach((s) {
      _seasonWatchStatuses[s.seasonId] = s.status;
    });
    
    _currentStatus = cachedTvShow?.status;
  }

  @override
  Future<void> toggleFavorite(BuildContext context) async {
    try {
      await _apiClient.makeFavorite(tvShowId: _seriesId, isFavorite: !_isFavorite,);
      _isFavorite = !_isFavorite;
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: _isFavorite
              ? "The TV show has been added to the favorite list."
              : "The TV show has been removed from the favorite list."
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
        try{
          await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true);
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
            tvShowName: _tvShowDetails?.name,
            firstAirDate: _tvShowDetails?.firstAirDate,
            seasons: hiveSeasons,
            autoSyncDate: date,
          );

          await _localMediaTrackingService.addTVShowDataAndStatus(hiveTvShow);
        } on Exception catch (e) {
          SnackBarMessageHandler.showErrorSnackBar(context);
          await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false,);
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
        await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false,);
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
        await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true,);
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

  // Future<void> toggleWatchlist(BuildContext context, int status) async {
  //   if (status != -1) {
  //     await _handleWatchlistAddition(context, status);
  //   } else {
  //     await _handleWatchlistRemoval(context);
  //   }
  // }
  //
  // Future<void> _handleWatchlistAddition(BuildContext context, int status) async {
  //   if (!_isWatched) {
  //     if (!await _addToWatchlist(context)) return;
  //   }
  //
  //   final date = DateTime.now();
  //
  //   if (_currentStatus == null || _currentStatus == 0 || _currentStatus == 1) {
  //     if (!await _addTVShowData(context, date, status)) return;
  //   } else {
  //     if (!await _updateTVShowStatus(context, date)) return;
  //   }
  //
  //   _isWatched = true;
  //   _currentStatus = 1;
  //   notifyListeners();
  //   SnackBarMessageHandler.showSuccessSnackBar(
  //     context: context,
  //     message: "The TV show has been added to the watchlist.",
  //   );
  //   EventHelper.eventBus.fire(true);
  // }
  //
  // Future<void> _handleWatchlistRemoval(BuildContext context) async {
  //   if (!await _removeFromWatchlist(context)) return;
  //   if (!await _deleteTVShowStatus(context)) return;
  //
  //   _isWatched = false;
  //   _currentStatus = null;
  //   notifyListeners();
  //   SnackBarMessageHandler.showSuccessSnackBar(
  //     context: context,
  //     message: "The TV show has been removed from the watchlist.",
  //   );
  //   EventHelper.eventBus.fire(true);
  // }
  //
  // Future<bool> _addToWatchlist(BuildContext context) async {
  //   try {
  //     await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true);
  //     return true;
  //   } on ApiClientException catch (e) {
  //     if (e.type == ApiClientExceptionType.sessionExpired) {
  //       SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
  //     } else {
  //       SnackBarMessageHandler.showErrorSnackBar(context);
  //     }
  //     return false;
  //   }
  // }
  //
  // Future<bool> _addTVShowData(BuildContext context, DateTime date, int status) async {
  //   try {
  //     var hiveSeasons = {
  //       for (var season in _seasonsList)
  //         season.seasonNumber: HiveSeasons(
  //           seasonId: season.id,
  //           airDate: season.airDate,
  //           status: _determineStatus(status, season.airDate, date),
  //           updatedAt: date,
  //           episodeCount: season.episodes.length,
  //           episodes: {
  //             for (var episode in season.episodes)
  //               episode.episodeNumber: HiveEpisodes(
  //                 episodeId: episode.id,
  //                 airDate: episode.airDate,
  //                 status: _determineStatus(status, episode.airDate, date),
  //               ),
  //           },
  //         ),
  //     };
  //
  //     if(status == 1) {
  //       hiveSeasons = {
  //         for (var entry in hiveSeasons.entries)
  //           entry.key: entry.value.episodes!.values.every((episode) => episode.status == 0)
  //               ? HiveSeasons(
  //             seasonId: entry.value.seasonId,
  //             airDate: entry.value.airDate,
  //             status: 0,
  //             updatedAt: entry.value.updatedAt,
  //             episodeCount: entry.value.episodeCount,
  //             episodes: entry.value.episodes,
  //           )
  //               : entry.value.episodes!.values.any((episode) => episode.status == 0)
  //               ? HiveSeasons(
  //             seasonId: entry.value.seasonId,
  //             airDate: entry.value.airDate,
  //             status: 2,
  //             updatedAt: entry.value.updatedAt,
  //             episodeCount: entry.value.episodeCount,
  //             episodes: entry.value.episodes,
  //           )
  //               : entry.value,
  //       };
  //     }
  //
  //     final hiveTvShow = HiveTvShow(
  //       tvShowId: _seriesId,
  //       status: 1,
  //       updatedAt: date,
  //       addedAt: date,
  //       tvShowName: _tvShowDetails?.name,
  //       firstAirDate: _tvShowDetails?.firstAirDate,
  //       seasons: hiveSeasons,
  //     );
  //
  //     await _localMediaTrackingService.addTVShowDataAndStatus(hiveTvShow);
  //     return true;
  //   } on Exception catch (e) {
  //     SnackBarMessageHandler.showErrorSnackBar(context);
  //     await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false);
  //     return false;
  //   }
  // }
  //
  // Future<bool> _updateTVShowStatus(BuildContext context, DateTime date) async {
  //   try {
  //     await _localMediaTrackingService.updateTVShowStatus(
  //       status: 1,
  //       tvShowId: _seriesId,
  //       updatedAt: date.toString(),
  //     );
  //     _currentStatus = 1;
  //     SnackBarMessageHandler.showSuccessSnackBar(
  //       context: context,
  //       message: "The TV show status has been updated.",
  //     );
  //     notifyListeners();
  //     return true;
  //   } on Exception catch (e) {
  //     SnackBarMessageHandler.showErrorSnackBar(context);
  //     return false;
  //   }
  // }
  //
  // Future<bool> _removeFromWatchlist(BuildContext context) async {
  //   try {
  //     await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false);
  //     return true;
  //   } on ApiClientException catch (e) {
  //     if (e.type == ApiClientExceptionType.sessionExpired) {
  //       SnackBarMessageHandler.showErrorSnackBarWithLoginButton(context);
  //     } else {
  //       SnackBarMessageHandler.showErrorSnackBar(context);
  //     }
  //     return false;
  //   }
  // }
  //
  // Future<bool> _deleteTVShowStatus(BuildContext context) async {
  //   try {
  //     await _localMediaTrackingService.deleteTVShowStatus(_seriesId);
  //     return true;
  //   } catch (e) {
  //     await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true);
  //     SnackBarMessageHandler.showErrorSnackBar(context);
  //     return false;
  //   }
  // }

  @override
  Future<void> toggleAddRating(BuildContext context, double rate) async {
    try {
      await _apiClient.addRating(tvShowId: _seriesId, rate: rate);
      if (_isRated == false) {
        _isRated = !_isRated;
      }
      notifyListeners();
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "The TV show rating has been added."
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
        await _apiClient.deleteRating(tvShowId: _seriesId);
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
    final isSuccess = await _accountApiClient.isAddedToListToList(listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId);

    if(isSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          context.l10n.tvExistsInListMessage(name),
          style: const TextStyle(fontSize: 20),),)
      );
    } else {
      await SnackBarHelper.handleErrorWithMessage(
        apiReq: () =>
            _accountApiClient.addItemListToList(
                listId: listId, mediaType: MediaType.tvShow, mediaId: _seriesId),
        context: context,
        message: name,
        messageType: MessageType.tvShowAddedToList,
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
    final id = _tvShowDetails?.credits.cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }

  void onSeasonsListScreen(BuildContext context, List<Seasons>? seasons) {
    seasons?.forEach((element) {
      element.tvShowId = _seriesId;
    });
    final argument = {
      "seasons": seasons,
      "tvShowId": _seriesId
    };
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonsList, arguments: argument);
  }

  void onSeasonDetailsScreen(BuildContext context, int index) {
    final seasonNumber = _tvShowDetails?.seasons?[index].seasonNumber;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonDetails, arguments: [_seriesId, seasonNumber]);
  }

  void onMediaDetailsScreen(BuildContext context, int index){
    final id = _tvShowDetails?.recommendations?.list[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
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
      date != "" && date != null ? _dateFormat.format(DateTime.parse(date)) : "";

  @override
  void onCollectionScreen(BuildContext context) {
    // TODO: implement onCollectionScreen
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
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}