import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/pakistan_cities.dart';
import '../../../../core/constants/car_brands.dart';
import '../../../../common/models/user_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final UserRole userRole;
  
  const OnboardingScreen({
    super.key,
    required this.userRole,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form keys
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  
  // Step 1: Basic Info
  final _nameController = TextEditingController();
  String? _selectedCity;
  
  // Step 2: Buyer Info
  final Set<String> _selectedBrands = {};
  double _minBudget = 500000;
  double _maxBudget = 5000000;
  String _lookingFor = 'both'; // 'new', 'used', 'both'
  
  // Step 2: Seller Info
  String _sellerType = 'individual'; // 'individual', 'dealer', 'showroom'
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _cnicController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDark.withOpacity(0.3),
                    const Color(0xFF0A0E21),
                  ],
                ),
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Custom App Bar with progress
                  _buildAppBar(),
                  
                  // Page View
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => setState(() => _currentStep = index),
                      children: [
                        _buildStep1BasicInfo(),
                        widget.userRole == UserRole.buyer
                            ? _buildStep2BuyerInfo()
                            : _buildStep2SellerInfo(),
                      ],
                    ),
                  ),
                  
                  // Bottom Navigation
                  _buildBottomNav(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              Expanded(
                child: Text(
                  _currentStep == 0 ? 'Basic Information' : 
                  widget.userRole == UserRole.buyer ? 'Your Preferences' : 'Business Details',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${_currentStep + 1}/2',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing3),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 2,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1BasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s get to know you',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppTheme.spacing4),
            
            // City Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCity,
              dropdownColor: const Color(0xFF1E1E2E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'City',
                hintText: 'Select your city',
                prefixIcon: const Icon(Icons.location_city, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              items: pakistanCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCity = value),
              validator: (value) {
                if (value == null) {
                  return 'Please select your city';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppTheme.spacing6),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing3),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  const SizedBox(width: AppTheme.spacing2),
                  Expanded(
                    child: Text(
                      'This information helps us personalize your experience',
                      style: TextStyle(
                        color: AppColors.accent.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2BuyerInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help us find your perfect car',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Preferred Brands
            const Text(
              'Preferred Brands',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: carBrands.take(12).map((brand) {
                final isSelected = _selectedBrands.contains(brand);
                return FilterChip(
                  label: Text(brand),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBrands.add(brand);
                      } else {
                        _selectedBrands.remove(brand);
                      }
                    });
                  },
                  backgroundColor: Colors.white.withOpacity(0.1),
                  selectedColor: AppColors.accent.withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.accent : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  checkmarkColor: AppColors.accent,
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : Colors.white24,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Budget Range
            const Text(
              'Budget Range',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            RangeSlider(
              values: RangeValues(_minBudget, _maxBudget),
              min: 100000,
              max: 10000000,
              divisions: 100,
              activeColor: AppColors.accent,
              inactiveColor: Colors.white24,
              labels: RangeLabels(
                '${(_minBudget / 100000).toStringAsFixed(1)}L',
                '${(_maxBudget / 100000).toStringAsFixed(1)}L',
              ),
              onChanged: (values) {
                setState(() {
                  _minBudget = values.start;
                  _maxBudget = values.end;
                });
              },
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PKR ${(_minBudget / 100000).toStringAsFixed(1)} Lakh',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'PKR ${(_maxBudget / 100000).toStringAsFixed(1)} Lakh',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Looking For
            const Text(
              'Looking For',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            Row(
              children: [
                Expanded(child: _buildRadioOption('New', 'new')),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioOption('Used', 'used')),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioOption('Both', 'both')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2SellerInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your business',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Seller Type
            const Text(
              'Seller Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            _buildRadioOption('Individual', 'individual'),
            const SizedBox(height: 8),
            _buildRadioOption('Dealer', 'dealer'),
            const SizedBox(height: 8),
            _buildRadioOption('Showroom', 'showroom'),
            
            if (_sellerType != 'individual') ...[
              const SizedBox(height: AppTheme.spacing4),
              
              // Business Name
              TextFormField(
                controller: _businessNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Business Name',
                  hintText: 'Enter your business name',
                  prefixIcon: const Icon(Icons.business, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white38),
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
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Business Address',
                  hintText: 'Enter your business address',
                  prefixIcon: const Icon(Icons.location_on, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
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
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CNIC Number',
                hintText: '12345-1234567-1',
                prefixIcon: const Icon(Icons.credit_card, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your CNIC number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    final isSelected = widget.userRole == UserRole.buyer 
        ? _lookingFor == value 
        : _sellerType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.userRole == UserRole.buyer) {
            _lookingFor = value;
          } else {
            _sellerType = value;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing3,
          vertical: AppTheme.spacing2 + 4,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.accent.withOpacity(0.2) 
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.accent : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accent : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E21),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: _currentStep == 0 ? 'Continue' : 'Finish',
        onPressed: _isLoading ? null : _handleContinue,
        isLoading: _isLoading,
        fullWidth: true,
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (_currentStep == 0) {
      if (_step1FormKey.currentState!.validate()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (_step2FormKey.currentState!.validate()) {
        setState(() => _isLoading = true);
        
        try {
          // TODO: Save onboarding data to backend/state
          await Future.delayed(const Duration(seconds: 2));
          
          if (mounted) {
            context.go(RouteConstants.home);
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
  }
}
