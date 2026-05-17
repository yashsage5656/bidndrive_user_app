import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/auth_controller.dart';
import '../services/api_exception.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
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
                'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=1200',
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
                    SizedBox(height: AppSizes.h(5)),

                    // Logo
                    Center(
                          child: Container(
                            width: AppSizes.w(26),
                            height: AppSizes.w(26),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12),
                              child: Image.asset(
                                'assets/app_icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.easeOut)
                        .fadeIn(),

                    SizedBox(height: AppSizes.lg),

                    // Welcome Text
                    Center(
                          child: Column(
                            children: [
                              Text(
                                AppStrings.login,
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontHeading,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: AppSizes.xs),
                              Text(
                                'Welcome back! Please login to continue',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSM,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(delay: 200.ms)
                        .fadeIn()
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: AppSizes.xl),

                    // Login Form
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
                                  label: AppStrings.password,
                                  hint: 'Enter your password',
                                  controller: _passwordController,
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline,
                                  isDark: true,
                                  validator: _validatePassword,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _handleLogin(),
                                ),

                                SizedBox(height: AppSizes.sm),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      AppStrings.forgotPassword,
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSM,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSizes.md),

                                // Login Button
                                CustomButton(
                                  text: AppStrings.login,
                                  onPressed: _handleLogin,
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate(delay: 400.ms)
                        .fadeIn()
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: AppSizes.lg),

                    // // Or Divider
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Divider(
                    //         color: AppColors.grey600,
                    //         thickness: 0.5,
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: AppSizes.md,
                    //       ),
                    //       child: Text(
                    //         AppStrings.orContinueWith,
                    //         style: GoogleFonts.poppins(
                    //           fontSize: AppSizes.fontSM,
                    //           color: AppColors.grey500,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Divider(
                    //         color: AppColors.grey600,
                    //         thickness: 0.5,
                    //       ),
                    //     ),
                    //   ],
                    // ).animate(delay: 500.ms).fadeIn(),
                    SizedBox(height: AppSizes.lg),

                    // // Social Login Buttons
                    // Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         _SocialButton(
                    //           icon: Icons.g_mobiledata,
                    //           onTap: () {},
                    //         ),
                    //         SizedBox(width: AppSizes.md),
                    //         _SocialButton(icon: Icons.facebook, onTap: () {}),
                    //         SizedBox(width: AppSizes.md),
                    //         _SocialButton(icon: Icons.apple, onTap: () {}),
                    //       ],
                    //     )
                    //     .animate(delay: 600.ms)
                    //     .fadeIn()
                    //     .scale(begin: const Offset(0.8, 0.8)),

                    // SizedBox(height: AppSizes.xl),

                    // Sign Up Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSM,
                              color: AppColors.grey400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.signUp),
                            child: Text(
                              AppStrings.signUp,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 700.ms).fadeIn(),

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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w(15),
        height: AppSizes.w(15),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: AppColors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: AppColors.white, size: AppSizes.iconMD),
      ),
    );
  }
}
