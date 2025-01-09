import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/account_api_client.dart';
import 'package:the_movie_app/domain/api_client/tv_show_api_client.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/domain/entity/account/account_state/account_state.dart';
import 'package:the_movie_app/domain/entity/account/user_lists/user_lists.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/episodes/firebase_episodes.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/seasons/firebase_seasons.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/tv_shows/firebase_tv_shows.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/domain/entity/media/media_details/media_details.dart';
import 'package:the_movie_app/domain/entity/media/season/season.dart';
import 'package:the_movie_app/domain/entity/media/state/item_state.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/domain/firebase/firebase_media_tracking_service.dart';
import 'package:the_movie_app/helpers/snack_bar_helper.dart';
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
  bool _isFBLinked = false;
  double _rate = 0;
  late int _currentPage;
  late int _totalPage;
  final _statuses = [1, 2, 3, 4, 5, 99];
  int? _currentStatus;
  final _firebaseMediaTrackingService = FirebaseMediaTrackingService();

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

  bool get isFBlinked => _isFBLinked;

  @override
  int? get currentStatus => _currentStatus;

  TvShowDetailsModel(this._seriesId);

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

    await _getFBStatus();

    notifyListeners();
  }

  Future<void> _getFBStatus() async {
    _isFBLinked = await AccountManager.getFBLinkStatus();

    if(_isFBLinked) {
      final seasons = await _tvShowDetails?.seasons;
      if (seasons != null) {
        final futures = seasons.map((s) {
          return _apiClient.getSeason(_seriesId, s.seasonNumber);
        }).toList();

        final seasonDetails = await Future.wait(futures);
        _seasonsList.addAll(seasonDetails);
      }

      final firebaseTvShow = await _firebaseMediaTrackingService
          .getTVShowById(_seriesId);
      _currentStatus = firebaseTvShow?.status;
    }
  }

  @override
  Future<void> toggleFavorite(BuildContext context) async {
    final result = await SnackBarHelper.handleErrorDefaultLists(
      apiReq: () => _apiClient.makeFavorite(tvShowId: _seriesId, isFavorite: !_isFavorite,),
      context: context,
    );
    if(result) {
      _isFavorite = !_isFavorite;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleWatchlist(BuildContext context, [int? status]) async {
    if(status != null) {
      bool result;
      if(_isWatched) {
        result = true;
      } else {
        result = await SnackBarHelper.handleErrorDefaultLists(
          apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true,),
          context: context,
        );
      }

      final date = DateTime.now();

      bool fbResultTvShow;
      try {
        if (_currentStatus == null || _currentStatus == 0 || status == 1) {
          final fbSeasons = {
            for (var season in _seasonsList)
              season.seasonNumber: FirebaseSeasons(
                seasonId: season.id,
                airDate: season.airDate,
                status: status == 1 ? status : 0,
                updatedAt: date,
                episodeCount: season.episodes.length,
                episodes: {
                  for (var episode in season.episodes)
                    episode.episodeNumber: FirebaseEpisodes(
                      episodeId: episode.id,
                      airDate: episode.airDate,
                      status: status == 1 ? status : 0,
                    ),
                },
              ),
          };

          final fbTvShow = FirebaseTvShow(
            tvShowId: _seriesId,
            status: status,
            updatedAt: date,
            addedAt: date,
            tvShowName: _tvShowDetails?.name,
            firstAirDate: _tvShowDetails?.firstAirDate,
            seasons: fbSeasons,
          );

          // Сохранение всех данных в Firebase
          fbResultTvShow = await _firebaseMediaTrackingService
              .addTVShowDataAndStatus(fbTvShow);
        } else {

          fbResultTvShow = await _firebaseMediaTrackingService.updateTVShowStatus(
            status: status,
            tvShowId: _seriesId,
            updatedAt: date.toString(),
          );
        }
      } catch (e) {
        fbResultTvShow = false;
      }

      if(result && fbResultTvShow) {
        _isWatched = true;
        _currentStatus = status;
        notifyListeners();
      } else {
        await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(
            context.l10n.anErrorHasOccurredTryAgainLater,
            style: const TextStyle(fontSize: 20),),
        ));
      }
    } else {
      final result = await SnackBarHelper.handleErrorDefaultLists(
        apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: !_isWatched,),
        context: context,
      );
      if (result) {
        _isWatched = !_isWatched;
        notifyListeners();
      }
    }
  }
  // Future<void> toggleWatchlist(BuildContext context, [int? status]) async {
  //   if(status != null) {
  //     final result = await SnackBarHelper.handleErrorDefaultLists(
  //       apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: true,),
  //       context: context,
  //     );
  //
  //     final fbResultTvShow = await _firebaseMediaTrackingService.updateTVShowStatus(
  //         tvShowId: _seriesId,
  //         tvShowName: _tvShowDetails?.name,
  //         firstAirDate: _tvShowDetails?.firstAirDate,
  //         status: status
  //     );
  //
  //     final seasons = await _tvShowDetails?.seasons;
  //
  //     if (seasons != null) {
  //       for (var s in seasons) {
  //         try {
  //           await _firebaseMediaTrackingService.updateSeasonStatus(
  //             status: 0,
  //             tvShowId: _seriesId,
  //             seasonNumber: s.seasonNumber,
  //             seasonId: s.id,
  //             tvShowName: _tvShowDetails?.name,
  //             tvShowAirDate: _tvShowDetails?.firstAirDate,
  //             seasonAirDate: s.airDate,
  //             episodeCount: s.episodeCount,
  //           );
  //         } catch (e) {
  //         }
  //       }
  //     }
  //
  //     if(seasons != null) {
  //       for (var s in seasons) {
  //         final seasonDetail = await _apiClient.getSeason(_seriesId, s.seasonNumber);
  //         for (var e in seasonDetail.episodes) {
  //           try {
  //             await _firebaseMediaTrackingService.updateSeriesStatus(
  //                 tvShowId: _seriesId,
  //                 tvShowName: _tvShowDetails?.name,
  //                 tvShowAirDate: _tvShowDetails?.firstAirDate,
  //                 seasonNumber: s.seasonNumber,
  //                 seasonId: s.id,
  //                 seasonAirDate: s.airDate,
  //                 episodeNumber: e.episodeNumber,
  //                 episodeId: e.id,
  //                 episodeAirDate: e.airDate,
  //                 status: 0,
  //                 episodeCount: s.episodeCount);
  //           } catch (e) {
  //           }
  //         }
  //       }
  //     }
  //
  //     if(result && fbResultTvShow) {
  //       _isWatched = true;
  //       _currentStatus = status;
  //       notifyListeners();
  //     } else {
  //       await _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: false);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         duration: const Duration(seconds: 5),
  //         content: Text(
  //           context.l10n.anErrorHasOccurredTryAgainLater,
  //           style: const TextStyle(fontSize: 20),),
  //       ));
  //     }
  //   } else {
  //     final result = await SnackBarHelper.handleErrorDefaultLists(
  //       apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: !_isWatched,),
  //       context: context,
  //     );
  //     if (result) {
  //       _isWatched = !_isWatched;
  //       notifyListeners();
  //     }
  //   }
  // }

  // @override
  // Future<void> toggleWatchlist(BuildContext context, [int? status]) async {
  //   final result = await SnackBarHelper.handleErrorDefaultLists(
  //     apiReq: () => _apiClient.addToWatchlist(tvShowId: _seriesId, isWatched: !_isWatched,),
  //     context: context,
  //   );
  //   if(result) {
  //     _isWatched = !_isWatched;
  //     notifyListeners();
  //   }
  // }

  @override
  Future<void> toggleAddRating(BuildContext context, double rate) async {
    final result = await SnackBarHelper.handleErrorDefaultLists(
      apiReq: () => _apiClient.addRating(tvShowId: _seriesId, rate: rate),
      context: context,
    );
    if(result && _isRated == false) {
      _isRated = !_isRated;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleDeleteRating(BuildContext context) async {
    if(_isRated) {
      final result = await SnackBarHelper.handleErrorDefaultLists(
        apiReq: () => _apiClient.deleteRating(tvShowId: _seriesId),
        context: context,
      );
      if (result) {
        _isRated = !_isRated;
        _rate = 0.0;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(context.l10n.theRatingWasDeletedSuccessfully,
            style: const TextStyle(fontSize: 20),),
        ));
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
    Navigator.of(context).pushNamed(MainNavigationRouteNames.seasonsList, arguments: seasons);
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
}