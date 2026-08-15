import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Service yang menangani seluruh proses authentication.
///
/// Tanggung jawab class ini:
/// - Login
/// - Register
/// - Logout
/// - Mendapatkan user aktif
/// - Mendapatkan session aktif
class AuthService {
  AuthService._();

  /// Client Supabase yang digunakan oleh AuthService.
  static SupabaseClient get _client {
    return SupabaseService.client;
  }

  /// User yang sedang login.
  static User? get currentUser {
    return _client.auth.currentUser;
  }

  /// Session yang sedang aktif.
  static Session? get currentSession {
    return _client.auth.currentSession;
  }

  /// Login menggunakan email dan password.
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register customer baru.
  static Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': fullName.trim()},
    );
  }

  /// Logout user.
  static Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// Stream perubahan authentication.
  ///
  /// Event yang bisa diterima antara lain:
  /// - initialSession
  /// - signedIn
  /// - signedOut
  /// - tokenRefreshed
  /// - userUpdated
  static Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}
