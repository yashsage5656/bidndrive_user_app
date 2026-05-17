import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final themeController = ThemeController.to;
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        children: [
          // Appearance Section
          Text(
            'Appearance',
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontMD,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.sm),

          // Theme Toggle Card
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(
              () => ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMD,
                  vertical: AppSizes.paddingXS,
                ),
                leading: Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                  ),
                  child: Icon(
                    themeController.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColors.primary,
                    size: AppSizes.iconMD,
                  ),
                ),
                title: Text(
                  'Dark Mode',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  themeController.isDarkMode
                      ? 'Dark theme enabled'
                      : 'Light theme enabled',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontSM,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                trailing: Switch.adaptive(
                  value: themeController.isDarkMode,
                  onChanged: (value) => themeController.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSizes.xl),

          // Other Settings Section
          Text(
            'General',
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontMD,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.sm),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notifications',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.xl),

          // Logout Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: AppColors.error,
              titleColor: AppColors.error,
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await authController.logout();
                          Get.offAllNamed(AppRoutes.login);
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMD,
        vertical: AppSizes.paddingXS,
      ),
      leading: Container(
        padding: EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.sm),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: AppSizes.iconMD,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: AppSizes.fontMD,
          fontWeight: FontWeight.w500,
          color: titleColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSM,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }
}
