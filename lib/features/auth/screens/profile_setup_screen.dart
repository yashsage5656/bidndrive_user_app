import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool _isLoading = false;

  void _handleContinue() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Get.offAllNamed(AppRoutes.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final user = StaticData.userProfile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Gradient
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.paddingLG),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.cardRadius * 2),
                    bottomRight: Radius.circular(AppSizes.cardRadius * 2),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.md),

                    // Title
                    Text(
                      AppStrings.profileSetup,
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontHeading,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2, end: 0),

                    SizedBox(height: AppSizes.xs),

                    Text(
                      'Complete your profile to get started',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),

                    SizedBox(height: AppSizes.lg),

                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: AppSizes.avatarXL,
                          height: AppSizes.avatarXL,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowDark,
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              user['avatar'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.grey300,
                                child: Icon(
                                  Icons.person,
                                  size: AppSizes.iconXL,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ),
                          ),
                        ).animate().scale(
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(AppSizes.xs),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowMedium,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: AppSizes.iconSM,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.md),

                    // Name
                    Text(
                      user['name'],
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    Text(
                      user['email'],
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),

                    SizedBox(height: AppSizes.lg),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(value: '${user['totalCars']}', label: 'Cars'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _StatItem(value: '${user['totalBids']}', label: 'Bids'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _StatItem(
                          value: user['memberSince'],
                          label: 'Member Since',
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn(),

                    SizedBox(height: AppSizes.md),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.lg),

              // Menu Items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
                child: Column(
                  children: [
                    _MenuItem(
                          icon: Icons.person_outline,
                          title: 'Personal Information',
                          subtitle: 'Update your personal details',
                          onTap: () {},
                        )
                        .animate(delay: 300.ms)
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),

                    _MenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          subtitle: 'Add your address for pickup',
                          onTap: () {},
                        )
                        .animate(delay: 400.ms)
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),

                    _MenuItem(
                          icon: Icons.description_outlined,
                          title: 'Documents',
                          subtitle: 'Upload KYC documents',
                          onTap: () {},
                        )
                        .animate(delay: 500.ms)
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),

                    _MenuItem(
                          icon: Icons.account_balance_outlined,
                          title: 'Bank Details',
                          subtitle: 'For receiving payments',
                          onTap: () {},
                        )
                        .animate(delay: 600.ms)
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),

                    SizedBox(height: AppSizes.xl),

                    // Buttons
                    CustomButton(
                      text: 'Continue',
                      onPressed: _handleContinue,
                      isLoading: _isLoading,
                    ).animate(delay: 700.ms).fadeIn(),

                    SizedBox(height: AppSizes.md),

                    TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.main),
                      child: Text(
                        AppStrings.skip,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontMD,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontXS,
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMD,
          vertical: AppSizes.paddingSM,
        ),
        leading: Container(
          width: AppSizes.iconLG + 8,
          height: AppSizes.iconLG + 8,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppSizes.sm),
          ),
          child: Icon(icon, color: AppColors.primary, size: AppSizes.iconSM),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontMD,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSM,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSizes.iconSM - 4,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}
