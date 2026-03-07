import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/dialogs/confirm_dialog.dart';
import '../../../data/repositories/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'Preferences',
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Currency'),
                subtitle: const Text('KRW'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context),
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Region'),
                subtitle: const Text('Korea'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Push Notifications'),
                value: true,
                onChanged: (v) {},
              ),
              SwitchListTile(
                secondary: const Icon(Icons.chat_outlined),
                title: const Text('Chat Notifications'),
                value: true,
                onChanged: (v) {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Export My Data'),
                subtitle: const Text('Download as JSON'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete_forever, color: AppColors.error),
                title: Text('Delete Account',
                    style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  final confirmed = await ConfirmDialog.show(
                    context,
                    title: 'Delete Account',
                    message:
                        'This will permanently delete your account and all data. This cannot be undone.',
                    confirmLabel: 'Delete',
                    isDestructive: true,
                  );
                  if (confirmed && context.mounted) {
                    final user = ref
                        .read(authRepositoryProvider)
                        .currentUser;
                    if (user != null) {
                      await ref
                          .read(authRepositoryProvider)
                          .softDelete(user.id);
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'dol-pin v0.1.0',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (code, name) in [
              ('ko', 'Korean'),
              ('en', 'English'),
              ('id', 'Indonesian'),
              ('ja', 'Japanese'),
            ])
              ListTile(
                title: Text(name),
                trailing: code == 'en'
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (code, name) in [
              ('KRW', 'Korean Won (\u20A9)'),
              ('IDR', 'Indonesian Rupiah (Rp)'),
              ('JPY', 'Japanese Yen (\u00A5)'),
              ('USD', 'US Dollar (\$)'),
            ])
              ListTile(
                title: Text(name),
                trailing: code == 'KRW'
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
        const Divider(color: AppColors.divider),
      ],
    );
  }
}
