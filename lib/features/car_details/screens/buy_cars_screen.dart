import 'package:bid_driving/features/car_details/screens/car_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../home/widgets/car_card.dart';

class BuyCarsScreen extends StatefulWidget {
  final String? brand;

  const BuyCarsScreen({super.key, this.brand});

  @override
  State<BuyCarsScreen> createState() => _BuyCarsScreenState();
}

class _BuyCarsScreenState extends State<BuyCarsScreen> {
  String _selectedSort = 'Relevance';
  final CarController controller = Get.put(CarController());
  final List<String> _sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Mileage: Low to High',
  ];
  String? selectedBrand;

  String? _selectedFuel;
  String? _selectedTransmission;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        selectedFuel: _selectedFuel,
        selectedTransmission: _selectedTransmission,
        onApply: (
            fuel,
            transmission,
            priceRange,
            city,
            carType,
            yearRange,
            km,
            owner,
            insurance,
            ) {
          setState(() {
            _selectedFuel = fuel;
            _selectedTransmission = transmission;
          });

          // 🔥 CALL FILTER API
          controller.fetchCars(
            brand: selectedBrand,
            fuel: fuel,
            transmission: transmission,
            minPrice: priceRange.start.toInt(),
            maxPrice: priceRange.end.toInt(),
            city: city,
            carType: carType,
            minYear: yearRange.start.toInt(),
            maxYear: yearRange.end.toInt(),
            km: km,
            owner: owner,
          );

          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    selectedBrand = widget.brand;

    print("RECEIVED BRAND: $selectedBrand");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCars(brand: selectedBrand);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.buyCars,

        showBackButton: false,

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMD,
              vertical: AppSizes.paddingSM,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Sort Dropdown
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _SortSheet(
                          selected: _selectedSort,
                          options: _sortOptions,
                          onSelect: (value) {
                            setState(() => _selectedSort = value);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSM,
                        vertical: AppSizes.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey300),
                        borderRadius: BorderRadius.circular(
                          AppSizes.buttonRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sort,
                            size: AppSizes.iconSM,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: AppSizes.xs),
                          Flexible(
                            child: Text(
                              _selectedSort,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSM,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: AppSizes.sm),

                // Filter Button
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMD,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppSizes.buttonRadius,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune,
                          size: AppSizes.iconSM,
                          color: AppColors.white,
                        ),
                        SizedBox(width: AppSizes.xs),
                        Text(
                          'Filter',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSM,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.filteredCars.length} Cars Found',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                // Active Filters
                if (_selectedFuel != null || _selectedTransmission != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFuel = null;
                        _selectedTransmission = null;
                      });
                    },
                    child: Text(
                      'Clear Filters',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Car List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.filteredCars.isEmpty) {
                return Center(child: Text("No Cars Found"));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMD),
                itemCount: controller.filteredCars.length,
                itemBuilder: (context, index) {
                  final car = controller.filteredCars[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.md),
                    child: CarCard(
                      car: car, // 🔥 now using API data
                      // isHorizontal: false,
                      onTap: () =>
                          Get.toNamed(AppRoutes.carDetails, arguments: car),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final String selected;
  final List<String> options;
  final Function(String) onSelect;

  const _SortSheet({
    required this.selected,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontXL,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.md),
          ...options.map(
            (option) => ListTile(
              onTap: () => onSelect(option),
              contentPadding: EdgeInsets.zero,
              leading: Radio<String>(
                value: option,
                groupValue: selected,
                activeColor: AppColors.primary,
                onChanged: (value) => onSelect(value!),
              ),
              title: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontMD,
                  color: option == selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final String? selectedFuel;
  final String? selectedTransmission;

  final Function(
      String? fuel,
      String? transmission,
      RangeValues priceRange,
      String? city,
      String? carType,
      RangeValues yearRange,
      String? km,
      String? owner,
      String? insurance,
      ) onApply;

  const _FilterBottomSheet({
    this.selectedFuel,
    this.selectedTransmission,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedFuel;
  String? _selectedTransmission;

  // 🔹 Basic
  RangeValues _priceRange = const RangeValues(100000, 5000000);
  String? _selectedCity;
  String? _selectedCarType;

  // 🔹 Condition
  RangeValues _yearRange = const RangeValues(2015, 2025);
  String? _selectedKm;
  String? _selectedOwner;
  String? _selectedInsurance;

  @override
  void initState() {
    super.initState();
    _selectedFuel = widget.selectedFuel;
    _selectedTransmission = widget.selectedTransmission;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Modern off-white background
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadius * 1.5),
        ),
      ),
      child: Column(
        children: [
          // 🔹 DRAG HANDLE
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 🔹 HEADER
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLG,
              vertical: AppSizes.paddingMD,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filters",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFuel = null;
                      _selectedTransmission = null;
                      _selectedCity = null;
                      _selectedCarType = null;
                      _selectedKm = null;
                      _selectedOwner = null;
                      _selectedInsurance = null;
                      _priceRange = const RangeValues(100000, 5000000);
                      _yearRange = const RangeValues(2015, 2025);
                    });
                  },
                  child: Text(
                    "Reset All",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),

          // 🔹 BODY
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("General Specs"),
                  _buildContainer([
                    _buildLabel("Fuel Type"),
                    _buildChoiceGroup(StaticData.fuelTypes, _selectedFuel, (val) {
                      setState(() => _selectedFuel = val);
                    }),
                    const SizedBox(height: 20),
                    _buildLabel("Transmission"),
                    _buildChoiceGroup(StaticData.transmissionTypes, _selectedTransmission, (val) {
                      setState(() => _selectedTransmission = val);
                    }),
                  ]),

                  _buildSectionTitle("Price & Location"),
                  _buildContainer([
                    _buildLabel("Price Range"),
                    _buildRangeInfo("₹${_priceRange.start.round()}", "₹${_priceRange.end.round()}"),
                    RangeSlider(
                      values: _priceRange,
                      min: 100000,
                      max: 5000000,
                      divisions: 50,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withOpacity(0.1),
                      onChanged: (val) => setState(() => _priceRange = val),
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("City"),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      hint: const Text("Select City"),
                      value: _selectedCity,
                      decoration: _inputDecoration(),
                      items: ["Bhopal", "Indore", "Delhi", "Mumbai"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCity = val),
                    ),
                  ]),

                  _buildSectionTitle("Vehicle Details"),
                  _buildContainer([
                    _buildLabel("Car Type"),
                    _buildChoiceGroup(["Hatchback", "Sedan", "SUV", "Luxury"], _selectedCarType, (val) {
                      setState(() => _selectedCarType = val);
                    }),
                    const SizedBox(height: 20),
                    _buildLabel("Manufacturing Year"),
                    _buildRangeInfo(_yearRange.start.round().toString(), _yearRange.end.round().toString()),
                    RangeSlider(
                      values: _yearRange,
                      min: 2015,
                      max: 2025,
                      divisions: 10,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _yearRange = val),
                    ),
                  ]),

                  _buildSectionTitle("Condition & Ownership"),
                  _buildContainer([
                    _buildLabel("KM Driven"),
                    _buildChoiceGroup(["0-10k", "10k-50k", "50k+"], _selectedKm, (val) {
                      setState(() => _selectedKm = val);
                    }),
                    const SizedBox(height: 20),
                    _buildLabel("Owner Type"),
                    _buildChoiceGroup(["1st", "2nd", "3rd"], _selectedOwner, (val) {
                      setState(() => _selectedOwner = val);
                    }),
                    const SizedBox(height: 20),
                    _buildLabel("Insurance Status"),
                    _buildChoiceGroup(["Valid", "Expired", "Zero Dep"], _selectedInsurance, (val) {
                      setState(() => _selectedInsurance = val);
                    }),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 🔹 APPLY BUTTON
          Container(
            padding: EdgeInsets.all(AppSizes.paddingLG),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    widget.onApply(
                      _selectedFuel,
                      _selectedTransmission,
                      _priceRange,
                      _selectedCity,
                      _selectedCarType,
                      _yearRange,
                      _selectedKm,
                      _selectedOwner,
                      _selectedInsurance,
                    );
                  },
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 🔹 REUSABLE UI HELPERS
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildChoiceGroup(List<String> items, String? current, Function(String?) onSelected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = current == item;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelected(isSelected ? null : item),
          selectedColor: AppColors.primary.withOpacity(0.15),
          backgroundColor: const Color(0xFFF1F5F9),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : const Color(0xFF64748B),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildRangeInfo(String start, String end) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(start, style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
        Text(end, style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }
}
