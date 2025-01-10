import 'package:hive/hive.dart';
import 'package:the_movie_app/domain/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/domain/firebase/firebase_media_tracking_service.dart';

extension FirebaseSyncService on FirebaseMediaTrackingService {
  Future<void> syncAllDataToFirebase() async {
    if (auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    final _localService = LocalMediaTrackingService();

    // Синхронизация фильмов
    final localMovies = await _localService.getAllMovies();
    for (var movie in localMovies) {
      await addMovieAndStatus(movie.toFirebaseMovie());
    }

    // Синхронизация сериалов
    final localTVShows = await _localService.getAllTVShows();
    for (var tvShow in localTVShows) {
      await addTVShowDataAndStatus(tvShow.toFirebaseTvShow());
    }
  }

  Future<void> clearLocalData() async {
    await Hive.deleteBoxFromDisk(LocalMediaTrackingService.moviesBoxName);
    await Hive.deleteBoxFromDisk(LocalMediaTrackingService.tvShowsBoxName);
    await LocalMediaTrackingService.init();
  }
}