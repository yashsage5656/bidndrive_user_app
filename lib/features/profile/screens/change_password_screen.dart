import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/services/api_exception.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCurrentPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'New password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(password)) {
      return 'Password must contain letters and numbers';
    }
    if (password == _currentPasswordController.text) {
      return 'New password must be different';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Please confirm new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authController.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      Get.back();
      _showSnackbar('Password changed successfully', isError: false);
    } on ApiException catch (error) {
      debugPrint(
        'ChangePasswordScreen -> ApiException: ${error.message}, status: ${error.statusCode}',
      );
      _showSnackbar(error.message, isError: true);
    } catch (error, stackTrace) {
      debugPrint('ChangePasswordScreen -> error: $error');
      debugPrint('$stackTrace');
      _showSnackbar(error.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                    'Change Password',
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontHeading,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    'Update your password securely',
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
                          CustomTextField(
                            label: 'Current Password',
                            hint: 'Enter current password',
                            controller: _currentPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                            isDark: true,
                            validator: _validateCurrentPassword,
                          ),
                          SizedBox(height: AppSizes.md),
                          CustomTextField(
                            label: 'New Password',
                            hint: 'Enter new password',
                            controller: _newPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                            isDark: true,
                            validator: _validateNewPassword,
                          ),
                          SizedBox(height: AppSizes.md),
                          CustomTextField(
                            label: 'Confirm New Password',
                            hint: 'Re-enter new password',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                            isDark: true,
                            validator: _validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                          SizedBox(height: AppSizes.xl),
                          CustomButton(
                            text: 'Update Password',
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
