import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    final user = authState.asData?.value.user;

    final username = user?['username']?.toString() ?? 'username';
    final email = user?['email']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 42,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  username,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'PROFILE',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          _ProfileTile(
            icon: Icons.person_outline_rounded,
            title: 'Edit profile',
            subtitle: 'Update your developer information',
            onTap: () {
              // Profile editor will be added next.
            },
          ),

          const SizedBox(height: 24),

          Text(
            'APPEARANCE',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          _ProfileTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'System default',
            onTap: () {
              _showThemeSelector(context);
            },
          ),

          const SizedBox(height: 24),

          Text(
            'ACCOUNT',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          _ProfileTile(
            icon: Icons.logout_rounded,
            title: 'Sign out',
            subtitle: 'Sign out from this device',
            danger: true,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();

              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Choose theme',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto_outlined),
                title: const Text('System'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_outlined),
                title: const Text('Light'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = danger
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Icon(
        icon,
        color: danger
            ? theme.colorScheme.error
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
