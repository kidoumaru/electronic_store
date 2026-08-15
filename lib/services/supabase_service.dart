import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service utama untuk koneksi aplikasi dengan Supabase.
///
/// Semua service lain nantinya dapat menggunakan
/// SupabaseService.client untuk mengakses database,
/// authentication, storage, dan realtime.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client {
    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final publishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      throw StateError('SUPABASE_URL belum dikonfigurasi pada file .env');
    }

    if (publishableKey == null || publishableKey.isEmpty) {
      throw StateError(
        'SUPABASE_PUBLISHABLE_KEY belum dikonfigurasi pada file .env',
      );
    }

    await Supabase.initialize(url: supabaseUrl, publishableKey: publishableKey);
  }
}
