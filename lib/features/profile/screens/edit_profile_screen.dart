import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/services/api_exception.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final _imagePicker = ImagePicker();

  bool _isLoading = false;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    final session = _authController.session;
    _firstNameController.text = session?.firstName ?? '';
    _lastNameController.text = session?.lastName ?? '';
    _phoneController.text = session?.phone ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedImage = file;
      _selectedImageBytes = bytes;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authController.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        profileImageBytes: _selectedImageBytes,
        profileImageName: _selectedImage?.name,
      );
      Get.back();
      _showSnackbar('Profile updated successfully', isError: false);
    } on ApiException catch (error) {
      _showSnackbar(error.message, isError: true);
    } catch (_) {
      _showSnackbar('Something went wrong. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateName(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$label is required';
    }
    if (text.length < 2) {
      return '$label must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
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
    final session = _authController.session;
    final imageUrl = session?.profileImage ?? '';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.authGradient)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.white,
                        size: AppSizes.iconSM,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.lg),
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontHeading,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    'Update your personal details',
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontSM,
                      color: AppColors.grey400,
                    ),
                  ),
                  SizedBox(height: AppSizes.lg),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.paddingLG),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Column(
                              children: [
                                Container(
                                  width: AppSizes.avatarXL,
                                  height: AppSizes.avatarXL,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: _selectedImageBytes != null
                                        ? Image.memory(
                                            _selectedImageBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : imageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Container(
                                              color: AppColors.white.withOpacity(0.08),
                                            ),
                                            errorWidget: (_, __, ___) => Icon(
                                              Icons.person,
                                              color: AppColors.white,
                                              size: AppSizes.iconXL,
                                            ),
                                          )
                                        : Icon(
                                            Icons.add_a_photo_outlined,
                                            color: AppColors.white,
                                            size: AppSizes.iconLG,
                                          ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.sm),
                                Text(
                                  'Change profile photo',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSM,
                                    color: AppColors.grey400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizes.lg),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'First Name',
                                  hint: 'Enter first name',
                                  controller: _firstNameController,
                                  prefixIcon: Icons.person_outline,
                                  isDark: true,
                                  validator: (value) =>
                                      _validateName(value, 'First name'),
                                ),
                              ),
                              SizedBox(width: AppSizes.md),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Last Name',
                                  hint: 'Enter last name',
                                  controller: _lastNameController,
                                  prefixIcon: Icons.person_outline,
                                  isDark: true,
                                  validator: (value) =>
                                      _validateName(value, 'Last name'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.md),
                          CustomTextField(
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_outlined,
                            isDark: true,
                            validator: _validatePhone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          SizedBox(height: AppSizes.xl),
                          CustomButton(
                            text: 'Save Changes',
                            onPressed: _submit,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
