import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/user_profile/firebase_user_profile.dart';

class FirebaseAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _users = "users";

  static const _tmdbUsernameField = "tmdb_username";
  static const _tmdbAccountIdField = "tmdb_account_id";

  Future<bool> checkLinkStatus(String? tmdbAccountId) async {
    try {
      final user = _auth.currentUser;

      if (user != null && tmdbAccountId != null) {
        final userDoc = await _firestore
            .collection(_users)
            .doc(user.uid)
            .get();

        return userDoc.exists &&
            userDoc.data()?[_tmdbAccountIdField] == tmdbAccountId;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> linkAccount(String tmdbAccountId, String tmdbUsername) async {
    final userCredential = await _auth.signInWithProvider(GoogleAuthProvider());
    final user = userCredential.user;

    if (user == null) {
      throw Exception('Google authentication failed');
    }

    final existingUserDoc = await _firestore
        .collection(_users)
        .doc(user.uid)
        .get();

    if (existingUserDoc.exists) {
      final existingTmdbUsername = existingUserDoc.data()?[_tmdbUsernameField];
      if (existingTmdbUsername != tmdbUsername) {
        throw Exception(
        "Account already linked to TMDb username:$existingTmdbUsername");
      }
    }

    final userProfile = FirebaseUserProfile(
      firebaseUid: user.uid,
      tmdbAccountId: tmdbAccountId,
      email: user.email,
      tmdbUsername: tmdbUsername,
      linkedAt: DateTime.now(),
    );

    await _firestore
        .collection(_users)
        .doc(user.uid)
        .set(userProfile.toJson(), SetOptions(merge: true));
  }

  Future<void> unlinkUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user');
    }

    await _firestore
        .collection(_users)
        .doc(user.uid)
        .update({
      _tmdbAccountIdField: FieldValue.delete(),
      'linked_at': FieldValue.delete(),
    });

    await _auth.signOut();
  }
}