import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrapSession();
  }

  Future<void> _bootstrapSession() async {
    final authController = Get.find<AuthController>();

    await Future.wait([
      authController.restoreSession(),
      Future.delayed(const Duration(seconds: 5)),
    ]);

    /// 🔥 PRINT SESSION + TOKEN
    print("========== AUTH DEBUG ==========");
    print("IS LOGGED IN: ${authController.isLoggedIn}");
    print("SESSION: ${authController.session}");
    print("USER ID: ${authController.session?.userId}");
    print("ACCESS TOKEN: ${authController.session?.accessToken}");
    print("REFRESH TOKEN: ${authController.session?.refreshToken}");
    print("================================");

    if (!mounted) {
      return;
    }

    Get.offAllNamed(
      authController.isLoggedIn ? AppRoutes.main : AppRoutes.login,
    );
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppSizes.init(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. --- DYNAMIC BACKGROUND ---
          // Using a very deep Navy to make the Mint Green pop
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF070B11),
          ),

          // 2. --- RADIAL AMBIENT GLOW ---
          Positioned(
            top: -100,
            right: -100,
            child: _buildAmbientGlow(AppColors.primary.withOpacity(0.08), 300),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildAmbientGlow(AppColors.primary.withOpacity(0.05), 250),
          ),

          // 3. --- MAIN CONTENT ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO POD WITH GLASS EFFECT
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Shimmer Ring
                    Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                        ..shimmer(duration: const Duration(seconds: 2),color: AppColors.primary.withOpacity(0.2)),

                    // Glassmorphism Circle
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08), // ✅ ADD THIS
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: ClipOval(
                          child: Image.asset(
                          'assets/app_icon.png',
                            // width: 140,
                            // height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ),
                        ),
                      ),
                    ).animate()
                        .scale(duration: const Duration(milliseconds: 800))
                        .fadeIn(delay: const Duration(seconds: 1))                  ],
                ),

                const SizedBox(height: 60),

                // 4. --- MINIMALIST LOADER ---
                Column(
                  children: [
                    SizedBox(
                      width: 40,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        color: AppColors.primary,
                        minHeight: 2,
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: Duration(seconds: 1)),

                    const SizedBox(height: 16),

                    Text(
                      "YOUR CAR.YOUR PRICE.YOUR DEAL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ).animate().fadeIn(delay: Duration(seconds: 1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );

  }
  Widget _buildStylishLogoFrame() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Soft Mint Glow (behind the logo)
        Container(
          width: AppSizes.w(45),
          height: AppSizes.w(45),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 50,
                spreadRadius: 15,
              ),
            ],
          ),
        )
            .animate()
            .scale(begin: const Offset(0.3, 0.3), duration: 800.ms, curve: Curves.elasticOut),

        // 2. Clear Logo Asset (Center of attraction)
        Image.asset(
          'assets/app_icon.png', // ✅ Ensure path is correct in pubspec.yaml
          width: AppSizes.w(40),
          height: AppSizes.w(40),
          fit: BoxFit.contain,
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
      ],
    );
  }
}
