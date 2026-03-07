import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/chat_message_model.dart';
import '../data/repositories/chat_repository.dart';

final chatMessagesProvider = StreamProvider.family<List<ChatMessageModel>,
    ({String userId, String otherUserId})>((ref, params) {
  return ref
      .watch(chatRepositoryProvider)
      .watchMessages(params.userId, params.otherUserId);
});

final chatListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  return ref.watch(chatRepositoryProvider).getChatList(userId);
});
