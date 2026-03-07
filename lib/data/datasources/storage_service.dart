import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(supabaseProvider));
});

class StorageService {
  StorageService(this._client);
  final SupabaseClient _client;

  Future<String> uploadItemPhoto(String userId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'items/$userId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from('rental-photos').upload(path, file);
    return _client.storage.from('rental-photos').getPublicUrl(path);
  }

  Future<String> uploadProfilePhoto(String userId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'profiles/$userId.$ext';
    await _client.storage.from('profile-photos').upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return _client.storage.from('profile-photos').getPublicUrl(path);
  }

  Future<String> uploadChatImage(String chatId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'chat/$chatId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from('chat-images').upload(path, file);
    return _client.storage.from('chat-images').getPublicUrl(path);
  }
}
