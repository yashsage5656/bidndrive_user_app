import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class InspectionStatusScreen extends StatelessWidget {
  const InspectionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    final steps = [
      {
        'title': 'Booking Confirmed',
        'status': 'completed',
        'time': 'Today, 2:30 PM',
      },
      {
        'title': 'Inspector Assigned',
        'status': 'completed',
        'time': 'Today, 3:00 PM',
      },
      {
        'title': 'On the Way',
        'status': 'current',
        'time': 'Expected: Today, 4:00 PM',
      },
      {'title': 'Inspection in Progress', 'status': 'pending', 'time': ''},
      {'title': 'Report Generated', 'status': 'pending', 'time': ''},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offAllNamed(AppRoutes.main),
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: AppSizes.iconSM,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Text(
                      'Inspection Status',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.lg),

                // Success Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.paddingLG),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppSizes.iconXL,
                        height: AppSizes.iconXL,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
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
                              'Booking Confirmed!',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontLG,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              'Tomorrow, 10:00 AM - 11:00 AM',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSM,
                                color: AppColors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.1, end: 0),

                SizedBox(height: AppSizes.lg),

                // Timeline
                Text(
                  'Tracking',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontLG,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: AppSizes.md),

                // Steps
                ...List.generate(steps.length, (index) {
                  final step = steps[index];
                  final isLast = index == steps.length - 1;

                  return _TimelineStep(
                        title: step['title']!,
                        status: step['status']!,
                        time: step['time']!,
                        isLast: isLast,
                      )
                      .animate(delay: ((index + 1) * 100).ms)
                      .fadeIn()
                      .slideX(begin: -0.1, end: 0);
                }),

                SizedBox(height: AppSizes.xl),

                // Inspector Info
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingMD),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadowLight, blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppSizes.avatarMD,
                        height: AppSizes.avatarMD,
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.grey500,
                          size: AppSizes.iconMD,
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Inspector',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontXS,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Rahul Kumar',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontMD,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: AppSizes.fontSM,
                                  color: AppColors.warning,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  '4.8 (120 inspections)',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontXS,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.call, color: AppColors.primary),
                      ),
                    ],
                  ),
                ).animate(delay: 600.ms).fadeIn(),

                SizedBox(height: AppSizes.lg),

                // Action Buttons
                CustomButton(
                  text: 'View Pre-Delivery Checklist',
                  onPressed: () => Get.toNamed(AppRoutes.preDeliveryInspection),
                ).animate(delay: 700.ms).fadeIn(),

                SizedBox(height: AppSizes.md),

                CustomButton(
                  text: 'Go to Home',
                  isOutlined: true,
                  onPressed: () => Get.offAllNamed(AppRoutes.main),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String status;
  final String time;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.status,
    required this.time,
    this.isLast = false,
  });

  Color _getColor() {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'current':
        return AppColors.primary;
      default:
        return AppColors.grey400;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'current':
        return Icons.radio_button_checked;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(_getIcon(), color: _getColor(), size: 24),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: status == 'completed'
                    ? AppColors.success
                    : AppColors.grey300,
              ),
          ],
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: status == 'current'
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: status == 'pending'
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                if (time.isNotEmpty)
                  Text(
                    time,
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontSM,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
