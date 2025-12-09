import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// Simple user role provider for demo purposes
// TODO: Replace with proper state management and backend integration
final userRoleProvider = StateProvider<UserRole?>((ref) => null);

// Provider to check if user is seller
final isSellerProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.seller;
});

// Provider to check if user is buyer
final isBuyerProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.buyer;
});
