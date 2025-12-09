import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class SellerUpgradeScreen extends ConsumerStatefulWidget {
  const SellerUpgradeScreen({super.key});

  @override
  ConsumerState<SellerUpgradeScreen> createState() => _SellerUpgradeScreenState();
}

class _SellerUpgradeScreenState extends ConsumerState<SellerUpgradeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _sellerType = 'individual';
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _cnicController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Seller'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Benefits Card
              Card(
                color: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.storefront, color: AppColors.primary, size: 32),
                          const SizedBox(width: AppTheme.spacing2),
                          Text(
                            'Seller Benefits',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing3),
                      _buildBenefit('List unlimited vehicles'),
                      _buildBenefit('Host live auctions'),
                      _buildBenefit('Track analytics & insights'),
                      _buildBenefit('Manage inquiries efficiently'),
                      _buildBenefit('Reach thousands of buyers'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacing5),

              Text(
                'Seller Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppTheme.spacing3),

              // Seller Type
              const Text('Seller Type', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildRadioTile('Individual', 'individual'),
              const SizedBox(height: 8),
              _buildRadioTile('Dealer', 'dealer'),
              const SizedBox(height: 8),
              _buildRadioTile('Showroom', 'showroom'),

              if (_sellerType != 'individual') ...[
                const SizedBox(height: AppTheme.spacing4),

                // Business Name
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    hintText: 'Enter your business name',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (_sellerType != 'individual' && (value == null || value.trim().isEmpty)) {
                      return 'Please enter your business name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppTheme.spacing3),

                // Business Address
                TextFormField(
                  controller: _businessAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Business Address',
                    hintText: 'Enter your business address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (_sellerType != 'individual' && (value == null || value.trim().isEmpty)) {
                      return 'Please enter your business address';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: AppTheme.spacing4),

              // CNIC
              TextFormField(
                controller: _cnicController,
                decoration: const InputDecoration(
                  labelText: 'CNIC Number',
                  hintText: '12345-1234567-1',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your CNIC number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppTheme.spacing6),

              // Submit Button
              CustomButton(
                text: 'Become a Seller',
                onPressed: _isLoading ? null : _handleSubmit,
                isLoading: _isLoading,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String label, String value) {
    final isSelected = _sellerType == value;
    return InkWell(
      onTap: () => setState(() => _sellerType = value),
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Save seller info to backend and update user role to "both"
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 32),
                const SizedBox(width: 12),
                const Text('Success!'),
              ],
            ),
            content: const Text(
              'You are now a seller! You can start listing your vehicles.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('Got it'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
}
