import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../../core/constants/database.dart';

// NOTE: firebase_core and firebase_messaging need to be added via FlutterFire CLI.
// Run `flutterfire configure` to generate firebase_options.dart and register
// platform-specific settings. Then add the following to pubspec.yaml:
//   firebase_core: ^3.x.x
//   firebase_messaging: ^15.x.x
// Actual Firebase initialization and message handling requires those packages
// and platform-specific setup (GoogleService-Info.plist / google-services.json).

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref.watch(supabaseProvider));
});

class PushNotificationService {
  PushNotificationService(this._client);
  final SupabaseClient _client;

  /// Stores FCM token in user's profile for server-side push.
  Future<void> registerToken(String userId, String fcmToken) async {
    await _client.from(DbTables.users).update({
      'fcm_token': fcmToken,
    }).eq('id', userId);
  }

  /// Removes FCM token on sign out.
  Future<void> unregisterToken(String userId) async {
    await _client.from(DbTables.users).update({
      'fcm_token': null,
    }).eq('id', userId);
  }
}
