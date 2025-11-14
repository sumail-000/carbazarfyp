import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../common/models/vehicle_listing.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final String listingId;

  const ListingDetailScreen({
    super.key,
    required this.listingId,
  });

  @override
  ConsumerState<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFavorite = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Fetch actual listing from provider
    final listing = _getMockListing();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Gallery
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _handleShare,
              ),
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? AppColors.error : null,
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Gallery
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: listing.images.isEmpty ? 1 : listing.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = listing.images.isEmpty 
                          ? listing.coverImage 
                          : listing.images[index];
                      return GestureDetector(
                        onTap: () => _showImageGallery(context, listing),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceVariant,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Live Auction Badge
                  if (listing.isAuction)
                    Positioned(
                      top: 60,
                      left: AppTheme.spacing3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing3,
                          vertical: AppTheme.spacing2,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.auctionGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.gavel, color: Colors.white, size: 18),
                            const SizedBox(width: AppTheme.spacing1),
                            Text(
                              'LIVE AUCTION',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Page Indicator
                  if (listing.images.length > 1)
                    Positioned(
                      bottom: AppTheme.spacing3,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          listing.images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price Section
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        listing.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing2),
                      
                      // Location and Year
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.city,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (listing.year != null) ...[
                            const SizedBox(width: AppTheme.spacing3),
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              listing.year.toString(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      
                      // Price
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing3),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listing.isAuction ? 'Current Bid' : 'Price',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatPrice(listing.currentPrice),
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (listing.isAuction && listing.bidCount != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing3,
                                  vertical: AppTheme.spacing2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${listing.bidCount}',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Bids',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Specifications Section
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Specifications',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing3),
                      _buildSpecsGrid(listing),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Description Section
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing3),
                      Text(
                        listing.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Seller Information
                _buildSellerSection(listing, theme),

                const SizedBox(height: AppTheme.spacing6),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(listing, theme),
    );
  }

  Widget _buildSpecsGrid(VehicleListing listing) {
    final specs = [
      if (listing.brand != null)
        _SpecItem(icon: Icons.directions_car, label: 'Brand', value: listing.brand!),
      if (listing.model != null)
        _SpecItem(icon: Icons.car_rental, label: 'Model', value: listing.model!),
      if (listing.year != null)
        _SpecItem(icon: Icons.calendar_today, label: 'Year', value: listing.year.toString()),
      if (listing.bodyType != null)
        _SpecItem(icon: Icons.airport_shuttle, label: 'Body Type', value: listing.bodyType!),
      if (listing.transmission != null)
        _SpecItem(icon: Icons.settings, label: 'Transmission', value: listing.transmission!),
      if (listing.fuelType != null)
        _SpecItem(icon: Icons.local_gas_station, label: 'Fuel Type', value: listing.fuelType!),
      if (listing.mileage != null)
        _SpecItem(icon: Icons.speed, label: 'Mileage', value: '${listing.mileage} km'),
      _SpecItem(
        icon: listing.isVerified ? Icons.verified : Icons.info,
        label: 'Status',
        value: listing.isVerified ? 'Verified' : 'Pending',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8, // Increased from 2.5 to give more vertical space
        crossAxisSpacing: AppTheme.spacing2,
        mainAxisSpacing: AppTheme.spacing2,
      ),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final spec = specs[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing2,
            vertical: AppTheme.spacing2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(spec.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppTheme.spacing1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      spec.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      spec.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSellerSection(VehicleListing listing, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing3),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    listing.sellerName[0].toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              listing.sellerName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (listing.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.verified,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Professional Dealer',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacing2),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to seller profile
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing2,
                      vertical: AppTheme.spacing1,
                    ),
                    minimumSize: const Size(60, 36),
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(VehicleListing listing, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing3),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Call Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleCall('03001234567'),
                icon: const Icon(Icons.phone),
                label: const Text('Call'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacing2),
            
            // Chat Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _handleChat,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacing2),
            
            // Main Action Button
            Expanded(
              flex: 2,
              child: CustomButton(
                text: listing.isAuction ? 'Place Bid' : 'Buy Now',
                onPressed: _handleMainAction,
                icon: listing.isAuction ? Icons.gavel : Icons.shopping_cart,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageGallery(BuildContext context, VehicleListing listing) {
    // TODO: Implement full screen image gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Full screen gallery coming soon')),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _handleCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _handleChat() {
    // TODO: Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat feature coming soon')),
    );
  }

  void _handleMainAction() {
    final listing = _getMockListing();
    if (listing.isAuction) {
      // Navigate to auction room
      context.push('/auction/${listing.id}');
    } else {
      // Handle buy now
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text('Purchase flow coming soon'),
            ],
          ),
        ),
      );
    }
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return 'PKR ${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return 'PKR ${(price / 100000).toStringAsFixed(2)} Lac';
    }
    return 'PKR ${price.toStringAsFixed(0)}';
  }

  VehicleListing _getMockListing() {
    return VehicleListing(
      id: widget.listingId,
      title: 'Toyota Corolla GLI 2020',
      description: 'Well maintained Toyota Corolla in excellent condition. '
          'Single owner, complete service history available. '
          'Features automatic transmission, power windows, and ABS brakes. '
          'Perfect for family use with low fuel consumption.',
      currentPrice: 4500000,
      basePrice: 4000000,
      coverImage: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&h=450&fit=crop',
      images: [
        'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&h=450&fit=crop',
        'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=800&h=450&fit=crop',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&h=450&fit=crop',
      ],
      city: 'Lahore',
      sellerId: 'seller1',
      sellerName: 'Ahmad Motors',
      isVerified: true,
      isAuction: true,
      year: 2020,
      brand: 'Toyota',
      model: 'Corolla GLI',
      bodyType: 'Sedan',
      mileage: 45000,
      transmission: 'Automatic',
      fuelType: 'Petrol',
      createdAt: DateTime.now(),
      auctionEndTime: DateTime.now().add(const Duration(hours: 2)),
      bidCount: 15,
    );
  }
}

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;

  _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
