import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../auth/services/api_exception.dart';
import '../models/sell_car_enquiry_draft.dart';
import '../services/sell_car_service.dart';

class CarConditionScreen extends StatefulWidget {
  const CarConditionScreen({super.key});

  @override
  State<CarConditionScreen> createState() => _CarConditionScreenState();
}

class _CarConditionScreenState extends State<CarConditionScreen> {
  Map<String, dynamic>? rcData;
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _registrationController = TextEditingController();
  final _colorController = TextEditingController();
  final _kilometersController = TextEditingController();
  final _expectedPriceController = TextEditingController();
  final _contactController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final ImagePicker _imagePicker = ImagePicker();
  final SellCarService _sellCarService = SellCarService();

  String? _fuelType;
  String? _transmission;
  String? _ownership;
  String? _accidentHistory;
  bool _isSubmitting = false;
  final List<SellCarImageAttachment> _images = [];

  static const _fuelOptions = ['petrol', 'diesel', 'cng', 'electric', 'hybrid'];
  static const _transmissionOptions = ['manual', 'automatic'];
  static const _ownershipOptions = ['first', 'second', 'third', 'fourth+'];
  static const _accidentOptions = ['none', 'minor', 'major'];
  String? mapFuelType(String? apiFuel) {
    if (apiFuel == null) return null;

    final fuel = apiFuel.toLowerCase();

    if (fuel.contains("petrol") && fuel.contains("cng")) {
      return "cng"; // or "petrol" based on your logic
    } else if (fuel.contains("petrol")) {
      return "petrol";
    } else if (fuel.contains("diesel")) {
      return "diesel";
    } else if (fuel.contains("cng")) {
      return "cng";
    } else if (fuel.contains("electric")) {
      return "electric";
    } else if (fuel.contains("hybrid")) {
      return "hybrid";
    }

    return null;
  }
  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;

