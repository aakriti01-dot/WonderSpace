
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required User user,
    required String fullName,
  }) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': user.email,
      'profileImage': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'provider': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown',
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
  getUserProfile(String uid) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }
}
