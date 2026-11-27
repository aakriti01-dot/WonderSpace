import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
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
    if (password != confirmPassword) return 'Passwords do not match.';
    if (!acceptedTerms) return 'Accept the terms to create an account.';

    final passwordLength = password.runes.length;
    if (passwordLength < 8 || passwordLength > 128) {
      return 'Use 8 to 128 characters for your password.';
    }

    late final UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return switch (error.code) {
        'email-already-in-use' => 'An account already exists. Please log in.',
        'invalid-email' => 'Enter a valid email address.',
        'weak-password' => 'Choose a stronger password.',
        'operation-not-allowed' =>
          'Email registration is currently unavailable.',
        'network-request-failed' => 'Check your connection and try again.',
        'too-many-requests' =>
          'Too many attempts. Wait a moment and try again.',
        _ => 'Could not create your account. Please try again.',
      };
    }

    final user = credential.user;
    if (user == null) {
      return 'Could not confirm your new account. Try logging in.';
    }

    try {
      await user.updateDisplayName(fullName);
    } on FirebaseAuthException {
      return 'Your account was created, but your name could not be saved. You can log in.';
    }

    return null;
  }
}
