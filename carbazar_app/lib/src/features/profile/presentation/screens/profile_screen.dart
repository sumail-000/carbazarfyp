import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RouteConstants.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing3),
                  Text(
                    'User Name',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing1),
                  Text(
                    'user@email.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing2),
                  Chip(
                    label: const Text('Verified'),
                    avatar: const Icon(Icons.verified, size: 16),
                    backgroundColor: AppColors.verified.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColors.verified),
                  ),
                  const SizedBox(height: AppTheme.spacing3),
                  OutlinedButton(
                    onPressed: () => context.push(RouteConstants.editProfile),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing3),

          // Menu Items
          _buildMenuItem(
            context,
            icon: Icons.list_alt,
            title: 'My Listings',
            subtitle: 'View your posted vehicles',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.gavel,
            title: 'My Bids',
            subtitle: 'Track your auction bids',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and info',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () => _handleLogout(context),
            textColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing2),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? AppColors.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: textColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteConstants.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

