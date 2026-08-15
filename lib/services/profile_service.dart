import '../models/profile.dart';
import 'supabase_service.dart';

class ProfileService {
  ProfileService._();

  static Future<Profile?> getCurrentProfile() async {
    final user = SupabaseService.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromMap(response);
  }
}
