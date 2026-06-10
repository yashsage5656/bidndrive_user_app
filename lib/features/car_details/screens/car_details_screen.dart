import 'dart:async';

import 'package:bid_driving/features/car_details/screens/car_controller.dart';
import 'package:bid_driving/routes/app_routes.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final PageController _imageController = PageController();
  bool _isFavorite = false;
  int currentIndex = 0;

  Timer? _timer;
  // late CarModel car;
  // List<String> images = [];

  late CarModel car;
  List<String> images = [];
  @override
  void initState() {
    super.initState();

    print("🚀 INIT STATE CALLED");

    car = Get.arguments as CarModel;

    print("🚗 CAR LOADED: ${car.model}");

    images = car.images.isNotEmpty
        ? car.images
        : [
      "https://via.placeholder.com/300x200?text=No+Image"
    ];

    print("🖼 IMAGES COUNT: ${images.length}");

    _startAutoSlide();
  }

  @override
  void dispose() {
    print("🛑 DISPOSE CALLED");

    _timer?.cancel();

    print("⛔ TIMER CANCELLED");

    _imageController.dispose();

    print("📄 PAGE CONTROLLER DISPOSED");

    super.dispose();
  }

  void _startAutoSlide() {
    print("🚀 AUTO SLIDER STARTED");

    _timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {

        try {

          print("⏱ TIMER RUNNING");

          if (!mounted) {
            print("❌ SCREEN NOT MOUNTED");
            return;
          }

          print("✅ SCREEN MOUNTED");

          if (images.isEmpty) {
            print("❌ IMAGES EMPTY");
            return;
          }

          print("🖼 TOTAL IMAGES: ${images.length}");
          print("📍 CURRENT INDEX: $currentIndex");

          currentIndex =
              (currentIndex + 1) % images.length;

          print("➡️ NEW INDEX: $currentIndex");

          print("🎬 ANIMATING PAGE");

          _imageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          print("✅ PAGE ANIMATION DONE");

        } catch (e, stackTrace) {

          print("❌ AUTO SLIDE ERROR: $e");
          print("📛 STACK TRACE:");
          print(stackTrace);
        }
      },
    );
  }
  String _formatPrice(int price) {
    if (price >= 10000000) {
      return '${AppStrings.currency}${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${AppStrings.currency}${(price / 100000).toStringAsFixed(2)} ${AppStrings.lakh}';
    }
    return '${AppStrings.currency}${price.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Image Gallery App Bar
          SliverAppBar(
            expandedHeight: AppSizes.h(35),
            pinned: true,
            backgroundColor: AppColors.white,

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [

                  /// MULTIPLE IMAGES
                  PageView.builder(
                    controller: _imageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,

                        placeholder: (_, __) => Container(
                          color: AppColors.grey200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.grey200,
                          child: const Icon(
                            Icons.directions_car,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),

                  /// DOT INDICATOR
                  Positioned(
                    bottom: AppSizes.md,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _imageController,
                        count: images.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppColors.primary,
                          dotColor: AppColors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  /// IMAGE COUNT
                  Positioned(
                    bottom: AppSizes.md,
                    right: AppSizes.md,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      child: Text(
                        '${images.length} Photos',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.cardRadius * 1.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppSizes.paddingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${car.make}",

                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontXXL,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    car.model,
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontMD,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatPrice(car.price),
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontXXL,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                        SizedBox(height: AppSizes.lg),

                        // Quick Specs
                        Container(
                          padding: EdgeInsets.all(AppSizes.paddingMD),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(
                              AppSizes.cardRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _QuickSpec(
                                icon: Icons.speed,
                                label: 'Mileage',
                                value: '${car.mileage} km',
                              ),
                              _SpecDivider(),
                              _QuickSpec(
                                icon: Icons.local_gas_station,
                                label: 'Fuel',
                                value: car.fuelType,
                              ),
                              _SpecDivider(),
                              _QuickSpec(
                                icon: Icons.settings,
                                label: 'Trans',
                                value: car.transmission,
                              ),
                              _SpecDivider(),
                              _QuickSpec(
                                icon: Icons.person,
                                label: 'Owner',
                                value: car.ownership,
                              ),
                            ],
                          ),
                        ).animate(delay: 100.ms).fadeIn(),

                        SizedBox(height: AppSizes.lg),

                        // Overview Section
                        _SectionHeader(title: AppStrings.overview),
                        SizedBox(height: AppSizes.sm),

                        _OverviewItem(
                          label: 'Car Description ',
                          value: '${car.description}',
                        ),
                        _OverviewItem(
                          label: 'Car Condition ',
                          value: '${car.condition}',
                        ),
                        _OverviewItem(
                          label: 'Body Type ',
                          value: '${car.bodyType}',
                        ),
                        _OverviewItem(
                          label: 'Registration Year',
                          value: '${car.year}',
                        ),
                        _OverviewItem(label: 'Location', value: car.city),

                        _OverviewItem(label: 'Color', value: '${car.color}'),
                        _OverviewItem(
                          label: 'No of seats ',
                          value: '${car.seats}',
                        ),

                        SizedBox(height: AppSizes.lg),

                        // Features Section
                        // _SectionHeader(title: AppStrings.features),
                        // SizedBox(height: AppSizes.sm),

                        // Wrap(
                        //   spacing: AppSizes.sm,
                        //   runSpacing: AppSizes.sm,
                        //   children: [
                        //     _FeatureChip(label: 'Sunroof'),
                        //     _FeatureChip(label: 'Leather Seats'),
                        //     _FeatureChip(label: 'Navigation'),
                        //     _FeatureChip(label: 'Bluetooth'),
                        //     _FeatureChip(label: 'Parking Sensors'),
                        //     _FeatureChip(label: 'Cruise Control'),
                        //     _FeatureChip(label: 'ABS'),
                        //     _FeatureChip(label: 'Airbags'),
                        //   ],
                        // ).animate(delay: 200.ms).fadeIn(),

                        SizedBox(height: AppSizes.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSM,
          vertical: AppSizes.paddingSM,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Contact Button
              // Expanded(
              //   child: SizedBox(
              //     height: AppSizes.buttonHeightMD,
              //     child: OutlinedButton.icon(
              //       onPressed: () {},
              //       icon: Icon(Icons.call, size: AppSizes.iconSM),
              //       label: Text(
              //         'Call',
              //         style: GoogleFonts.poppins(
              //           fontSize: AppSizes.fontSM,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       style: OutlinedButton.styleFrom(
              //         foregroundColor: AppColors.primary,
              //         side: BorderSide(color: AppColors.primary),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(
              //             AppSizes.buttonRadius,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(width: AppSizes.sm),
              // Book Test Drive
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: AppSizes.buttonHeightMD,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.carEnq, arguments: car),

                    icon: Icon(
                      Icons.directions_car,
                      size: AppSizes.iconSM,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'Create Enquiry',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.buttonRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickSpec extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickSpec({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSizes.iconMD, color: AppColors.primary),
        SizedBox(height: AppSizes.xs),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontXS,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SpecDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.grey300);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: AppSizes.fontXL,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.xs,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          /// LABEL
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontMD,
                color:
                AppColors.textSecondary,
              ),
            ),
          ),

          SizedBox(width: AppSizes.sm),

          /// VALUE
          Expanded(
            flex: 5,
            child: Text(
              value.isEmpty
                  ? "N/A"
                  : value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.visible,
              softWrap: true,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontMD,
                fontWeight: FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSM,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: AppSizes.fontSM,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSizes.xs / 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontSM,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
