import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/car_brands.dart';
import '../../../../core/constants/pakistan_cities.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;
  
  // Form keys
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step4FormKey = GlobalKey<FormState>();
  
  // Step 1: Basic Info
  String? _selectedBrand;
  final _modelController = TextEditingController();
  int? _selectedYear;
  String _condition = 'used';
  final _mileageController = TextEditingController();
  
  // Step 2: Details
  final _colorController = TextEditingController();
  String _transmission = 'automatic';
  String _fuelType = 'petrol';
  final _engineController = TextEditingController();
  final Set<String> _selectedFeatures = {};
  final _descriptionController = TextEditingController();
  
  // Step 3: Images (placeholder for now)
  final List<String> _images = [];
  
  // Step 4: Pricing
  String _saleType = 'fixed';
  final _priceController = TextEditingController();
  final _basePriceController = TextEditingController();
  DateTime? _auctionStart;
  DateTime? _auctionEnd;
  String? _selectedCity;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _modelController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _engineController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _basePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text('Save Draft'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Page View
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildStep1BasicInfo(),
                _buildStep2Details(),
                _buildStep3Images(),
                _buildStep4Pricing(),
                _buildStep5Preview(),
              ],
            ),
          ),
          
          // Bottom Navigation
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${_currentStep + 1} of $_totalSteps',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
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
            Text(
              'Vehicle Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            
            // Brand Dropdown
            DropdownButtonFormField<String>(
              value: _selectedBrand,
              decoration: const InputDecoration(
                labelText: 'Brand',
                prefixIcon: Icon(Icons.directions_car),
              ),
              items: carBrands.map((brand) {
                return DropdownMenuItem(value: brand, child: Text(brand));
              }).toList(),
              onChanged: (value) => setState(() => _selectedBrand = value),
              validator: (value) => value == null ? 'Please select a brand' : null,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Model
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'e.g., Corolla, Civic',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter model' : null,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Year
            DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              items: List.generate(30, (i) => DateTime.now().year - i)
                  .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
                  .toList(),
              onChanged: (value) => setState(() => _selectedYear = value),
              validator: (value) => value == null ? 'Please select year' : null,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Condition
            const Text('Condition', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildRadioTile('New', 'new', _condition, (val) => setState(() => _condition = val!))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioTile('Used', 'used', _condition, (val) => setState(() => _condition = val!))),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Mileage
            TextFormField(
              controller: _mileageController,
              decoration: const InputDecoration(
                labelText: 'Mileage (km)',
                hintText: 'e.g., 50000',
                prefixIcon: Icon(Icons.speed),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter mileage' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Details() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            
            // Color
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                hintText: 'e.g., White, Black',
                prefixIcon: Icon(Icons.palette),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter color' : null,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Transmission
            const Text('Transmission', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildRadioTile('Automatic', 'automatic', _transmission, (val) => setState(() => _transmission = val!))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioTile('Manual', 'manual', _transmission, (val) => setState(() => _transmission = val!))),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Fuel Type
            const Text('Fuel Type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildChoiceChip('Petrol', 'petrol', _fuelType, (val) => setState(() => _fuelType = val)),
                _buildChoiceChip('Diesel', 'diesel', _fuelType, (val) => setState(() => _fuelType = val)),
                _buildChoiceChip('Hybrid', 'hybrid', _fuelType, (val) => setState(() => _fuelType = val)),
                _buildChoiceChip('Electric', 'electric', _fuelType, (val) => setState(() => _fuelType = val)),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Engine Capacity
            TextFormField(
              controller: _engineController,
              decoration: const InputDecoration(
                labelText: 'Engine Capacity (cc)',
                hintText: 'e.g., 1300',
                prefixIcon: Icon(Icons.settings),
              ),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Features
            const Text('Features', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'ABS', 'Airbags', 'Sunroof', 'Alloy Rims', 'Cruise Control',
                'Navigation', 'Rear Camera', 'Parking Sensors'
              ].map((feature) => FilterChip(
                label: Text(feature),
                selected: _selectedFeatures.contains(feature),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFeatures.add(feature);
                    } else {
                      _selectedFeatures.remove(feature);
                    }
                  });
                },
              )).toList(),
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your vehicle...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter description' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Images() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Images',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing2),
          Text(
            'Add up to 10 images of your vehicle',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppTheme.spacing4),
          
          // Image Upload Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text(
                    'Image upload coming soon!',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to select images',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Pricing() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Form(
        key: _step4FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing & Location',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            
            // Sale Type
            const Text('Sale Type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildRadioTile('Fixed Price', 'fixed', _saleType, (val) => setState(() => _saleType = val!))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioTile('Auction', 'auction', _saleType, (val) => setState(() => _saleType = val!))),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            if (_saleType == 'fixed') ...[
              // Fixed Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (PKR)',
                  hintText: 'e.g., 4500000',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
            ] else ...[
              // Auction Base Price
              TextFormField(
                controller: _basePriceController,
                decoration: const InputDecoration(
                  labelText: 'Base Price (PKR)',
                  hintText: 'Starting bid amount',
                  prefixIcon: Icon(Icons.gavel),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter base price' : null,
              ),
              const SizedBox(height: AppTheme.spacing3),
              Text('Auction dates coming soon!', style: TextStyle(color: AppColors.textSecondary)),
            ],
            
            const SizedBox(height: AppTheme.spacing3),
            
            // City
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: pakistanCities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCity = value),
              validator: (value) => value == null ? 'Please select city' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5Preview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview & Publish',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          
          _buildPreviewSection('Basic Info', [
            'Brand: ${_selectedBrand ?? 'N/A'}',
            'Model: ${_modelController.text.isEmpty ? 'N/A' : _modelController.text}',
            'Year: ${_selectedYear ?? 'N/A'}',
            'Condition: ${_condition.toUpperCase()}',
            'Mileage: ${_mileageController.text.isEmpty ? 'N/A' : _mileageController.text} km',
          ]),
          
          _buildPreviewSection('Details', [
            'Color: ${_colorController.text.isEmpty ? 'N/A' : _colorController.text}',
            'Transmission: ${_transmission.toUpperCase()}',
            'Fuel: ${_fuelType.toUpperCase()}',
            'Engine: ${_engineController.text.isEmpty ? 'N/A' : _engineController.text} cc',
            'Features: ${_selectedFeatures.isEmpty ? 'None' : _selectedFeatures.join(', ')}',
          ]),
          
          _buildPreviewSection('Pricing', [
            'Type: ${_saleType == 'fixed' ? 'Fixed Price' : 'Auction'}',
            'Price: PKR ${_saleType == 'fixed' ? _priceController.text : _basePriceController.text}',
            'City: ${_selectedCity ?? 'N/A'}',
          ]),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(item),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String label, String value, String groupValue, ValueChanged<String?> onChanged) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: groupValue == value ? AppColors.primary : AppColors.border,
            width: groupValue == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(
              groupValue == value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: groupValue == value ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, String value, String selected, ValueChanged<String> onSelected) {
    final isSelected = selected == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CustomButton(
              text: _currentStep == _totalSteps - 1 ? 'Publish' : 'Continue',
              onPressed: _isLoading ? null : _handleContinue,
              isLoading: _isLoading,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (_currentStep == 0 && !_step1FormKey.currentState!.validate()) return;
    if (_currentStep == 1 && !_step2FormKey.currentState!.validate()) return;
    if (_currentStep == 3 && !_step4FormKey.currentState!.validate()) return;
    
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Publish listing
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing published successfully!')),
        );
        context.pop();
      }
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved!')),
    );
    // TODO: Save to backend
  }
}
