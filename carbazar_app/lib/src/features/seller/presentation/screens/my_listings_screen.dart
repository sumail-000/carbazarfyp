import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/seller_listing_card.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Sold'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListingsTab(_mockActiveListings, 'No active listings'),
          _buildListingsTab(_mockSoldListings, 'No sold listings'),
          _buildListingsTab(_mockDraftListings, 'No draft listings'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create listing screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create Listing - Coming in next task!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListingsTab(List<Map<String, dynamic>> listings, String emptyMessage) {
    if (listings.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return SellerListingCard(
          imageUrl: listing['imageUrl'],
          title: listing['title'],
          price: listing['price'],
          status: listing['status'],
          views: listing['views'],
          onEdit: () => _handleEdit(listing),
          onDelete: () => _handleDelete(listing),
          onTap: () => _handleTap(listing),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacing3),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing2),
          Text(
            'Tap the + button to create your first listing',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(Map<String, dynamic> listing) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit: ${listing['title']}')),
    );
    // TODO: Navigate to edit listing screen
  }

  void _handleDelete(Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: Text('Are you sure you want to delete "${listing['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted')),
              );
              // TODO: Delete listing from backend
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(Map<String, dynamic> listing) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View: ${listing['title']}')),
    );
    // TODO: Navigate to listing detail screen
  }
}

// Mock Data
final List<Map<String, dynamic>> _mockActiveListings = [
  {
    'imageUrl': '',
    'title': 'Toyota Corolla 2020',
    'price': 'PKR 45.5 Lakh',
    'status': 'Active',
    'views': 234,
  },
  {
    'imageUrl': '',
    'title': 'Honda Civic 2019',
    'price': 'PKR 52 Lakh',
    'status': 'Active',
    'views': 189,
  },
  {
    'imageUrl': '',
    'title': 'Suzuki Alto 2021',
    'price': 'PKR 18.5 Lakh',
    'status': 'Active',
    'views': 456,
  },
];

final List<Map<String, dynamic>> _mockSoldListings = [
  {
    'imageUrl': '',
    'title': 'Honda City 2018',
    'price': 'PKR 32 Lakh',
    'status': 'Sold',
    'views': 567,
  },
];

final List<Map<String, dynamic>> _mockDraftListings = [
  {
    'imageUrl': '',
    'title': 'Toyota Yaris 2022',
    'price': 'PKR 38 Lakh',
    'status': 'Draft',
    'views': 0,
  },
];
