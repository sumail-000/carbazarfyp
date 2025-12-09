import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../../core/constants/route_constants.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            
            // Logo
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(
                Icons.car_rental_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing4),
            
            // App Name
            Text(
              'CARBAZAR',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            // Tagline
            Text(
              'Your Trusted Automobile Marketplace',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacing6),
            
            // Features
            _buildFeatureItem(
              context,
              Icons.verified_user,
              'Verified Sellers',
              'Sellers can verify their identity for added trust',
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            _buildFeatureItem(
              context,
              Icons.gavel,
              'Live Auctions',
              'Participate in real-time vehicle auctions',
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            _buildFeatureItem(
              context,
              Icons.security,
              'Secure & Transparent',
              'Complete transparency with fraud prevention',
            ),
            
            const Spacer(),
            
            // Get Started Button
            CustomButton(
              text: 'Get Started',
              onPressed: () => context.push(RouteConstants.signup),
              fullWidth: true,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Login Button
            OutlinedButton(
              onPressed: () => context.push(RouteConstants.login),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
                side: const BorderSide(color: Colors.white30),
                foregroundColor: Colors.white,
              ),
              child: const Text('I Already Have an Account'),
            ),
            
            const SizedBox(height: AppTheme.spacing3),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(
            icon,
            color: AppColors.accent, // Use accent for icons to pop
            size: 24,
          ),
        ),
        const SizedBox(width: AppTheme.spacing3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
