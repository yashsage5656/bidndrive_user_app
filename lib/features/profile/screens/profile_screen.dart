import 'package:bid_driving/features/home/screens/main_screen.dart';
import 'package:bid_driving/features/profile/screens/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkNavy : AppColors.background,
      body: Obx(() {
        final user = authController.session;
        if (user == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final hasProfileImage = user.profileImage.trim().isNotEmpty;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// 🎨 PREMIUM DYNAMIC HEADER
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 260,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? AppColors.darkNavy : AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Gradient/Pattern
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    // Decorative Circle
                    Positioned(
                      top: -50,
                      right: -50,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),

                    // User Info Column
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        /// 📸 AVATAR WITH GLOW
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.grey200,
                            backgroundImage: hasProfileImage
                                ? CachedNetworkImageProvider(user.profileImage)
                                : null,
                            child: !hasProfileImage
                                ? Icon(Iconsax.user, size: 40, color: AppColors.primary)
                                : null,
                          ),
                        ).animate().scale(duration: 400.ms, curve: Curves.bounceOut),

                        const SizedBox(height: 15),

                        Text(
                          user.fullName.isEmpty ? 'User' : user.fullName,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          user.phone,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ), Text(
                          user.email,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// 🛠 MENU SECTION
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkNavyLight : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildPremiumTile(
                      icon: Iconsax.user_edit,
                      title: AppStrings.editProfile,
                      color: Colors.blue,
                      onTap: () => Get.toNamed(AppRoutes.editProfile),
                    ),
                    _buildPremiumTile(
                      icon: Iconsax.key,
                      title: 'Change Password',
                      color: Colors.orange,
                      onTap: () => Get.toNamed(AppRoutes.changePassword),
                    ),
                    _buildPremiumTile(
                      icon: Iconsax.document_text,
                      title: "My Enquiries",
                      color: Colors.green,
                      onTap: () => Get.toNamed(AppRoutes.getEnq),
                    ),
                    _buildPremiumTile(
                        icon: Iconsax.car,
                        title: AppStrings.myListings,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                              settings: const RouteSettings(arguments: {'tabIndex': 3}),
                            ),
                          );
                        }
                    ),
                    const Divider(indent: 20, endIndent: 20, height: 1),
                    _buildPremiumTile(
                      icon: Iconsax.setting_2,
                      title: AppStrings.settings,
                      color: Colors.blueGrey,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    _buildPremiumTile(
                      icon: Iconsax.shield_tick,
                      title: "Privacy Policy",
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyWebViewScreen()),
                        );
                      },
                    ),
                    const Divider(indent: 20, endIndent: 20, height: 1),
                    _buildPremiumTile(
                      icon: Iconsax.logout,
                      title: AppStrings.logout,
                      color: Colors.red,
                      isDestructive: true,
                      onTap: () async {
                        await authController.logout();
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        );
      }),
    );
  }

  Widget _buildPremiumTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3, size: 18, color: AppColors.grey400),
    );
  }
}
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: AppSizes.iconSM,
          color: isDestructive
              ? AppColors.error
              : Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSM,
            color: isDestructive
                ? AppColors.error
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(height: AppSizes.md);
}
