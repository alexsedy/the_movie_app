import 'package:flutter/material.dart';
import 'package:the_movie_app/core/helpers/event_helper.dart';
import 'package:the_movie_app/core/helpers/snack_bar_message_handler.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/account/user_lists/user_lists.dart';
import 'package:the_movie_app/data/models/hive/hive_movies/hive_movies.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/data/models/media/state/item_state.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/data/repositories/i_account_repository.dart';
import 'package:the_movie_app/data/repositories/i_movie_repository.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsViewModel extends ChangeNotifier implements IBaseMediaDetailsModel {
  final int _movieId;
  final IMovieRepository _movieRepository;
  final IAccountRepository _accountRepository;
  final LocalMediaTrackingService _localMediaTrackingService;

  MediaDetails? _mediaDetails;
  final _lists = <Lists>[];
  bool _isFavorite = false;
  bool _isWatched = false;
  bool _isRated = false;
  double _rate = 0;
  int? _currentStatus;
  bool _isLoading = true;
  bool _isListsLoading = false;
  // Пагинация для списков пользователя (если нужно)
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
  final List<int> statuses = const [1, 3, 5, 99];

  bool get isLoading => _isLoading;
  bool get isListsLoading => _isListsLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  bool get isWatchlistLoading => _isWatchlistLoading;
  bool get isRatingLoading => _isRatingLoading;
  bool get isAddToLisLoading => _isAddToLisLoading;

  @override
  set rate(value) => _rate = value;

  MovieDetailsViewModel(
      this._movieId,
      this._movieRepository,
      this._accountRepository,
      this._localMediaTrackingService,
      ) {
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _movieRepository.getMovieById(_movieId),
        _movieRepository.getMovieState(_movieId),
        _localMediaTrackingService.getMovieById(_movieId),
      ]);

      _mediaDetails = results[0] as MediaDetails;
      final movieState = results[1] as ItemState?;
      final localMovie = results[2] as HiveMovies?;

      if (movieState != null) {
        _isFavorite = movieState.favorite;
        _isWatched = movieState.watchlist;
        final ratedState = movieState.rated;
        if (ratedState != null) {
          _rate = ratedState.value ?? 0;
          _isRated = true;
        } else {
          _isRated = false;
          _rate = 0;
        }
      }

      _currentStatus = localMovie?.status;
      if (_currentStatus != null && _currentStatus != 0) {
        // _isWatched = true;
      }

    } catch (e) {
      // TODO: Handle error
      print("Error loading movie details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleFavorite(BuildContext context) async {
    _isFavoriteLoading = true;
    notifyListeners();
    try {
      await _movieRepository.addToFavorite(movieId: _movieId, isFavorite: !_isFavorite);
      _isFavorite = !_isFavorite;
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: _isFavorite
              ? "The movie has been added to the favorite list." // TODO: Localize
              : "The movie has been removed from the favorite list."
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
    if (status == _currentStatus && status != -1) return;

    _isWatchlistLoading = true;
    notifyListeners();

    try {
      if (status != -1) {
        if (!_isWatched) {
          await _movieRepository.addToWatchlist(movieId: _movieId, isWatched: true);
          _isWatched = true;
        }

        final date = DateTime.now();
        final existingMovie = await _localMediaTrackingService.getMovieById(_movieId);

        if (existingMovie == null) {
          final movieToAdd = HiveMovies(
            movieId: _movieId,
            movieTitle: _mediaDetails?.title,
            releaseDate: _mediaDetails?.releaseDate,
            status: status,
            updatedAt: date,
            addedAt: date,
            autoSyncDate: date,
          );
          await _localMediaTrackingService.addMovieAndStatus(movieToAdd);
        } else {
          await _localMediaTrackingService.updateMovieStatus(
            movieId: _movieId,
            status: status,
            updatedAt: date,
          );
        }
        _currentStatus = status;
        SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "Movie status updated.", // TODO: Localize
        );
      } else {
        if (_isWatched) {
          await _movieRepository.addToWatchlist(movieId: _movieId, isWatched: false);
          _isWatched = false;
        }
        await _localMediaTrackingService.deleteMovieStatus(_movieId);
        _currentStatus = null;
        SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "Movie removed from watchlist.", // TODO: Localize
        );
      }
      EventHelper.eventBus.fire(true);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
      // TODO: Откатить изменения состояния при ошибке?
    } catch (e) {
      SnackBarMessageHandler.showErrorSnackBar(context);
      // TODO: Откатить изменения состояния при ошибке?
    } finally {
      _isWatchlistLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> toggleAddRating(BuildContext context, double newRate) async {
    _isRatingLoading = true;
    notifyListeners();
    try {
      await _movieRepository.addRating(movieId: _movieId, rate: newRate);
      _isRated = true;
      _rate = newRate;
      SnackBarMessageHandler.showSuccessSnackBar(
          context: context,
          message: "Movie rated." // TODO: Localize
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
      await _movieRepository.deleteRating(movieId: _movieId);
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
    // Загружаем только если списки еще не загружены
    if (_lists.isNotEmpty && !_isListsLoading) return;

    _isListsLoading = true;
    notifyListeners(); // Показать индикатор загрузки списков

    _userListCurrentPage = 0; // Сброс пагинации
    _userListTotalPage = 1;
    _lists.clear();

    try {
      // Можно добавить пагинацию, если списков может быть много
      while (_userListCurrentPage < _userListTotalPage) {
        final nextPage = _userListCurrentPage + 1;
        final userListsResponse = await _accountRepository.getUserLists(nextPage);
        _lists.addAll(userListsResponse.results);
        _userListCurrentPage = userListsResponse.page;
        _userListTotalPage = userListsResponse.totalPages;
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context); // Обрабатываем ошибку сессии и др.
      Navigator.of(context).pop(); // Закрываем bottom sheet при ошибке сессии
    } catch(e) {
      print("Error loading user lists: $e");
      SnackBarMessageHandler.showErrorSnackBar(context);
      Navigator.of(context).pop(); // Закрываем bottom sheet при другой ошибке
    } finally {
      _isListsLoading = false;
      notifyListeners(); // Обновить UI (убрать индикатор, показать списки)
    }
  }

  @override
  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public}) async {
    _isAddToLisLoading = true; // Используем общий флаг или создадим отдельный
    notifyListeners();
    try {
      await _accountRepository.addNewList(description: description, name: name, public: public);
      SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.listCreatedMessage(name));
      // После создания нового списка нужно обновить список доступных списков
      _lists.clear(); // Очищаем кэш
      // getAllUserLists(context); // Перезагружаем списки (можно сделать опционально)
      Navigator.of(context).pop(); // Закрываем диалог создания
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
      // Проверка, есть ли уже элемент в списке
      final isAdded = await _accountRepository.isAddedToListToList(
          listId: listId, mediaType: MediaType.movie, mediaId: _movieId
      );

      if (isAdded) {
        SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.movieExistsInListMessage(name));
        Navigator.pop(context); // Закрываем bottom sheet со списками
      } else {
        // Добавляем элемент
        await _accountRepository.addItemListToList(
            listId: listId, mediaType: MediaType.movie, mediaId: _movieId
        );
        SnackBarMessageHandler.showSuccessSnackBar(context: context, message: context.l10n.movieAddedToListMessage(name));
        // Обновляем количество элементов в списке (опционально)
        final index = _lists.indexWhere((list) => list.id == listId);
        if (index != -1) {
          _lists[index].numberOfItems++; // Увеличиваем счетчик локально
        }
        Navigator.pop(context); // Закрываем bottom sheet со списками
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

  // --- Вспомогательные методы ---
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

  void onMediaDetailsScreen(BuildContext context, int index) {
    final id = _mediaDetails?.recommendations?.list[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  void onCollectionScreen(BuildContext context) {
    final id = _mediaDetails?.belongsToCollection?.id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.collection, arguments: id);
  }

  @override
  Future<void> launchYouTubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(url, mode: LaunchMode.platformDefault)){
        print('Could not launch $url');
        // TODO: Show error message to user
      }
    }
  }
}