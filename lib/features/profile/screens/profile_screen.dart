import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/lender_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return SafeArea(
      child: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.surfaceLight,
                backgroundImage: user?.profileImage != null
                    ? NetworkImage(user!.profileImage!)
                    : null,
                child: user?.profileImage == null
                    ? const Icon(Icons.person, size: 48, color: AppColors.textHint)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                user?.nickname ?? 'Guest',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              LenderBadge(grade: user?.lenderGrade ?? 'newbie'),
              if (user?.favGroups.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: user!.favGroups.map((g) {
                    return Chip(
                      label: Text(g, style: const TextStyle(fontSize: 12)),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 32),
              _ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                label: 'My Rentals',
                onTap: () => context.pushNamed('myRentals'),
              ),
              _ProfileMenuItem(
                icon: Icons.star_outline,
                label: 'Reviews',
                onTap: () {},
              ),
              const Divider(color: AppColors.divider, height: 32),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => context.pushNamed('settings'),
              ),
              _ProfileMenuItem(
                icon: Icons.help_outline,
                label: 'Help & Support',
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.policy_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              const Divider(color: AppColors.divider, height: 32),
              _ProfileMenuItem(
                icon: Icons.logout,
                label: 'Log Out',
                isDestructive: true,
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
        loading: () => const LoadingIndicator(),
        error: (_, _) => const Center(child: Text('Error loading profile')),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: isDestructive
          ? null
          : const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
