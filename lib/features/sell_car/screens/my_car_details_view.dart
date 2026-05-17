import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../auth/services/api_exception.dart';
import '../models/sell_car_enquiry.dart';
import '../services/sell_car_service.dart';

class MyCarDetailsView extends StatefulWidget {
  const MyCarDetailsView({super.key});

  @override
  State<MyCarDetailsView> createState() => _MyCarDetailsViewState();
}

class _MyCarDetailsViewState extends State<MyCarDetailsView> {
  final SellCarService _sellCarService = SellCarService();
  final PageController _imageController = PageController();

  late final String _enquiryId;
  late Future<SellCarEnquiry> _detailsFuture;
  bool _didUpdateSchedule = false;

  @override
  void initState() {
    super.initState();
    _enquiryId = (Get.arguments ?? '').toString();
    _detailsFuture = _loadDetails();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<SellCarEnquiry> _loadDetails() {
    if (_enquiryId.isEmpty) {
      return Future<SellCarEnquiry>.error(
        const ApiException('Enquiry ID was missing'),
      );
    }

    return _sellCarService.fetchEnquiryDetails(_enquiryId);
  }

  Future<void> _reload() async {
    final future = _loadDetails();
    setState(() {
      _detailsFuture = future;
    });
    await future;
  }

  Future<void> _openUpdateSchedule(SellCarEnquiry enquiry) async {
    final updated = await Get.toNamed(
      AppRoutes.scheduleInspection,
      arguments: {
        'enquiryId': enquiry.id,
        'inspectionType': enquiry.inspectionType,
        'initialScheduleDate': enquiry.scheduleDate,
        'initialScheduleTime': enquiry.scheduleTime,
        'initialAddress': enquiry.additionalInfo,
        'fromMyCars': true,
      },
    );

    if (updated == true && mounted) {
      _didUpdateSchedule = true;
      await _reload();
      Get.snackbar(
        'Success',
        'Inspection schedule updated successfully',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<SellCarEnquiry>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Unable to load car details';
            return _DetailsErrorState(
              message: message,
              onRetry: _reload,
            );
          }

          final enquiry = snapshot.data;
          if (enquiry == null) {
            return _DetailsErrorState(
              message: 'Car details were not available',
              onRetry: _reload,
            );
          }

          final images = enquiry.attachments;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: AppSizes.h(34),
                      pinned: true,
                      backgroundColor: AppColors.white,
                      leading: IconButton(
                        onPressed: () => Get.back(result: _didUpdateSchedule),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            if (images.isEmpty)
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.directions_car_filled_rounded,
                                    size: AppSizes.iconXL * 1.4,
                                    color: AppColors.white,
                                  ),
                                ),
                              )
                            else
                              PageView.builder(
                                controller: _imageController,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return CachedNetworkImage(
                                    imageUrl: images[index],
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      decoration: const BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      decoration: const BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            Positioned(
                              left: AppSizes.paddingLG,
                              right: AppSizes.paddingLG,
                              bottom: AppSizes.paddingLG,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    enquiry.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontHeading,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    enquiry.registrationNumber,
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontMD,
                                      color: AppColors.white.withOpacity(0.92),
                                    ),
                                  ),
                                  if (images.length > 1) ...[
                                    SizedBox(height: AppSizes.sm),
                                    SmoothPageIndicator(
                                      controller: _imageController,
                                      count: images.length,
                                      effect: WormEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: AppColors.white,
                                        dotColor: AppColors.white.withOpacity(
                                          0.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.paddingLG),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SummaryCard(enquiry: enquiry)
                                .animate()
                                .fadeIn()
                                .slideY(begin: 0.08, end: 0),
                            SizedBox(height: AppSizes.lg),
                            _SectionCard(
                              title: 'Schedule Details',
                              children: [
                                _OverviewRow(
                                  label: 'Inspection Type',
                                  value: enquiry.inspectionType.isEmpty
                                      ? 'Not scheduled'
                                      : enquiry.inspectionType,
                                ),
                                _OverviewRow(
                                  label: 'Date',
                                  value: _formatDate(enquiry.scheduleDate),
                                ),
                                _OverviewRow(
                                  label: 'Time',
                                  value: enquiry.scheduleTime.isEmpty
                                      ? 'Not scheduled'
                                      : enquiry.scheduleTime,
                                ),
                                _OverviewRow(
                                  label: 'Address',
                                  value: enquiry.additionalInfo.isEmpty
                                      ? 'No address added'
                                      : enquiry.additionalInfo,
                                ),
                                _OverviewRow(
                                  label: 'Current Step',
                                  value: enquiry.currentStep.isEmpty
                                      ? 'initiated'
                                      : enquiry.currentStep,
                                ),
                              ],
                            ).animate(delay: 80.ms).fadeIn(),
                            SizedBox(height: AppSizes.md),
                            _SectionCard(
                              title: AppStrings.overview,
                              children: [
                                _OverviewRow(label: 'Make', value: enquiry.make),
                                _OverviewRow(label: 'Model', value: enquiry.model),
                                _OverviewRow(
                                  label: 'Year',
                                  value: enquiry.year.toString(),
                                ),
                                _OverviewRow(label: 'Color', value: enquiry.color),
                                _OverviewRow(
                                  label: 'Mileage',
                                  value: '${enquiry.mileage} km',
                                ),
                                _OverviewRow(
                                  label: 'Registration No.',
                                  value: enquiry.registrationNumber,
                                ),
                              ],
                            ).animate(delay: 140.ms).fadeIn(),
                            SizedBox(height: AppSizes.md),
                            _SectionCard(
                              title: 'Selling Details',
                              children: [
                                _OverviewRow(
                                  label: 'Expected Price',
                                  value: _formatPrice(enquiry.expectedPrice),
                                  valueColor: AppColors.primary,
                                ),
                                _OverviewRow(label: 'City', value: enquiry.city),
                                _OverviewRow(
                                  label: 'Fuel Type',
                                  value: enquiry.fuelType,
                                ),
                                _OverviewRow(
                                  label: 'Transmission',
                                  value: enquiry.transmission,
                                ),
                                _OverviewRow(
                                  label: 'Ownership',
                                  value: enquiry.ownership,
                                ),
                                _OverviewRow(
                                  label: 'Kilometers Driven',
                                  value: '${enquiry.kilometersDriven} km',
                                ),
                                _OverviewRow(
                                  label: 'Accident History',
                                  value: enquiry.accidentHistory,
                                ),
                                _OverviewRow(
                                  label: 'Service History',
                                  value: enquiry.serviceHistoryAvailable
                                      ? 'Available'
                                      : 'Not Available',
                                ),
                              ],
                            ).animate(delay: 200.ms).fadeIn(),
                            SizedBox(height: AppSizes.md),
                            _SectionCard(
                              title: 'Description',
                              children: [
                                Text(
                                  enquiry.description.isEmpty
                                      ? 'No description added.'
                                      : enquiry.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontMD,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ).animate(delay: 260.ms).fadeIn(),
                            SizedBox(height: AppSizes.xxl),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.paddingLG,
                  AppSizes.paddingSM,
                  AppSizes.paddingLG,
                  AppSizes.paddingLG,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Back to My Cars',
                        onPressed: () => Get.back(result: _didUpdateSchedule),
                        isOutlined: true,
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: CustomButton(
                        text: 'Update Schedule',
                        onPressed: () => _openUpdateSchedule(enquiry),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 100000) {
      return '${AppStrings.currency}${(price / 100000).toStringAsFixed(2)} ${AppStrings.lakh}';
    }
    return '${AppStrings.currency}$price';
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Not scheduled';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.enquiry});

  final SellCarEnquiry enquiry;

  Color _statusColor() {
    switch (enquiry.status.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMD),
      decoration: BoxDecoration(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Enquiry Summary',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontXL,
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
                  borderRadius: BorderRadius.circular(AppSizes.chipRadius),
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
          SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Expected Price',
                  value: enquiry.expectedPrice >= 100000
                      ? '${AppStrings.currency}${(enquiry.expectedPrice / 100000).toStringAsFixed(2)} ${AppStrings.lakh}'
                      : '${AppStrings.currency}${enquiry.expectedPrice}',
                  valueColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Priority',
                  value: enquiry.priority.isEmpty ? '-' : enquiry.priority,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Severity',
                  value: enquiry.severity.isEmpty ? '-' : enquiry.severity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontLG,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          ...children,
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSM,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSM,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsErrorState extends StatelessWidget {
  const _DetailsErrorState({
    required this.message,
    required this.onRetry,
  });

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
              size: AppSizes.iconXL * 1.6,
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
            CustomButton(
              text: 'Retry',
              onPressed: () => onRetry(),
            ),
          ],
        ),
      ),
    );
  }
}
