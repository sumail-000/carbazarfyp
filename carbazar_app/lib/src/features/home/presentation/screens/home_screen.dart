import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/vehicle_card.dart';
import '../../../../common/models/vehicle_listing.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String? _selectedBrand;
  String? _selectedCity;
  double? _maxPrice;
  String? _selectedCondition; // New/Used
  
  // Auto-slider for hero background
  PageController? _pageController;
  AnimationController? _animationController;
  int _currentPage = 0;
  
  final List<String> _heroImages = [
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200&q=80', // Luxury sports car
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=1200&q=80', // Modern sedan
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=1200&q=80', // Classic car
    'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=1200&q=80', // Vintage collection
    'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?w=1200&q=80', // SUV lineup
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Auto-slide every 4 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), _autoSlide);
    });
  }
  
  void _autoSlide() {
    if (!mounted || _pageController == null) return;
    
    final nextPage = (_currentPage + 1) % _heroImages.length;
    _pageController!.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ).then((_) {
      if (mounted) {
        setState(() => _currentPage = nextPage);
        Future.delayed(const Duration(seconds: 4), _autoSlide);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            title: Row(
              children: [
                Icon(Icons.car_rental_rounded, color: AppColors.primary),
                const SizedBox(width: AppTheme.spacing2),
                const Text('CARBAZAR'),
              ],
            ),
          ),

          // Hero Section with Auto-Slider & Glassmorphism
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing3,
                vertical: AppTheme.spacing2,
              ),
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                child: Stack(
                  children: [
                    // Auto-sliding background images (swipe disabled)
                    PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(), // Disable swipe
                      itemCount: _heroImages.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          _heroImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    ),
                    
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    
                    // Content - Clean without blur effect on text
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title - Clean text with strong shadow
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find Your Dream Car',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.6),
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 4),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Browse verified listings or join live auctions',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(0, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacing3),
                          
                          // Search bar - Solid white background
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleSearch,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing3,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: AppColors.textSecondary,
                                        size: 22,
                                      ),
                                      const SizedBox(width: AppTheme.spacing2),
                                      Expanded(
                                        child: Text(
                                          'Search Vehicles',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Page indicators
                    Positioned(
                      bottom: AppTheme.spacing2,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _heroImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
              child: Row(
                children: [
                  FilterChip(
                    label: Text(_selectedBrand ?? 'Brand'),
                    selected: _selectedBrand != null,
                    onSelected: (_) => _selectBrand(),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  FilterChip(
                    label: Text(_selectedCity ?? 'City'),
                    selected: _selectedCity != null,
                    onSelected: (_) => _selectCity(),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  FilterChip(
                    label: Text(_maxPrice != null
                        ? 'Under ${_formatPrice(_maxPrice!)}'
                        : 'Price'),
                    selected: _maxPrice != null,
                    onSelected: (_) => _selectPrice(),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  FilterChip(
                    label: Text(_selectedCondition ?? 'Condition'),
                    selected: _selectedCondition != null,
                    onSelected: (_) => _selectCondition(),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  if (_selectedBrand != null ||
                      _selectedCity != null ||
                      _maxPrice != null ||
                      _selectedCondition != null)
                    ActionChip(
                      label: const Text('Clear All'),
                      onPressed: _clearFilters,
                      avatar: const Icon(Icons.close, size: 16),
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing3)),

          // Featured Auctions Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Auctions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToAuctions,
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Featured Auctions List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
                itemCount: _getMockAuctions().length,
                itemBuilder: (context, index) {
                  final listing = _getMockAuctions()[index];
                  return SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacing3),
                      child: VehicleCard(
                        listing: listing,
                        onTap: () => _viewListingDetail(listing),
                        onFavorite: () => _toggleFavorite(listing),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing4)),

          // All Listings Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
              child: Text(
                'All Listings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing3)),

          // All Listings Grid
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
                  final listing = _getMockListings()[index];
                  return VehicleCard(
                    listing: listing,
                    onTap: () => _viewListingDetail(listing),
                    onFavorite: () => _toggleFavorite(listing),
                  );
                },
                childCount: _getMockListings().length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing4)),
        ],
      ),
    );
  }

  void _handleSearch() {
    // TODO: Implement search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon')),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            const Text('Filter options coming soon...'),
            const SizedBox(height: AppTheme.spacing4),
          ],
        ),
      ),
    );
  }

  void _selectBrand() {
    // TODO: Show brand selection dialog
  }

  void _selectCity() {
    // TODO: Show city selection dialog
  }

  void _selectPrice() {
    // TODO: Show price selection dialog
  }

  void _selectCondition() {
    // TODO: Show condition selection dialog (New/Used)
  }

  void _clearFilters() {
    setState(() {
      _selectedBrand = null;
      _selectedCity = null;
      _maxPrice = null;
      _selectedCondition = null;
    });
  }

  void _viewListingDetail(VehicleListing listing) {
    context.push('/listing/${listing.id}');
  }

  void _toggleFavorite(VehicleListing listing) {
    // TODO: Toggle favorite status
  }

  void _navigateToAuctions() {
    // Switch to auctions tab (index 1)
    ref.read(currentIndexProvider.notifier).state = 1;
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(1)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(0)} Lac';
    }
    return price.toStringAsFixed(0);
  }

  // Mock Data
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
        createdAt: DateTime.now(),
        auctionEndTime: DateTime.now().add(const Duration(hours: 2)),
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
        createdAt: DateTime.now(),
        auctionEndTime: DateTime.now().add(const Duration(minutes: 45)),
        bidCount: 23,
      ),
    ];
  }

  List<VehicleListing> _getMockListings() {
    return [
      VehicleListing(
        id: '3',
        title: 'Suzuki Alto VXR 2019',
        description: 'Perfect for city driving',
        currentPrice: 1850000,
        coverImage: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&h=450&fit=crop',
        images: [],
        city: 'Islamabad',
        sellerId: 'seller3',
        sellerName: 'City Motors',
        isVerified: true,
        isAuction: false,
        year: 2019,
        brand: 'Suzuki',
        model: 'Alto',
        createdAt: DateTime.now(),
      ),
      VehicleListing(
        id: '4',
        title: 'KIA Sportage 2022',
        description: 'Top of the line SUV',
        currentPrice: 8500000,
        coverImage: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800&h=450&fit=crop',
        images: [],
        city: 'Lahore',
        sellerId: 'seller4',
        sellerName: 'Elite Cars',
        isVerified: true,
        isAuction: false,
        year: 2022,
        brand: 'KIA',
        model: 'Sportage',
        createdAt: DateTime.now(),
      ),
    ];
  }
}

