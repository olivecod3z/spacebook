import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _client.functions.invoke(
        'check-email',
        body: {'email': email},
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3cGZjdGV3Z3Zoc2phem12d2JuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzOTQwMzQsImV4cCI6MjA4OTk3MDAzNH0.d_c1FqVGtPBrc49gs8AsnUIyVXm2-G3dBRWF3jt8_Gc',
        },
      );
      if (response.data == null) return false;
      return response.data['exists'] as bool;
    } catch (e) {
      debugPrint('checkEmailExists error: $e');
      return false;
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final emailExists = await checkEmailExists(email);
    if (emailExists) {
      throw Exception('This email is already registered.');
    }

    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      );
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('user already exists')) {
        throw Exception('This email is already registered.');
      }
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
