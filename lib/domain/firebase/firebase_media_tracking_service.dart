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

  Future<bool> addMovieAndStatus(FirebaseMovies firebaseMovies) async {
    if(_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final docRef = _firestore
          .collection(_users)
          .doc(_auth.currentUser?.uid)
          .collection(_movies)
          .doc(firebaseMovies.movieId.toString());

      await docRef.set(firebaseMovies.toJson(), SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMovieStatus({
    required int movieId,
    required int status,
    required String updatedAt,
  }) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;

      final movieDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_movies)
          .doc(movieId.toString());

      await movieDocRef.update({
        'status': status,
        'updated_at': updatedAt,
      });

      return true;
    } catch (e) {
      print("Error updating Movie status and date: $e");
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
    required int tvShowId,
    required int status,
    required String updatedAt,
  }) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;

      final tvShowDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString());

      await tvShowDocRef.update({
        'status': status,
        'updated_at': updatedAt,
      });

      return true;
    } catch (e) {
      print("Error updating TV Show status and date: $e");
      return false;
    }
  }

  Future<bool> addTVShowDataAndStatus(FirebaseTvShow tvShow) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("User not authorized");
    }

    try {
      final userId = _auth.currentUser!.uid;

      // Ссылка на документ сериала
      final tvShowDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShow.tvShowId.toString());

      // Данные для записи
      final tvShowData = tvShow.toJson();

      // Выполняем запись сериала в Firestore
      await tvShowDocRef.set(tvShowData);

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

      final tvShowDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString());

      final tvShowSnapshot = await tvShowDocRef.get();

      if (tvShowSnapshot.exists) {
        final tvShowData = tvShowSnapshot.data();
        if (tvShowData != null && tvShowData['seasons'] != null) {
          // Извлечение данных о сезоне из карты `seasons`
          final seasonsMap = tvShowData['seasons'] as Map<String, dynamic>;
          final seasonData = seasonsMap[seasonNumber.toString()];

          if (seasonData != null) {
            return FirebaseSeasons.fromJson(Map<String, dynamic>.from(seasonData));
          }
        }
      }

      return null;
    } catch (e) {
      print("Error getting season: $e");
      return null;
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

      final tvShowDocRef = _firestore
          .collection(_users)
          .doc(userId)
          .collection(_tvShows)
          .doc(tvShowId.toString());

      final episodeStatusFieldPath = 'seasons.$seasonNumber.episodes.$episodeNumber.status';

      await tvShowDocRef.update({episodeStatusFieldPath: status});

      return true;
    } catch (e) {
      print("Error updating episode status: $e");
      return false;
    }
  }
}