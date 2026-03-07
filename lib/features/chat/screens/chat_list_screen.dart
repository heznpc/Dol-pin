import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Connect to chatListProvider
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Messages',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Expanded(
            child: _EmptyChatState(),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a conversation by booking a rental',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    super.key,
    required this.nickname,
    this.profileImage,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    this.onTap,
  });

  final String nickname;
  final String? profileImage;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceLight,
        backgroundImage:
            profileImage != null ? NetworkImage(profileImage!) : null,
        child: profileImage == null
            ? const Icon(Icons.person, color: AppColors.textHint)
            : null,
      ),
      title: Text(
        nickname,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unreadCount > 0
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormatter.relative(lastMessageAt),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
