import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../auth/services/api_exception.dart';
import '../models/sell_car_enquiry.dart';
import '../services/sell_car_service.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({super.key});

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  final SellCarService _sellCarService = SellCarService();
  late Future<List<SellCarEnquiry>> _enquiriesFuture;

  @override
  void initState() {
    super.initState();
    _enquiriesFuture = _sellCarService.fetchEnquiries();
  }

  Future<void> _refresh() async {
    final future = _sellCarService.fetchEnquiries();
    setState(() {
      _enquiriesFuture = future;
    });
    await future;
  }

  void _openDetails(String enquiryId) {
    Get.toNamed(AppRoutes.myCarDetails, arguments: enquiryId);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingLG),
              child: FutureBuilder<List<SellCarEnquiry>>(
                future: _enquiriesFuture,
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.myCars,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontXL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSM,
                          vertical: AppSizes.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.chipRadius,
                          ),
                        ),
                        child: Text(
                          '$count Cars',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSM,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SellCarEnquiry>>(
                future: _enquiriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    final message = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : 'Unable to load your cars';
                    return _ErrorState(message: message, onRetry: _refresh);
                  }

                  final enquiries = snapshot.data ?? const <SellCarEnquiry>[];
                  if (enquiries.isEmpty) {
                    return const _EmptyState();
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingLG,
                      ),
                      itemCount: enquiries.length,
                      itemBuilder: (context, index) {
                        final enquiry = enquiries[index];
                        return _MyCarCard(
                              enquiry: enquiry,
                              onTap: () => _openDetails(enquiry.id),
                            )
                            .animate(delay: (index * 80).ms)
                            .fadeIn()
                            .slideX(begin: -0.08, end: 0);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.sellCarNumber),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'Add Car',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _MyCarCard extends StatelessWidget {
  const _MyCarCard({required this.enquiry, required this.onTap});

  final SellCarEnquiry enquiry;
  final VoidCallback onTap;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  String _formatPrice(int price) {
    if (price >= 100000) {
      return '${AppStrings.currency}${(price / 100000).toStringAsFixed(2)} ${AppStrings.lakh}';
    }
    return '${AppStrings.currency}$price';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Recently added';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(enquiry.status);
    final hasImage = enquiry.primaryImage.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.md),
        padding: EdgeInsets.all(AppSizes.paddingMD),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  child: Container(
                    width: AppSizes.w(22),
                    height: AppSizes.w(22),
                    color: AppColors.grey100,
                    child: hasImage
                        ? CachedNetworkImage(
                            imageUrl: enquiry.primaryImage,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                              ),
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                color: AppColors.white,
                                size: AppSizes.iconLG,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                              ),
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                color: AppColors.white,
                                size: AppSizes.iconLG,
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                            child: Icon(
                              Icons.directions_car_filled_rounded,
                              color: AppColors.white,
                              size: AppSizes.iconLG,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              enquiry.title,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontMD,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingSM,
                              vertical: AppSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(
                                AppSizes.chipRadius,
                              ),
                            ),
                            child: Text(
                              enquiry.status.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontXS,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        enquiry.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        enquiry.registrationNumber,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingSM),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: 'Expected Price',
                      value: _formatPrice(enquiry.expectedPrice),
                      valueColor: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _InfoBlock(
                      label: 'City',
                      value: enquiry.city.isEmpty ? '-' : enquiry.city,
                    ),
                  ),
                  Expanded(
                    child: _InfoBlock(
                      label: 'Inspection',
                      value: enquiry.scheduleDate == null
                          ? 'Not set'
                          : _formatDate(enquiry.scheduleDate),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    enquiry.scheduleTime.isEmpty
                        ? 'Step: ${enquiry.currentStep.isEmpty ? 'initiated' : enquiry.currentStep}'
                        : 'Time: ${enquiry.scheduleTime} • ${enquiry.inspectionType.isEmpty ? 'Inspection' : enquiry.inspectionType}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontSM,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.sm),
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontXS,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.xs / 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSM,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: AppSizes.iconXL * 2,
              color: AppColors.grey400,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              'No cars listed yet',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              'Start selling by adding your first car enquiry.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontMD,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconXL * 1.8,
              color: AppColors.error,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontMD,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            ElevatedButton(
              onPressed: () => onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
