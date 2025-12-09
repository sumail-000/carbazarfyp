import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';

class ManageInquiriesScreen extends ConsumerStatefulWidget {
  const ManageInquiriesScreen({super.key});

  @override
  ConsumerState<ManageInquiriesScreen> createState() => _ManageInquiriesScreenState();
}

class _ManageInquiriesScreenState extends ConsumerState<ManageInquiriesScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final filteredInquiries = _selectedFilter == 'all'
        ? _mockInquiries
        : _mockInquiries.where((i) => i['listing'] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Inquiries'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppTheme.spacing3),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Toyota Corolla', 'corolla'),
                const SizedBox(width: 8),
                _buildFilterChip('Honda Civic', 'civic'),
                const SizedBox(width: 8),
                _buildFilterChip('Suzuki Alto', 'alto'),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Inquiries List
          Expanded(
            child: filteredInquiries.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacing3),
                    itemCount: filteredInquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = filteredInquiries[index];
                      return _buildInquiryCard(inquiry);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildInquiryCard(Map<String, dynamic> inquiry) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open chat with ${inquiry['name']}')),
          );
          // TODO: Navigate to chat screen
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      inquiry['name'][0],
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          inquiry['listingTitle'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (inquiry['unread'])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing2),
              Text(
                inquiry['message'],
                style: TextStyle(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacing2),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    inquiry['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quick reply sent!')),
                      );
                    },
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Quick Reply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacing3),
          Text(
            'No inquiries',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _mockInquiries = [
  {
    'name': 'Ahmad Khan',
    'listing': 'corolla',
    'listingTitle': 'Toyota Corolla 2020',
    'message': 'Is the car still available? Can I come for a test drive tomorrow?',
    'time': '2 hours ago',
    'unread': true,
  },
  {
    'name': 'Sara Ali',
    'listing': 'civic',
    'listingTitle': 'Honda Civic 2019',
    'message': 'What is your final price? Is there any room for negotiation?',
    'time': '5 hours ago',
    'unread': true,
  },
  {
    'name': 'Bilal Ahmed',
    'listing': 'alto',
    'listingTitle': 'Suzuki Alto 2021',
    'message': 'Can you share more pictures of the interior?',
    'time': '1 day ago',
    'unread': false,
  },
  {
    'name': 'Fatima Hassan',
    'listing': 'corolla',
    'listingTitle': 'Toyota Corolla 2020',
    'message': 'Does it have a service history? Any accidents?',
    'time': '2 days ago',
    'unread': false,
  },
];
