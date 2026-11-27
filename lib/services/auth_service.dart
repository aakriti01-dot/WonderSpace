
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    String? contactNumber,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    final fullName = name.trim();
    final emailAddress = email.trim();

    if (fullName.isEmpty) return 'Enter your full name.';
    if (emailAddress.isEmpty) return 'Enter your email address.';
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    if (!acceptedTerms) {
      return 'Accept the terms to create an account.';
    }

    final passwordLength = password.runes.length;
    if (passwordLength < 8 || passwordLength > 128) {
      return 'Use 8 to 128 characters for your password.';
    }

    late final UserCredential credential;

    try {
      credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint('AUTH ERROR: ${error.code}');

      return switch (error.code) {
        'email-already-in-use' =>
          'An account already exists. Please log in.',
        'invalid-email' => 'Enter a valid email address.',
        'weak-password' => 'Choose a stronger password.',
        'operation-not-allowed' =>
          'Email registration is currently unavailable.',
        'network-request-failed' =>
          'Check your connection and try again.',
        'too-many-requests' =>
          'Too many attempts. Wait a moment and try again.',
        _ => 'Could not create your account. Please try again.',
      };
    }

    final user = credential.user;

    if (user == null) {
      debugPrint('AUTH ERROR: User credential is null.');
      return 'Could not confirm your new account. Try logging in.';
    }

    try {
      await user.updateDisplayName(fullName);
      debugPrint('AUTH: Display name updated for ${user.uid}');
    } on FirebaseAuthException catch (error) {
      debugPrint('DISPLAY NAME ERROR: ${error.code}');
      return 'Your account was created, but your name could not be saved. You can log in.';
    }

    try {
      debugPrint('FIRESTORE: Starting profile save...');
      debugPrint('FIRESTORE: Project: ${Firebase.app().options.projectId}');
      debugPrint('FIRESTORE: User UID: ${user.uid}');

      await _userService.createUserProfile(
        user: user,
        fullName: fullName,
      );

      debugPrint('FIRESTORE: Profile save completed successfully.');

    } on FirebaseException catch (error) {
      debugPrint('FIRESTORE ERROR: ${error.code}');
      debugPrint('FIRESTORE ERROR MESSAGE: ${error.message}');

      return 'Your account was created, but your profile could not be saved. You can log in.';
    } catch (error) {
      debugPrint('PROFILE SAVE ERROR: $error');

      return 'Your account was created, but your profile could not be saved. You can log in.';
    }

    return null;
  }

  // Logout the current user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}