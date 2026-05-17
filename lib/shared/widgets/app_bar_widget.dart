import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Custom App Bar with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double? elevation;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(AppSizes.xs),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: AppSizes.iconSM - 4,
                      color: foregroundColor ?? AppColors.textPrimary,
                    ),
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    fontSize: AppSizes.fontXL,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor ?? AppColors.textPrimary,
                  ),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight);
}

/// Transparent App Bar for screens with gradient backgrounds
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const TransparentAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: EdgeInsets.all(AppSizes.xs),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: AppSizes.iconSM - 4,
                  color: AppColors.white,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight);
}
