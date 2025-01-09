import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/movies/firebase_movies.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/seasons/firebase_seasons.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/tv_shows/firebase_tv_shows.dart';

class FirebaseMediaTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _users = "users";
  static const _movies = "movies";
  static const _tvShows = "tv_shows";
  static const _seasons = "seasons";

  Future<bool> updateMovieStatus({
    required int status,
    required int movieId,
    required String? title,
    required String? releaseDate,
  }) async {

    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docRef = _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_movies)
          .doc(movieId.toString());

      final movie = FirebaseMovies(
          movieId: movieId,
          movieTitle: title,
          releaseDate: releaseDate,
          status: status,
          updatedAt: DateTime.now());

      await docRef.set(movie.toJson(), SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMovieStatus(int movieId) async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docRef = _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_movies)
          .doc(movieId.toString());

      await docRef.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<FirebaseMovies?> getMovieById(int movieId) async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docSnapshot = await _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_movies)
          .doc(movieId.toString())
          .get();

      return FirebaseMovies.fromJson(docSnapshot.data()!);
    } catch(e) {
      return null;
    }
  }

  Future<List<FirebaseMovies>> getAllMovies() async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final querySnapshot = await _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_movies)
          .get();

      return querySnapshot.docs
          .map((doc) => FirebaseMovies.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }


  //TV SHOW
  Future<bool> updateTVShowStatus({
    required int status,
    required int tvShowId,
    required String? title,
    required String? firstAirDate,
  }) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docRef = _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_tvShows)
          .doc(tvShowId.toString());

      final tvShow = FirebaseTvShow(
        tvShowId: tvShowId,
        tvShowName: title,
        firstAirDate: firstAirDate,
        status: status,
        updatedAt: DateTime.now(),
      );

      await docRef.set(tvShow.toJson(), SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> firstSyncTVShowData({
  //   required int tvShowId,
  //   required String? tvShowName,
  //   required String? firstAirDate,
  //   required int status,
  //   required DateTime updatedAt,
  //   required List<FirebaseSeasons> seasons,
  // }) async {
  //   if (_auth.currentUser?.uid == null) {
  //     throw Exception("User not authorized");
  //   }
  //
  //   try {
  //     print("Start 'firstSyncTVShowData': " + DateTime.now().toString());
  //     final userId = _auth.currentUser!.uid;
  //
  //     // Ссылка на документ сериала
  //     final tvShowDocRef = _firestore
  //         .collection(_users)
  //         .doc(userId)
  //         .collection(_tvShows)
  //         .doc(tvShowId.toString());
  //
  //     final batch = _firestore.batch();
  //
  //     // Добавляем сериал
  //     final tvShowData = FirebaseTvShows(
  //       tvShowId: tvShowId,
  //       tvShowName: tvShowName,
  //       firstAirDate: firstAirDate,
  //       status: status,
  //       updatedAt: updatedAt,
  //     ).toJson();
  //
  //     batch.set(tvShowDocRef, tvShowData);
  //
  //     // Добавляем сезоны
  //     for (var season in seasons) {
  //       final seasonDocRef = tvShowDocRef.collection(_seasons).doc(season.seasonNumber.toString());
  //       batch.set(seasonDocRef, season.toJson());
  //     }
  //
  //     // Выполняем батч
  //     await batch.commit();
  //
  //     print("Finish 'firstSyncTVShowData': " + DateTime.now().toString());
  //     return true;
  //   } catch (e) {
  //     print("Error syncing TV Show data: $e");
  //     return false;
  //   }
  // }

  Future<bool> firstSyncTVShowData({
    required int tvShowId,
    required String? tvShowName,
    required String? firstAirDate,
    required int status,
    required DateTime updatedAt,
    required List<FirebaseSeasons> seasons,
  }) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      print("Start 'firstSyncTVShowData': ${DateTime.now()}");
      final userId = _auth.currentUser!.uid;

      // Ссылка на документ сериала
      final tvShowDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString());

      // Разбиваем операции на группы
      final operations = <WriteBatch>[];
      WriteBatch currentBatch = _firestore.batch();
      int operationCount = 0;

      // Добавляем сериал в первый батч
      final tvShowData = FirebaseTvShow(
        tvShowId: tvShowId,
        tvShowName: tvShowName,
        firstAirDate: firstAirDate,
        status: status,
        updatedAt: updatedAt,
      ).toJson();
      currentBatch.set(tvShowDocRef, tvShowData);
      operationCount++;

      // Добавляем сезоны
      for (var season in seasons) {
        final seasonDocRef = tvShowDocRef.collection(_seasons).doc(season.seasonNumber.toString());
        currentBatch.set(seasonDocRef, season.toJson());
        operationCount++;

        // Если достигли 5 операций, сохраняем текущий батч и создаем новый
        if (operationCount == 4) {
          operations.add(currentBatch);
          currentBatch = _firestore.batch();
          operationCount = 0;
        }
      }

      // Добавляем оставшиеся операции
      if (operationCount > 0) {
        operations.add(currentBatch);
      }

      // Выполняем батчи с паузой
      for (var i = 0; i < operations.length; i++) {
        await operations[i].commit();
        if (i < operations.length - 1) {
          await Future.delayed(const Duration(milliseconds: 400));
        }
      }

      print("Finish 'firstSyncTVShowData': ${DateTime.now()}");
      return true;
    } catch (e) {
      print("Error syncing TV Show data: $e");
      return false;
    }
  }


  Future<FirebaseTvShow?> getTVShowById(int tvShowId) async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docSnapshot = await _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_tvShows)
          .doc(tvShowId.toString())
          .get();

      return FirebaseTvShow.fromJson(docSnapshot.data()!);
    } catch (e) {
      return null;
    }
  }

  Future<List<FirebaseMovies>> getAllTVShows() async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final querySnapshot = await _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_tvShows)
          .get();

      return querySnapshot.docs
          .map((doc) => FirebaseMovies.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }


  //Seasons
  Future<FirebaseSeasons?> getSeason(int tvShowId, int seasonNumber) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;
      final seasonDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString())
          .collection(_seasons)
          .doc(seasonNumber.toString());

      final seasonSnapshot = await seasonDocRef.get();

      if (seasonSnapshot.exists) {
        return FirebaseSeasons.fromJson(seasonSnapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting season: $e");
      return null;
    }
  }

  Future<List<FirebaseSeasons>> getAllSeasonStatus(int tvShowId) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;

      final seasonQuerySnapshot = await _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString())
          .collection(_seasons)
          .get();

      return seasonQuerySnapshot.docs
          .map((doc) => FirebaseSeasons.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  //Series
  Future<bool> updateEpisodeStatus({
    required int tvShowId,
    required int seasonNumber,
    required int episodeNumber,
    required int status,
  }) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;

      final seasonDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString())
          .collection(_seasons)
          .doc(seasonNumber.toString());

      final episodeFieldPath = 'episodes.$episodeNumber.status';
      await seasonDocRef.update({episodeFieldPath: status});

      return true;
    } catch (e) {
      print("Error updating episode status: $e");
      return false;
    }
  }
}