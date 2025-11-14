import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/vehicle_card.dart';
import '../../../../common/models/vehicle_listing.dart';

class AuctionsScreen extends ConsumerStatefulWidget {
  const AuctionsScreen({super.key});

  @override
  ConsumerState<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends ConsumerState<AuctionsScreen> {
  String _selectedFilter = 'all'; // all, ending_soon, new

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auctions = _getFilteredAuctions();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Live Auctions'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing3,
                  vertical: AppTheme.spacing2,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    const SizedBox(width: AppTheme.spacing2),
                    _buildFilterChip('Ending Soon', 'ending_soon'),
                    const SizedBox(width: AppTheme.spacing2),
                    _buildFilterChip('New', 'new'),
                  ],
                ),
              ),
            ),
          ),

          // Stats Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppTheme.spacing3),
              padding: const EdgeInsets.all(AppTheme.spacing3),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.gavel,
                    '${auctions.length}',
                    'Live Auctions',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildStatItem(
                    Icons.people,
                    '${_getTotalBidders()}',
                    'Active Bidders',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildStatItem(
                    Icons.timer,
                    '${_getEndingSoonCount()}',
                    'Ending Soon',
                  ),
                ],
              ),
            ),
          ),

          // Auctions Grid
          if (auctions.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gavel_outlined,
                      size: 80,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppTheme.spacing3),
                    Text(
                      'No auctions found',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing2),
                    Text(
                      'Try changing your filter',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: AppTheme.spacing3,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final auction = auctions[index];
                    return VehicleCard(
                      listing: auction,
                      onTap: () => _viewAuctionDetail(auction),
                      onFavorite: () => _toggleFavorite(auction),
                    );
                  },
                  childCount: auctions.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacing4),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: FilterChip(
        label: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedFilter = value);
        },
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<VehicleListing> _getFilteredAuctions() {
    final allAuctions = _getMockAuctions();
    
    switch (_selectedFilter) {
      case 'ending_soon':
        return allAuctions
            .where((a) =>
                a.auctionEndTime != null &&
                a.auctionEndTime!.difference(DateTime.now()).inHours < 1)
            .toList();
      case 'new':
        return allAuctions
            .where((a) =>
                a.createdAt.difference(DateTime.now()).abs().inHours < 24)
            .toList();
      default:
        return allAuctions;
    }
  }

  int _getTotalBidders() {
    return _getMockAuctions().fold(0, (sum, auction) => sum + (auction.bidCount ?? 0));
  }

  int _getEndingSoonCount() {
    return _getMockAuctions()
        .where((a) =>
            a.auctionEndTime != null &&
            a.auctionEndTime!.difference(DateTime.now()).inHours < 1)
        .length;
  }

  void _viewAuctionDetail(VehicleListing auction) {
    context.push('/auction/${auction.id}');
  }

  void _toggleFavorite(VehicleListing auction) {
    // TODO: Toggle favorite
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.white),
            SizedBox(width: 8),
            Text('Added to wishlist'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<VehicleListing> _getMockAuctions() {
    return [
      VehicleListing(
        id: '1',
        title: 'Toyota Corolla GLI 2020',
        description: 'Well maintained, single owner',
        currentPrice: 4500000,
        basePrice: 4000000,
        coverImage: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&h=450&fit=crop',
        images: [],
        city: 'Lahore',
        sellerId: 'seller1',
        sellerName: 'Ahmad Motors',
        isVerified: true,
        isAuction: true,
        year: 2020,
        brand: 'Toyota',
        model: 'Corolla',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        auctionEndTime: DateTime.now().add(const Duration(minutes: 45)),
        bidCount: 15,
      ),
      VehicleListing(
        id: '2',
        title: 'Honda Civic Turbo 2021',
        description: 'Low mileage, excellent condition',
        currentPrice: 6200000,
        basePrice: 5500000,
        coverImage: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=800&h=450&fit=crop',
        images: [],
        city: 'Karachi',
        sellerId: 'seller2',
        sellerName: 'Premium Cars',
        isVerified: true,
        isAuction: true,
        year: 2021,
        brand: 'Honda',
        model: 'Civic',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        auctionEndTime: DateTime.now().add(const Duration(hours: 3)),
        bidCount: 23,
      ),
      VehicleListing(
        id: '3',
        title: 'BMW 3 Series 2019',
        description: 'Luxury sedan in pristine condition',
        currentPrice: 8500000,
        basePrice: 7500000,
        coverImage: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&h=450&fit=crop',
        images: [],
        city: 'Islamabad',
        sellerId: 'seller3',
        sellerName: 'Elite Motors',
        isVerified: true,
        isAuction: true,
        year: 2019,
        brand: 'BMW',
        model: '3 Series',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        auctionEndTime: DateTime.now().add(const Duration(hours: 2)),
        bidCount: 31,
      ),
      VehicleListing(
        id: '4',
        title: 'Suzuki Swift 2022',
        description: 'Brand new condition, low mileage',
        currentPrice: 3200000,
        basePrice: 2800000,
        coverImage: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&h=450&fit=crop',
        images: [],
        city: 'Lahore',
        sellerId: 'seller4',
        sellerName: 'City Cars',
        isVerified: true,
        isAuction: true,
        year: 2022,
        brand: 'Suzuki',
        model: 'Swift',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        auctionEndTime: DateTime.now().add(const Duration(hours: 6)),
        bidCount: 8,
      ),
      VehicleListing(
        id: '5',
        title: 'Mercedes E-Class 2020',
        description: 'Executive luxury with full options',
        currentPrice: 15000000,
        basePrice: 13000000,
        coverImage: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800&h=450&fit=crop',
        images: [],
        city: 'Karachi',
        sellerId: 'seller5',
        sellerName: 'Prestige Autos',
        isVerified: true,
        isAuction: true,
        year: 2020,
        brand: 'Mercedes',
        model: 'E-Class',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        auctionEndTime: DateTime.now().add(const Duration(minutes: 30)),
        bidCount: 42,
      ),
      VehicleListing(
        id: '6',
        title: 'Audi A4 2021',
        description: 'Modern design with advanced features',
        currentPrice: 11500000,
        basePrice: 10000000,
        coverImage: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800&h=450&fit=crop',
        images: [],
        city: 'Islamabad',
        sellerId: 'seller6',
        sellerName: 'Luxury Cars',
        isVerified: true,
        isAuction: true,
        year: 2021,
        brand: 'Audi',
        model: 'A4',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        auctionEndTime: DateTime.now().add(const Duration(hours: 4)),
        bidCount: 19,
      ),
    ];
  }
}

