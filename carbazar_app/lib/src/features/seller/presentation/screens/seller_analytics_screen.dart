import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';

class SellerAnalyticsScreen extends ConsumerWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Listings', '5', Icons.inventory_2, AppColors.primary)),
                const SizedBox(width: AppTheme.spacing3),
                Expanded(child: _buildStatCard('Total Views', '1,446', Icons.visibility, AppColors.success)),
              ],
            ),
            const SizedBox(height: AppTheme.spacing3),
            Row(
              children: [
                Expanded(child: _buildStatCard('Active Auctions', '0', Icons.gavel, AppColors.warning)),
                const SizedBox(width: AppTheme.spacing3),
                Expanded(child: _buildStatCard('Messages', '12', Icons.message, AppColors.accent)),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Views Chart Placeholder
            Text(
              'Views Over Time',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing3),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart, size: 48, color: AppColors.textTertiary),
                    const SizedBox(height: 8),
                    Text(
                      'Chart coming soon!',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Top Performing Listings
            Text(
              'Top Performing Listings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing3),
            
            ..._mockTopListings.map((listing) => Card(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing2),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(Icons.directions_car, color: AppColors.textTertiary),
                ),
                title: Text(listing['title']),
                subtitle: Text('${listing['views']} views'),
                trailing: Icon(Icons.trending_up, color: AppColors.success),
              ),
            )),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Recent Activity
            Text(
              'Recent Activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing3),
            
            ..._mockRecentActivity.map((activity) => Card(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing2),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: activity['color'].withOpacity(0.1),
                  child: Icon(activity['icon'], color: activity['color'], size: 20),
                ),
                title: Text(activity['title']),
                subtitle: Text(activity['time']),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
}

final List<Map<String, dynamic>> _mockTopListings = [
  {'title': 'Suzuki Alto 2021', 'views': 456},
  {'title': 'Toyota Corolla 2020', 'views': 234},
  {'title': 'Honda Civic 2019', 'views': 189},
];

final List<Map<String, dynamic>> _mockRecentActivity = [
  {
    'icon': Icons.visibility,
    'color': AppColors.primary,
    'title': 'New view on Toyota Corolla 2020',
    'time': '2 hours ago',
  },
  {
    'icon': Icons.message,
    'color': AppColors.accent,
    'title': 'New message about Honda Civic',
    'time': '5 hours ago',
  },
  {
    'icon': Icons.favorite,
    'color': AppColors.error,
    'title': 'Someone saved your Suzuki Alto',
    'time': '1 day ago',
  },
];
