import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../common/models/auction_model.dart';

class AuctionRoomScreen extends ConsumerStatefulWidget {
  final String auctionId;

  const AuctionRoomScreen({
    super.key,
    required this.auctionId,
  });

  @override
  ConsumerState<AuctionRoomScreen> createState() => _AuctionRoomScreenState();
}

class _AuctionRoomScreenState extends ConsumerState<AuctionRoomScreen>
    with TickerProviderStateMixin {
  final TextEditingController _bidController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _countdownTimer;
  Duration _timeRemaining = const Duration();
  bool _isPlacingBid = false;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    
    // Pulse animation for live indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _bidController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    final auction = _getMockAuction();
    _timeRemaining = auction.endTime.difference(DateTime.now());
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeRemaining = auction.endTime.difference(DateTime.now());
          if (_timeRemaining.isNegative) {
            _countdownTimer?.cancel();
            _timeRemaining = Duration.zero;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auction = _getMockAuction();
    final isEndingSoon = _timeRemaining.inMinutes < 5 && !_timeRemaining.isNegative;
    final hasEnded = _timeRemaining.isNegative || _timeRemaining == Duration.zero;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Vehicle Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                auction.vehicleTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: auction.coverImage,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                  // Live Indicator
                  if (!hasEnded)
                    Positioned(
                      top: 60,
                      left: AppTheme.spacing3,
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing3,
                            vertical: AppTheme.spacing1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.auctionLive,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
              children: [
                // Countdown Timer Card
                _buildCountdownCard(theme, isEndingSoon, hasEnded),

                // Current Bid Card
                _buildCurrentBidCard(theme, auction),

                // Participants Count
                _buildParticipantsCard(theme, auction),

                const Divider(height: 1),

                // Bid History
                _buildBidHistory(theme, auction),

                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: hasEnded 
          ? _buildEndedBar(theme, auction)
          : _buildBidBar(theme, auction),
    );
  }

  Widget _buildCountdownCard(ThemeData theme, bool isEndingSoon, bool hasEnded) {
    Color cardColor = hasEnded 
        ? AppColors.textTertiary 
        : isEndingSoon 
            ? AppColors.error 
            : AppColors.primary;

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing3),
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasEnded 
              ? [AppColors.textTertiary, AppColors.textSecondary]
              : isEndingSoon
                  ? [AppColors.error, const Color(0xFFFF6F00)]
                  : [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasEnded 
                    ? Icons.timer_off 
                    : isEndingSoon 
                        ? Icons.warning_amber_rounded 
                        : Icons.timer,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacing2),
              Text(
                hasEnded 
                    ? 'Auction Ended' 
                    : isEndingSoon 
                        ? 'Ending Soon!' 
                        : 'Time Remaining',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing3),
          if (!hasEnded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit(_timeRemaining.inHours.toString().padLeft(2, '0'), 'Hours'),
                _buildTimeSeparator(),
                _buildTimeUnit((_timeRemaining.inMinutes % 60).toString().padLeft(2, '0'), 'Minutes'),
                _buildTimeSeparator(),
                _buildTimeUnit((_timeRemaining.inSeconds % 60).toString().padLeft(2, '0'), 'Seconds'),
              ],
            )
          else
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.white.withOpacity(0.9),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing3,
            vertical: AppTheme.spacing2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrentBidCard(ThemeData theme, AuctionModel auction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Current Highest Bid',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing2),
          Text(
            _formatPrice(auction.currentBid),
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${_formatPrice(auction.currentBid - auction.basePrice)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacing2),
              Text(
                'from base price',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsCard(ThemeData theme, AuctionModel auction) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: AppTheme.spacing3,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            Icons.people,
            '${auction.participantsCount}',
            'Bidders',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.border,
          ),
          _buildStatItem(
            theme,
            Icons.gavel,
            '${auction.bids.length}',
            'Total Bids',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.border,
          ),
          _buildStatItem(
            theme,
            Icons.local_offer,
            _formatPrice(auction.minIncrement),
            'Min Increment',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBidHistory(ThemeData theme, AuctionModel auction) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bid History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing3),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: auction.bids.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacing2),
            itemBuilder: (context, index) {
              final bid = auction.bids[index];
              final isHighest = index == 0;
              
              return Container(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                decoration: BoxDecoration(
                  color: isHighest 
                      ? AppColors.accent.withOpacity(0.1)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: isHighest 
                      ? Border.all(color: AppColors.accent, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isHighest ? AppColors.accent : AppColors.primary,
                      child: Text(
                        bid.bidderName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                bid.bidderName,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isHighest) ...[
                                const SizedBox(width: AppTheme.spacing1),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Highest',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            DateFormat('HH:mm:ss').format(bid.timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatPrice(bid.amount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isHighest ? AppColors.accent : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBidBar(ThemeData theme, AuctionModel auction) {
    final minBid = auction.currentBid + auction.minIncrement;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick bid buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _placeBid(minBid),
                    child: Text(_formatPrice(minBid)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing2),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _placeBid(minBid + auction.minIncrement),
                    child: Text(_formatPrice(minBid + auction.minIncrement)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing2),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCustomBidDialog(theme, auction),
                    child: const Text('Custom'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing2),
            CustomButton(
              text: 'Place Bid',
              onPressed: _isPlacingBid ? null : () => _placeBid(minBid),
              isLoading: _isPlacingBid,
              icon: Icons.gavel,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndedBar(ThemeData theme, AuctionModel auction) {
    final hasWinner = auction.winnerId != null;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasWinner) ...[
              Icon(
                Icons.emoji_events,
                size: 48,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppTheme.spacing2),
              Text(
                'Auction Ended',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Winner: ${auction.bids.first.bidderName}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spacing3),
            CustomButton(
              text: 'View Similar Auctions',
              onPressed: () => Navigator.pop(context),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomBidDialog(ThemeData theme, AuctionModel auction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Custom Bid'),
        content: TextField(
          controller: _bidController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount',
            prefixText: 'PKR ',
            helperText: 'Minimum: ${_formatPrice(auction.currentBid + auction.minIncrement)}',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_bidController.text);
              if (amount != null) {
                Navigator.pop(context);
                _placeBid(amount);
              }
            },
            child: const Text('Place Bid'),
          ),
        ],
      ),
    );
  }

  Future<void> _placeBid(double amount) async {
    setState(() => _isPlacingBid = true);
    
    // TODO: Implement actual bid placement
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isPlacingBid = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppTheme.spacing2),
              Text('Bid placed: ${_formatPrice(amount)}'),
            ],
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(1)} Lac';
    }
    return '${price.toStringAsFixed(0)} K';
  }

  AuctionModel _getMockAuction() {
    return AuctionModel(
      id: widget.auctionId,
      listingId: '1',
      vehicleTitle: 'Toyota Corolla GLI 2020',
      coverImage: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&h=450&fit=crop',
      basePrice: 4000000,
      currentBid: 4500000,
      minIncrement: 50000,
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(minutes: 45)),
      sellerId: 'seller1',
      sellerName: 'Ahmad Motors',
      bids: [
        BidModel(
          id: '5',
          auctionId: widget.auctionId,
          bidderId: 'user5',
          bidderName: 'Ali Khan',
          amount: 4500000,
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        BidModel(
          id: '4',
          auctionId: widget.auctionId,
          bidderId: 'user4',
          bidderName: 'Sara Ahmed',
          amount: 4450000,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        BidModel(
          id: '3',
          auctionId: widget.auctionId,
          bidderId: 'user3',
          bidderName: 'Hassan Raza',
          amount: 4400000,
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        ),
        BidModel(
          id: '2',
          auctionId: widget.auctionId,
          bidderId: 'user2',
          bidderName: 'Fatima Malik',
          amount: 4350000,
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        BidModel(
          id: '1',
          auctionId: widget.auctionId,
          bidderId: 'user1',
          bidderName: 'Ahmed Ali',
          amount: 4300000,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ],
      participantsCount: 12,
      status: AuctionStatus.live,
    );
  }
}
