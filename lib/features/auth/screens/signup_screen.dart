import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/auth_controller.dart';
import '../services/api_exception.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  XFile? _selectedProfileImage;
  // Uint8List? _selectedProfileBytes;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _showTermsError = !_acceptedTerms;
    });

    if (!_formKey.currentState!.validate() || !_acceptedTerms || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        acceptedTerms: _acceptedTerms,
        // profileImageBytes: _selectedProfileBytes,
        // profileImageName: _selectedProfileImage?.name,
      );
      if (!mounted) {
        return;
      }
      Get.offAllNamed(AppRoutes.main);
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

  String? _validateName(String? value, {required String fieldName}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$fieldName is required';
    }

    if (text.length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
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

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(password)) {
      return 'Password must contain letters and numbers';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _showSnackbar(String message, {required bool isError}) {
    Get.snackbar(
      isError ? AppStrings.error : AppStrings.success,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Car Image
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.darkNavy),
            errorWidget: (_, __, ___) => Container(color: AppColors.darkNavy),
          ),
          // Dark Overlay Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.85),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.md),

                    // Back Button
                    GestureDetector(
                      onTap: () => Get.back(),
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
                    ).animate().fadeIn().slideX(begin: -0.2, end: 0),

                    SizedBox(height: AppSizes.lg),

                    // Header
                    Text(
                          AppStrings.signUp,
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontHeading,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        )
                        .animate(delay: 100.ms)
                        .fadeIn()
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: AppSizes.xs),

                    Text(
                      'Create an account to get started',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.grey400,
                      ),
                    ).animate(delay: 200.ms).fadeIn(),

                    SizedBox(height: AppSizes.lg),

                    // Form Container
                    Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(AppSizes.paddingLG),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(
                                AppSizes.cardRadius,
                              ),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              children: [

                                SizedBox(height: AppSizes.lg),

                                CustomTextField(
                                  label: 'First Name',
                                  hint: 'Enter first name',
                                  controller: _firstNameController,
                                  prefixIcon: Icons.person_outline,
                                  isDark: true,
                                  validator: (value) => _validateName(
                                    value,
                                    fieldName: 'First name',
                                  ),
                                ),

                                SizedBox(height: AppSizes.md),
                                CustomTextField(
                                  label: 'Last Name',
                                  hint: 'Enter last name',
                                  controller: _lastNameController,
                                  prefixIcon: Icons.person_outline,
                                  isDark: true,
                                  validator: (value) => _validateName(
                                    value,
                                    fieldName: 'Last name',
                                  ),
                                ),

                                SizedBox(height: AppSizes.md),

                                CustomTextField(
                                  label: AppStrings.email,
                                  hint: 'Enter your email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  isDark: true,
                                  validator: _validateEmail,
                                ),

                                SizedBox(height: AppSizes.md),

                                CustomTextField(
                                  label: AppStrings.phoneNumber,
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

                                SizedBox(height: AppSizes.md),

                                CustomTextField(
                                  label: AppStrings.password,
                                  hint: 'Create a password',
                                  controller: _passwordController,
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline,
                                  isDark: true,
                                  validator: _validatePassword,
                                ),

                                SizedBox(height: AppSizes.md),

                                CustomTextField(
                                  label: AppStrings.confirmPassword,
                                  hint: 'Confirm your password',
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline,
                                  isDark: true,
                                  validator: _validateConfirmPassword,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _handleSignup(),
                                ),

                                SizedBox(height: AppSizes.md),

                                // Terms Checkbox
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _acceptedTerms = !_acceptedTerms;
                                          if (_acceptedTerms) {
                                            _showTermsError = false;
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: _acceptedTerms
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: _acceptedTerms
                                                ? AppColors.primary
                                                : AppColors.grey500,
                                            width: 2,
                                          ),
                                        ),
                                        child: _acceptedTerms
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: AppColors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.sm),
                                    Expanded(
                                      child: Text(
                                        AppStrings.termsConditions,
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontXS,
                                          color: AppColors.grey400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if (_showTermsError) ...[
                                  SizedBox(height: AppSizes.xs),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'You must accept the terms to continue',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontXS,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],

                                SizedBox(height: AppSizes.lg),

                                // Signup Button
                                CustomButton(
                                  text: AppStrings.signUp,
                                  onPressed: _handleSignup,
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate(delay: 300.ms)
                        .fadeIn()
                        .slideY(begin: 0.1, end: 0),

                    SizedBox(height: AppSizes.lg),

                    // Login Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSM,
                              color: AppColors.grey400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              AppStrings.login,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 400.ms).fadeIn(),

                    SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
