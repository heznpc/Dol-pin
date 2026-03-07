import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/chat_message_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(supabaseProvider));
});

class ChatRepository {
  ChatRepository(this._client);
  final SupabaseClient _client;

  Stream<List<ChatMessageModel>> watchMessages(
      String userId, String otherUserId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => data
            .where((e) =>
                (e['sender_id'] == userId &&
                    e['receiver_id'] == otherUserId) ||
                (e['sender_id'] == otherUserId &&
                    e['receiver_id'] == userId))
            .map((e) => ChatMessageModel.fromJson(e))
            .toList());
  }

  Future<ChatMessageModel> send(Map<String, dynamic> message) async {
    final data = await _client
        .from('chat_messages')
        .insert(message)
        .select()
        .single();
    return ChatMessageModel.fromJson(data);
  }

  Future<void> markAsRead(String messageId) async {
    await _client.from('chat_messages').update({
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', messageId);
  }

  Future<List<Map<String, dynamic>>> getChatList(String userId) async {
    // Get latest message per conversation partner
    final data = await _client.rpc('get_chat_list', params: {'user_id': userId});
    return List<Map<String, dynamic>>.from(data);
  }
}
