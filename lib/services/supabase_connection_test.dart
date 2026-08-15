import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnectionTest {
  SupabaseConnectionTest._();

  static Future<void> run() async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name')
          .limit(5);

      print('====================================');
      print('SUPABASE CONNECTION SUCCESS');
      print('Categories: $response');
      print('====================================');
    } catch (error) {
      print('====================================');
      print('SUPABASE CONNECTION FAILED');
      print(error);
      print('====================================');
    }
  }
}
