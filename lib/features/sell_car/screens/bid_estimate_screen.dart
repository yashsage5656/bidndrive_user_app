import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../models/sell_car_enquiry_draft.dart';

class BidEstimateScreen extends StatelessWidget {
  const BidEstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final draft = Get.arguments is SellCarEnquiryDraft
        ? Get.arguments as SellCarEnquiryDraft
        : null;

    final car = {
      'name': draft == null ? 'Maruti Suzuki Swift' : '${draft.make} ${draft.model}',
      'model': draft == null
          ? 'VXI AMT'
          : '${draft.fuelType[0].toUpperCase()}${draft.fuelType.substring(1)} • ${draft.transmission[0].toUpperCase()}${draft.transmission.substring(1)}',
      'year': draft?.year ?? 2020,
      'estimatedPrice': 520000,
      'minPrice': 480000,
      'maxPrice': 560000,
      'image':
          'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
    };

    String formatPrice(int price) {
      if (price >= 100000) {
        return '${AppStrings.currency}${(price / 100000).toStringAsFixed(2)} ${AppStrings.lakh}';
      }
      return '${AppStrings.currency}$price';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    Container(
                          width: AppSizes.w(20),
                          height: AppSizes.w(20),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: AppSizes.iconXL,
                            color: AppColors.white,
                          ),
                        )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut)
                        .fadeIn(),
                    SizedBox(height: AppSizes.md),
                    Text(
                      'Great News!',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ).animate(delay: 200.ms).fadeIn(),
                    Text(
                      'We have an estimate for your car',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontMD,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ).animate(delay: 300.ms).fadeIn(),
                    SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -AppSizes.lg),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
                  padding: EdgeInsets.all(AppSizes.paddingMD),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                        child: draft != null && draft.images.isNotEmpty
                            ? Image.memory(
                                draft.images.first.bytes,
                                width: AppSizes.w(25),
                                height: AppSizes.h(10),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: car['image'] as String,
                                width: AppSizes.w(25),
                                height: AppSizes.h(10),
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: AppColors.grey200),
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.grey200,
                                  child: const Icon(Icons.directions_car),
                                ),
                              ),
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car['name'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontMD,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${car['model']} • ${car['year']}',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSM,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
                child: Column(
                  children: [
                    // Text(
                    //   AppStrings.estimatedPrice,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: AppSizes.fontMD,
                    //     color: AppColors.textSecondary,
                    //   ),
                    // ).animate(delay: 500.ms).fadeIn(),
                    // SizedBox(height: AppSizes.xs),
                    Text(
                      textAlign: TextAlign.center,
                      "Your pricing has been updated based on the inspection.",
                          // formatPrice(car['estimatedPrice'] as int),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                        .animate(delay: 600.ms)
                        .fadeIn()
                        .scale(begin: const Offset(0.8, 0.8)),
                    SizedBox(height: AppSizes.sm),
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: AppSizes.paddingMD,
                    //     vertical: AppSizes.paddingSM,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.primarySurface,
                    //     borderRadius: BorderRadius.circular(AppSizes.chipRadius),
                    //   ),
                    //   child: Text(
                    //     'Price range: ${formatPrice(car['minPrice'] as int)} - ${formatPrice(car['maxPrice'] as int)}',
                    //     style: GoogleFonts.poppins(
                    //       fontSize: AppSizes.fontSM,
                    //       color: AppColors.primary,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ).animate(delay: 700.ms).fadeIn(),
                    SizedBox(height: AppSizes.xl),
                    Row(
                      children: [
                        const Expanded(
                          child: _InfoCard(
                            icon: Icons.verified,
                            title: 'Free Inspection',
                            subtitle: 'At your doorstep',
                          ),
                        ),
                        SizedBox(width: AppSizes.md),
                        const Expanded(
                          child: _InfoCard(
                            icon: Icons.speed,
                            title: '24 Hours',
                            subtitle: 'Quick sale',
                          ),
                        ),
                      ],
                    ).animate(delay: 800.ms).fadeIn(),
                    SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        const Expanded(
                          child: _InfoCard(
                            icon: Icons.payments,
                            title: 'Instant Payment',
                            subtitle: 'Direct to bank',
                          ),
                        ),
                        SizedBox(width: AppSizes.md),
                        const Expanded(
                          child: _InfoCard(
                            icon: Icons.description,
                            title: 'Easy RC Transfer',
                            subtitle: 'We handle paperwork',
                          ),
                        ),
                      ],
                    ).animate(delay: 900.ms).fadeIn(),
                    SizedBox(height: AppSizes.xl),
                    CustomButton(
                      text: AppStrings.scheduleInspection,
                      icon: Icons.calendar_today,
                      onPressed: () => Get.toNamed(
                        AppRoutes.inspectionType,
                        arguments: draft,
                      ),
                    ).animate(delay: 1000.ms).fadeIn(),
                    SizedBox(height: AppSizes.md),
                    CustomButton(
                      text: 'View My Cars',
                      isOutlined: true,
                      onPressed: () => Get.toNamed(
                        AppRoutes.main,
                        arguments: {'tabIndex': 3},
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppSizes.iconMD, color: AppColors.primary),
          SizedBox(height: AppSizes.xs),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontSM,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontXS,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
