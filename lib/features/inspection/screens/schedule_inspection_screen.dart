import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../auth/services/api_exception.dart';
import '../../sell_car/models/sell_car_enquiry_draft.dart';
import '../../sell_car/services/sell_car_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class ScheduleInspectionScreen extends StatefulWidget {
  const ScheduleInspectionScreen({super.key});

  @override
  State<ScheduleInspectionScreen> createState() =>
      _ScheduleInspectionScreenState();
}

class _ScheduleInspectionScreenState extends State<ScheduleInspectionScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _inspectionType;
  final _addressController = TextEditingController();
  final SellCarService _sellCarService = SellCarService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _selectedDate = args?['initialScheduleDate'] as DateTime?;
    _inspectionType = (args?['inspectionType'] ?? '').toString();
    final initialTime = (args?['initialScheduleTime'] ?? '').toString();
    if (initialTime.isNotEmpty) {
      _selectedTime = _findMatchingTimeSlot(initialTime);
    }
    _addressController.text = (args?['initialAddress'] ?? '').toString();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _confirmBooking() async {
    final args = Get.arguments as Map<String, dynamic>?;
    final draft = args?['draft'] as SellCarEnquiryDraft?;
    final enquiryId = (args?['enquiryId'] ?? draft?.enquiryId ?? '').toString();
    final inspectionType =
        _inspectionType?.trim().isNotEmpty == true
        ? _inspectionType!.trim()
        : (args?['inspectionType'] ?? '').toString().trim();
    final fromMyCars = args?['fromMyCars'] == true;

    if (_selectedDate == null || _selectedTime == null) {
      Get.snackbar(
        'Error',
        'Please select date and time',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter address',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (inspectionType.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select inspection type',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (enquiryId.isEmpty) {
      Get.snackbar(
        'Error',
        'Enquiry ID is missing. Please submit car details again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _sellCarService.scheduleInspection(
        enquiryId: enquiryId,
        scheduleDate: DateFormat('yyyy/MM/dd').format(_selectedDate!),
        scheduleTime: _formatScheduleTime(_selectedTime!),
        inspectionType: inspectionType,
        additionalInfo: _addressController.text.trim(),
      );
      if (fromMyCars) {
        Get.back(result: true);
      } else {
        Get.offAllNamed(
          AppRoutes.main,
          arguments: {'tabIndex': 3},
        );
      }
    } on ApiException catch (error) {
      Get.snackbar(
        'Error',
        error.message,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatScheduleTime(String slot) {
    final startTime = slot.split(' - ').first.trim();
    try {
      final parsed = DateFormat('hh:mm a').parse(startTime);
      return DateFormat('HH:mm').format(parsed);
    } catch (_) {
      return startTime;
    }
  }

  String _findMatchingTimeSlot(String time24) {
    for (final slot in StaticData.timeSlots) {
      if (_formatScheduleTime(slot) == time24) {
        return slot;
      }
    }
    return time24;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.scheduleInspection),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Section
            Text(
              AppStrings.selectDate,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontLG,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(),

            SizedBox(height: AppSizes.sm),

            // Date Picker Button
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.all(AppSizes.paddingMD),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  border: Border.all(
                    color: _selectedDate != null
                        ? AppColors.primary
                        : AppColors.grey300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _selectedDate != null
                          ? AppColors.primary
                          : AppColors.grey500,
                      size: AppSizes.iconMD,
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? DateFormat(
                                'EEEE, dd MMMM yyyy',
                              ).format(_selectedDate!)
                            : 'Select a date',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontMD,
                          color: _selectedDate != null
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.iconSM - 4,
                      color: AppColors.grey400,
                    ),
                  ],
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),

            // SizedBox(height: AppSizes.lg),

            // Time Slots
            // Text(
            //   AppStrings.inspectionType,
            //   style: GoogleFonts.poppins(
            //     fontSize: AppSizes.fontLG,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.textPrimary,
            //   ),
            // ).animate(delay: 150.ms).fadeIn(),

            // SizedBox(height: AppSizes.sm),

            // DropdownButtonFormField<String>(
            //   value: _inspectionType?.isEmpty == true ? null : _inspectionType,
            //   items: StaticData.inspectionTypes
            //       .map(
            //         (type) => DropdownMenuItem<String>(
            //           value: (type['title'] ?? '').toString(),
            //           child: Text((type['title'] ?? '').toString()),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (value) {
            //     setState(() => _inspectionType = value);
            //   },
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: AppColors.white,
            //     contentPadding: EdgeInsets.symmetric(
            //       horizontal: AppSizes.paddingSM,
            //       vertical: AppSizes.paddingSM,
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(AppSizes.inputRadius),
            //       borderSide: BorderSide.none,
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(AppSizes.inputRadius),
            //       borderSide: BorderSide(color: AppColors.grey300),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(AppSizes.inputRadius),
            //       borderSide: const BorderSide(
            //         color: AppColors.primary,
            //         width: 1.5,
            //       ),
            //     ),
            //   ),
            // ).animate(delay: 200.ms).fadeIn(),

            SizedBox(height: AppSizes.lg),

            // Time Slots
            Text(
              AppStrings.selectTime,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontLG,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 300.ms).fadeIn(),

            SizedBox(height: AppSizes.sm),

            // Time Slot Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
              ),
              itemCount: StaticData.timeSlots.length,
              itemBuilder: (context, index) {
                final slot = StaticData.timeSlots[index];
                final isSelected = _selectedTime == slot;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedTime = slot);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppSizes.buttonRadius,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).animate(delay: 400.ms).fadeIn(),

            SizedBox(height: AppSizes.lg),

            // Address
            Text(
              AppStrings.address,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontLG,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 500.ms).fadeIn(),

            SizedBox(height: AppSizes.sm),

            CustomTextField(
              hint: 'Enter your address for inspection',
              controller: _addressController,
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
            ).animate(delay: 600.ms).fadeIn(),

            SizedBox(height: AppSizes.sm),

            // Use Current Location
            GestureDetector(
              onTap: ()=>_getCurrentLocation(),
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      size: AppSizes.iconSM,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      'Use current location',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 700.ms).fadeIn(),

            SizedBox(height: AppSizes.xl),

            // Confirm Button
            CustomButton(
              text: AppStrings.confirmBooking,
              onPressed: _confirmBooking,
              isLoading: _isLoading,
              icon: Icons.check_circle,
            ).animate(delay: 800.ms).fadeIn(),

            SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }


  Future<void> _getCurrentLocation() async {
    try {
      // 🔐 Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied");
        return;
      }

      // 📍 Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("LAT: ${position.latitude}, LNG: ${position.longitude}");

      // 🌍 Convert to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      String address =
          "${place.name}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}";

      print("ADDRESS: $address");

      // ✅ Set in controller
      _addressController.text = address;
    } catch (e) {
      print("❌ LOCATION ERROR: $e");
    }
  }
}
