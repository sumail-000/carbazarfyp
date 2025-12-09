import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../widgets/conversation_card.dart';

class MessagesListScreen extends ConsumerStatefulWidget {
  const MessagesListScreen({super.key});

  @override
  ConsumerState<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends ConsumerState<MessagesListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredConversations = _searchQuery.isEmpty
        ? _mockConversations
        : _mockConversations
            .where((c) => c['userName']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing3),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Conversations List
          Expanded(
            child: filteredConversations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];
                      return ConversationCard(
                        userName: conversation['userName'],
                        lastMessage: conversation['lastMessage'],
                        timestamp: conversation['timestamp'],
                        unreadCount: conversation['unreadCount'],
                        isOnline: conversation['isOnline'],
                        onTap: () {
                          // Navigate to chat screen
                          context.push(
                            RouteConstants.chat,
                            extra: {
                              'userId': conversation['userId'],
                              'userName': conversation['userName'],
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacing3),
          Text(
            _searchQuery.isEmpty ? 'No messages yet' : 'No results found',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: AppTheme.spacing2),
            Text(
              'Start a conversation by messaging a seller',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Mock Data
final List<Map<String, dynamic>> _mockConversations = [
  {
    'userId': '1',
    'userName': 'Ahmad Motors',
    'lastMessage': 'The car is available for viewing tomorrow',
    'timestamp': '2h ago',
    'unreadCount': 2,
    'isOnline': true,
  },
  {
    'userId': '2',
    'userName': 'Karachi Auto Dealers',
    'lastMessage': 'Yes, we can arrange a test drive',
    'timestamp': '5h ago',
    'unreadCount': 0,
    'isOnline': true,
  },
  {
    'userId': '3',
    'userName': 'Ali Hassan',
    'lastMessage': 'What is your final price?',
    'timestamp': '1d ago',
    'unreadCount': 1,
    'isOnline': false,
  },
  {
    'userId': '4',
    'userName': 'Premium Motors',
    'lastMessage': 'We have similar models in stock',
    'timestamp': '2d ago',
    'unreadCount': 0,
    'isOnline': false,
  },
  {
    'userId': '5',
    'userName': 'Sara Ahmed',
    'lastMessage': 'Is the price negotiable?',
    'timestamp': '3d ago',
    'unreadCount': 0,
    'isOnline': false,
  },
  {
    'userId': '6',
    'userName': 'Lahore Auto Hub',
    'lastMessage': 'Thank you for your interest',
    'timestamp': '4d ago',
    'unreadCount': 0,
    'isOnline': false,
  },
];
