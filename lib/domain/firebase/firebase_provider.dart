import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_movie_app/domain/entity/firebase_entity/user_profile/firebase_user_profile.dart';

class FirebaseProvider {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseFirestore get firestore => _firestore;

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(User user) {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .get();
  }

  static Future<void> setUser(User user, FirebaseUserProfile firebaseUserProfile) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(firebaseUserProfile.toJson(), SetOptions(merge: true));
  }

  static Future<void> updateUser(User user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'tmdb_account_id': FieldValue.delete(),
      'linked_at': FieldValue.delete(),
    });
  }
}