    if (arguments is Map<String, dynamic>) {
      rcData = arguments;

      print("📦 RC DATA RECEIVED: $rcData");

      // ✅ Set RC Number in Registration Field
      _registrationController.text =
          (arguments['rc_number'] ?? '').toString();

      // OR fallback if registrationNumber exists
      if (_registrationController.text.isEmpty) {
        _registrationController.text =
            (arguments['registrationNumber'] ?? '').toString();
      }

      _fillRcData();
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _registrationController.dispose();
    _colorController.dispose();
    _kilometersController.dispose();
    _expectedPriceController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Future<void> _pickImages() async {
  //   /// IMAGE SOURCE SELECTION
  //   final source = await showModalBottomSheet<ImageSource>(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(20),
  //       ),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 width: 42,
  //                 height: 4,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade300,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 24),
  //
  //               Text(
  //                 "Select Image Source",
  //                 style: GoogleFonts.inter(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w800,
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 24),
  //
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: InkWell(
  //                       onTap: () {
  //                         Navigator.pop(
  //                           context,
  //                           ImageSource.camera,
  //                         );
  //                       },
  //                       borderRadius: BorderRadius.circular(16),
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 22,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(16),
  //                           border: Border.all(
  //                             color: Colors.grey.shade200,
  //                           ),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               padding: const EdgeInsets.all(14),
  //                               decoration: BoxDecoration(
  //                                 color: AppColors.primary
  //                                     .withOpacity(.08),
  //                                 shape: BoxShape.circle,
  //                               ),
  //                               child: const Icon(
  //                                 Icons.camera_alt_rounded,
  //                                 color: AppColors.primary,
  //                                 size: 28,
  //                               ),
  //                             ),
  //
  //                             const SizedBox(height: 12),
  //
  //                             Text(
  //                               "Camera",
  //                               style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.w700,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //
  //                   const SizedBox(width: 16),
  //
  //                   Expanded(
  //                     child: InkWell(
  //                       onTap: () {
  //                         Navigator.pop(
  //                           context,
  //                           ImageSource.gallery,
  //                         );
  //                       },
  //                       borderRadius: BorderRadius.circular(16),
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 22,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(16),
  //                           border: Border.all(
  //                             color: Colors.grey.shade200,
  //                           ),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               padding: const EdgeInsets.all(14),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.green
  //                                     .withOpacity(.08),
  //                                 shape: BoxShape.circle,
  //                               ),
  //                               child: const Icon(
  //                                 Icons.photo_library_rounded,
  //                                 color: Colors.green,
  //                                 size: 28,
  //                               ),
  //                             ),
  //
  //                             const SizedBox(height: 12),
  //
  //                             Text(
  //                               "Gallery",
  //                               style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.w700,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 10),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  //   if (source == null) {
  //     return;
  //   }
  //
  //   final remaining = 10 - _images.length;
  //
  //   if (remaining <= 0) {
  //     _showSnackbar(
  //       'You can upload up to 10 images only',
  //       isError: true,
  //     );
  //     return;
  //   }
  //
  //   final attachments = <SellCarImageAttachment>[];
  //
  //   /// CAMERA
  //   if (source == ImageSource.camera) {
  //     final captured = await _imagePicker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 80,
  //     );
  //
  //     if (captured == null) {
  //       return;
  //     }
  //
  //     attachments.add(
  //       SellCarImageAttachment(
  //         bytes: await captured.readAsBytes(),
  //         name: captured.name,
  //       ),
  //     );
  //   }
  //
  //   /// GALLERY
  //   else {
  //     final selected = await _imagePicker.pickMultiImage(
  //       imageQuality: 80,
  //     );
  //
  //     if (selected.isEmpty) {
  //       return;
  //     }
  //
  //     final limited = selected.take(remaining);
  //
  //     for (final image in limited) {
  //       attachments.add(
  //         SellCarImageAttachment(
  //           bytes: await image.readAsBytes(),
  //           name: image.name,
  //         ),
  //       );
  //     }
  //   }
  //
  //   if (!mounted) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _images.addAll(attachments);
  //   });
  // }



  void _fillRcData() {
    try {
      _makeController.text =
          (rcData?["maker_description"] ?? "").toString();

      _modelController.text =
          (rcData?["maker_model"] ?? "").toString();

      _yearController.text =
          (rcData?["manufacturing_date_formatted"] ?? "")
              .toString()
              .split("-")
              .first;

      _colorController.text =
          (rcData?["color"] ?? "").toString();

      // ✅ RC Number
      _registrationController.text =
          (rcData?["rc_number"] ?? "").toString();

      // ✅ Fuel Type Mapping
      _fuelType = mapFuelType(
        (rcData?["fuel_type"] ?? "").toString(),
      );

      // ✅ City / RTO
      _cityController.text =
          (rcData?["registered_at"] ?? "").toString();

      print("📦 RC Number => ${_registrationController.text}");
      print("✅ Form Auto Filled Successfully");

      setState(() {});
    } catch (e) {
      print("❌ Error filling RC data: $e");
    }
  }



    void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    if (_fuelType == null ||
        _transmission == null ||
        _ownership == null ){
      _showSnackbar('Please complete all dropdown selections', isError: true);
      return;
    }

    // if (_images.isEmpty) {
    //   _showSnackbar('Please add at least one car image', isError: true);
    //   return;
    // }

    final draft = SellCarEnquiryDraft(
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      registrationNumber: _registrationController.text.trim().toUpperCase(),
      color: _colorController.text.trim(),
      // kilometersDriven: int.parse(_kilometersController.text.trim()),
      expectedPrice: int.parse(_expectedPriceController.text.trim()),
      city: _cityController.text.trim(),
      contactNumber: _contactController.text.trim(),
      fuelType: _fuelType!,
      transmission: _transmission!,
      ownership: _ownership!,
      // accidentHistory: _accidentHistory!,
      description: _descriptionController.text.trim(),
      images: List<SellCarImageAttachment>.from(_images),
    );

    setState(() => _isSubmitting = true);
    try {
      final enquiryId = await _sellCarService.createSellEnquiry(draft);
      Get.toNamed(
        AppRoutes.bidEstimate,
        arguments: draft.copyWith(enquiryId: enquiryId),
      );
    } on ApiException catch (error) {
      _showSnackbar(error.message, isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String? _requiredText(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _validateYear(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Year is required';
    }
    final year = int.tryParse(text);
    final currentYear = DateTime.now().year + 1;
    if (year == null || year < 1990 || year > currentYear) {
      return 'Enter a valid year';
    }
    return null;
  }

  String? _validateNumber(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$label is required';
    }
    final number = int.tryParse(text);
    if (number == null || number <= 0) {
      return 'Enter a valid $label';
    }
    return null;
  }

  String? _validateRegistration(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Registration number is required';
    }
    if (text.length < 8) {
      return 'Enter a valid registration number';
    }
    return null;
  }

  void _showSnackbar(String message, {required bool isError}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      backgroundColor: isError ? AppColors.error : AppColors.success,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Sell Car Details',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingLG),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppSizes.w(16),
                      height: AppSizes.w(16),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sell_outlined,
                        color: AppColors.white,
                        size: AppSizes.iconLG,
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share your car details',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontLG,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'Fill the form and submit your sell enquiry to continue.',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSM,
                              color: AppColors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.lg),
              const _SectionTitle(title: 'Car Details'),
              SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Brand',
                      hint: 'e.g. Hyundai',
                      controller: _makeController,
                      validator: (value) => _requiredText(value, 'Brand'),
                    ),
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomTextField(
                      label: 'Model',
                      hint: 'e.g. i20',
                      controller: _modelController,
                      validator: (value) => _requiredText(value, 'Model'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Year',
                      hint: 'e.g. 2018',
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      validator: _validateYear,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomTextField(
                      label: 'Color',
                      hint: 'e.g. Grey',
                      controller: _colorController,
                      validator: (value) => _requiredText(value, 'Color'),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: AppSizes.md),
              // CustomTextField(
              //   label: 'Registration Number',
              //   hint: 'e.g. MH12CD5678',
              //   controller: _registrationController,
              //   validator: _validateRegistration,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
              //     LengthLimitingTextInputFormatter(13),
              //   ],
              // ),
              // SizedBox(height: AppSizes.md),
              // CustomTextField(
              //   label: 'Kilometers Driven',
              //   hint: 'e.g. 52000',
              //   controller: _kilometersController,
              //   keyboardType: TextInputType.number,
              //   validator: (value) =>
              //       _validateNumber(value, 'kilometers driven'),
              //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // ),
              SizedBox(height: AppSizes.lg),
              const _SectionTitle(title: 'Selling Details'),
              SizedBox(height: AppSizes.md),
              CustomTextField(
                label: 'Expected Price',
                hint: 'e.g. 450000',
                controller: _expectedPriceController,
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'expected price'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              CustomTextField(
                label: 'Contact No.',
                hint: 'e.g. 9132191321',
                controller: _contactController,
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'contact number'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: AppSizes.md),
              CustomTextField(
                label: 'City',
                hint: 'e.g. Pune',
                controller: _cityController,
                validator: (value) => _requiredText(value, 'City'),
              ),
              SizedBox(height: AppSizes.md),
              _DropdownField(
                label: 'Fuel Type',
                value: _fuelType,
                items: _fuelOptions,
                onChanged: (value) => setState(() => _fuelType = value),
              ),
              SizedBox(height: AppSizes.md),
              _DropdownField(
                label: 'Transmission',
                value: _transmission,
                items: _transmissionOptions,
                onChanged: (value) => setState(() => _transmission = value),
              ),
              SizedBox(height: AppSizes.md),
              _DropdownField(
                label: 'Ownership',
                value: _ownership,
                items: _ownershipOptions,
                onChanged: (value) => setState(() => _ownership = value),
              ),

              SizedBox(height: AppSizes.md),
              CustomTextField(
                label: 'Description',
                hint: 'Tell us about the condition of your car',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) => _requiredText(value, 'Description'),
              ),
              SizedBox(height: AppSizes.lg),
              // const _SectionTitle(title: 'Car Images'),
              // SizedBox(height: AppSizes.xs),
              // Text(
              //   'Upload up to 10 photos of your car.',
              //   style: GoogleFonts.poppins(
              //     fontSize: AppSizes.fontSM,
              //     color: AppColors.textSecondary,
              //   ),
              // ),
              // SizedBox(height: AppSizes.md),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: [
                  ..._images.asMap().entries.map((entry) {
                    return Stack(
                      children: [
                        Container(
                          width: AppSizes.w(22),
                          height: AppSizes.w(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            color: AppColors.white,
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            child: Image.memory(
                              entry.value.bytes,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(entry.key),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                ],
              ),
              SizedBox(height: AppSizes.xl),
              CustomButton(
                text: 'Submit Details',
                onPressed: _submit,
                isLoading: _isSubmitting,
              ),
              SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: AppSizes.fontMD,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontSM,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.xs),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.inputRadius),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select $label'),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item[0].toUpperCase() + item.substring(1)),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
