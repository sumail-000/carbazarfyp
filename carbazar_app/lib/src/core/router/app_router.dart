import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/listings/presentation/screens/listing_detail_screen.dart';
import '../../features/auctions/presentation/screens/auction_room_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../constants/route_constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: RouteConstants.login,
        name: RouteConstants.loginName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstants.roleSelection,
        name: RouteConstants.roleSelectionName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstants.otpVerification,
        name: RouteConstants.otpVerificationName,
        pageBuilder: (context, state) {
          final phoneNumber = state.extra as String?;
          return MaterialPage(
            key: state.pageKey,
            child: OtpVerificationScreen(phoneNumber: phoneNumber ?? ''),
          );
        },
      ),

      // Main Navigation
      GoRoute(
        path: RouteConstants.home,
        name: RouteConstants.homeName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MainNavigationScreen(),
        ),
      ),

      // Listing Routes
      GoRoute(
        path: '${RouteConstants.listingDetail}/:id',
        name: RouteConstants.listingDetailName,
        pageBuilder: (context, state) {
          final listingId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: ListingDetailScreen(listingId: listingId),
          );
        },
      ),

      // Auction Routes
      GoRoute(
        path: '${RouteConstants.auctionRoom}/:id',
        name: RouteConstants.auctionRoomName,
        pageBuilder: (context, state) {
          final auctionId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: AuctionRoomScreen(auctionId: auctionId),
          );
        },
      ),

      // Profile Routes
      GoRoute(
        path: RouteConstants.profile,
        name: RouteConstants.profileName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        name: RouteConstants.editProfileName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstants.settings,
        name: RouteConstants.settingsName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),

      // Chat Routes
      GoRoute(
        path: '${RouteConstants.chat}/:userId',
        name: RouteConstants.chatName,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userName = state.extra as String?;
          return MaterialPage(
            key: state.pageKey,
            child: ChatScreen(
              userId: userId,
              userName: userName ?? 'User',
            ),
          );
        },
      ),
    ],
  );
});

