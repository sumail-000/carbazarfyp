import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../common/providers/user_provider.dart';
import '../../../../common/models/user_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userRole = ref.watch(userRoleProvider);
    final isSeller = userRole == UserRole.seller;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSeller ? 'Seller Dashboard' : 'CARBAZAR'),
        actions: [
          // Role Switcher
          if (userRole != null)
            PopupMenuButton<UserRole>(
              icon: Icon(
                isSeller ? Icons.store : Icons.shopping_bag,
                color: AppColors.primary,
              ),
              onSelected: (role) {
                ref.read(userRoleProvider.notifier).state = role;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Switched to ${role == UserRole.seller ? 'Seller' : 'Buyer'} mode'),
                  ),
                );
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: UserRole.buyer,
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text('Buyer Mode'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: UserRole.seller,
                  child: Row(
                    children: [
                      Icon(Icons.store, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text('Seller Mode'),
                    ],
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        ],
      ),
      body: isSeller ? _buildSellerDashboard(context) : _buildBuyerHome(context),
    );
  }

  // SELLER DASHBOARD
  Widget _buildSellerDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Dashboard',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          
          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('5', 'Listings', Icons.inventory_2, AppColors.primary)),
              const SizedBox(width: AppTheme.spacing3),
              Expanded(child: _buildStatCard('1,446', 'Views', Icons.visibility, AppColors.success)),
            ],
          ),
          const SizedBox(height: AppTheme.spacing3),
          Row(
            children: [
              Expanded(child: _buildStatCard('12', 'Messages', Icons.message, AppColors.accent)),
              const SizedBox(width: AppTheme.spacing3),
              Expanded(child: _buildStatCard('0', 'Auctions', Icons.gavel, AppColors.warning)),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing5),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing3),
          
          _buildActionCard(
            context,
            'My Listings',
            'Manage your vehicle listings',
            Icons.inventory_2,
            AppColors.primary,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('My Listings - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'Create Listing',
            'List a new vehicle for sale',
            Icons.add_circle,
            AppColors.success,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Listing - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'Analytics',
            'View performance insights',
            Icons.analytics,
            AppColors.accent,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Analytics - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'Manage Inquiries',
            'Respond to buyer messages',
            Icons.question_answer,
            AppColors.warning,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inquiries - Coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  // BUYER HOME
  Widget _buildBuyerHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Dream Car',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          
          // Browse Categories
          Text(
            'Browse by Category',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing3),
          
          _buildActionCard(
            context,
            'All Vehicles',
            'Browse all available cars',
            Icons.directions_car,
            AppColors.primary,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Browse Vehicles - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'Live Auctions',
            'Bid on vehicles in real-time',
            Icons.gavel,
            AppColors.error,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auctions - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'My Wishlist',
            'View your saved vehicles',
            Icons.favorite,
            AppColors.accent,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wishlist - Coming soon!')),
              );
            },
          ),
          _buildActionCard(
            context,
            'Become a Seller',
            'Start selling your vehicles',
            Icons.store,
            AppColors.success,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seller Upgrade - Coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
