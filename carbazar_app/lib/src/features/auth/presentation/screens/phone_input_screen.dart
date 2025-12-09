import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/route_constants.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+92'; // Pakistan default
  bool _isLoading = false;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+92', 'country': 'Pakistan', 'flag': '🇵🇰'},
    {'code': '+91', 'country': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'country': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+971', 'country': 'UAE', 'flag': '🇦🇪'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),
                
                // Icon
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: AppColors.primary,
                ),
                
                const SizedBox(height: AppTheme.spacing4),
                
                Text(
                  'Enter Your Phone Number',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppTheme.spacing2),
                
                Text(
                  'We\'ll send you a verification code to confirm your number',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppTheme.spacing5),
                
                // Phone Number Input
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Code Selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: PopupMenuButton<String>(
                        initialValue: _selectedCountryCode,
                        onSelected: (value) {
                          setState(() => _selectedCountryCode = value);
                        },
                        itemBuilder: (context) => _countryCodes.map((country) {
                          return PopupMenuItem<String>(
                            value: country['code'],
                            child: Row(
                              children: [
                                Text(
                                  country['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: AppTheme.spacing2),
                                Text(country['code']!),
                                const SizedBox(width: AppTheme.spacing2),
                                Text(
                                  country['country']!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing3,
                            vertical: AppTheme.spacing3 + 2,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _countryCodes.firstWhere(
                                  (c) => c['code'] == _selectedCountryCode,
                                )['flag']!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedCountryCode,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: AppTheme.spacing2),
                    
                    // Phone Number Field
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: '3001234567',
                          hintStyle: TextStyle(color: AppColors.textTertiary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing3,
                            vertical: AppTheme.spacing3,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.trim().length < 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacing2),
                
                // Helper Text
                Text(
                  'Enter 10 digit mobile number without country code',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                
                const Spacer(),
                
                // Send OTP Button
                CustomButton(
                  text: 'Send OTP',
                  onPressed: _isLoading ? null : _handleSendOTP,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),
                
                const SizedBox(height: AppTheme.spacing3),
                
                // Skip Option
                TextButton(
                  onPressed: _handleSkip,
                  child: const Text('Skip for now'),
                ),
                
                const SizedBox(height: AppTheme.spacing3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
      
      // TODO: Implement Firebase Phone Auth
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Navigate to OTP verification with phone number
        context.push(
          RouteConstants.otpVerification,
          extra: fullPhoneNumber,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSkip() {
    // Allow users to skip phone verification for now
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Phone Verification?'),
        content: const Text(
          'You can verify your phone number later from settings. Some features may be limited.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteConstants.roleSelection);
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
