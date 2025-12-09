import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const AuthBackground({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          // Dark Background Base
          Container(
            color: const Color(0xFF0A0E21), // Very dark blue/black base
          ),

          // Main Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark.withOpacity(0.8),
                  const Color(0xFF0A0E21),
                ],
              ),
            ),
          ),

          // Decorative Top-Right Circle (Amber Accent)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Decorative Center-Left Shape (Primary Blue)
          Positioned(
            top: size.height * 0.3,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Decorative Bottom-Right Shape (Primary Blue)
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Subtle Grid/Pattern overlay (Optional - using loop for lines)
          // For simplicity keeping it sleek gradient based for now which is "cool" and clean.
          
          // Glass-morphism subtle overlay check
          // If we want the content to pop, we just place it on top.

          // Content
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
