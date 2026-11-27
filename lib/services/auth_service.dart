import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = String.fromEnvironment(
    'WONDERSPACE_API_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    String? contactNumber,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              if (contactNumber != null) 'contact_number': contactNumber,
              'confirm_password': confirmPassword,
              'accepted_terms': acceptedTerms,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) return null;

      final payload = jsonDecode(response.body);
      if (payload is Map<String, dynamic> && payload['message'] is String) {
        return payload['message'] as String;
      }
    } on http.ClientException {
      return 'Could not reach the registration server. Check that it is running.';
    } on TimeoutException {
      return 'The registration server took too long to respond.';
    } on FormatException {
      return 'The registration server returned an unexpected response.';
    }
    return 'Could not create your account. Please try again.';
  }
}
