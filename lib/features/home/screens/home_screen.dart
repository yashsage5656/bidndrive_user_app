import 'dart:async';

import 'package:bid_driving/features/car_details/screens/car_controller.dart';
import 'package:bid_driving/features/home/screens/main_screen.dart';
import 'package:bid_driving/features/pdi/create_pdi_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../models/home_banner.dart';
import '../services/home_service.dart';
import '../widgets/car_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  final AuthController _authController = Get.find<AuthController>();
  final HomeService _homeService = HomeService();
  late Future<List<HomeBanner>> _bannersFuture;
  Timer? _bannerTimer;
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    _bannersFuture = _homeService.fetchBanners();
  }

  void _startAutoSlide(int length) {
    if (length <= 1) return;

    _bannerTimer?.cancel();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        _currentBanner++;

        if (_currentBanner >= length) {
          _currentBanner = 0;
        }

        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel(); // 🔥 IMPORTANT

    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _openBannerLink(String link) async {
    if (link.trim().isEmpty) {
      return;
    }

    final uri = Uri.tryParse(link.trim());
    if (uri == null) {
      Get.snackbar(
        AppStrings.error,
        'Banner link is invalid',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        AppStrings.error,
        'Unable to open banner link',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final CarController controller = Get.put(CarController());

    return Obx(() {
      final session = _authController.session;
      final userName = session?.fullName.trim().isNotEmpty == true
          ? session!.fullName
          : 'User';
      final avatarUrl = session?.profileImage.trim() ?? '';

      return Scaffold(
        backgroundColor: AppColors.background, // Clinical slate tint (#F8FAFC)
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // =====================================
              // 💎 SECTION 1: ARCHITECTURAL APP BAR
              // =====================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child:
                      Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      AppColors.primary, // 0xFF0F3073
                                      AppColors.primary.withValues(alpha: 0.1),
                                      AppColors.primary,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface,
                                  ),
                                  padding: const EdgeInsets.all(2.5),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColors.background,
                                    backgroundImage: avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    child: avatarUrl.isEmpty
                                        ? Icon(
                                            Icons.person_rounded,
                                            color: AppColors.textLight,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppStrings.namaste} 👋'.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                        // Slate 900
                                        letterSpacing: -0.5,
                                        height: 1.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.04, curve: Curves.easeOutCubic),
                ),
              ),

              // =====================================
              // 🎬 SECTION 2: SHOWROOM CAROUSEL SLIDER
              // =====================================
              SliverToBoxAdapter(
                child: FutureBuilder<List<HomeBanner>>(
                  future: _bannersFuture,
                  builder: (context, snapshot) {
                    final banners = snapshot.data ?? const <HomeBanner>[];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _startAutoSlide(banners.length);
                    });
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildBannerSkeleton();
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 190,
                          child: PageView.builder(
                            onPageChanged: (index) => _currentBanner = index,
                            controller: _bannerController,
                            itemCount: banners.length,
                            itemBuilder: (context, index) => AnimatedBuilder(
                              animation: _bannerController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_bannerController.hasClients &&
                                    _bannerController.position.haveDimensions) {
                                  value = _bannerController.page! - index;
                                  value = (1 - (value.abs() * 0.08)).clamp(
                                    0.0,
                                    1.0,
                                  );
                                } else {
                                  value = index == 0 ? 1.0 : 0.92;
                                }
                                return Center(
                                  child: SizedBox(
                                    height:
                                        Curves.easeOutCubic.transform(value) *
                                        185,
                                    width:
                                        Curves.easeOutCubic.transform(value) *
                                        Get.width,
                                    child: child,
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _BannerItem(
                                  banner: banners[index],
                                  onTap: () =>
                                      _openBannerLink(banners[index].link),
                                ),
                              ),
                            ),
                          ),
                        ).animate(delay: 150.ms).fadeIn(),
                        const SizedBox(height: 10),
                        SmoothPageIndicator(
                          controller: _bannerController,
                          count: banners.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 4,
                            dotWidth: 6,
                            expansionFactor: 3,
                            activeDotColor: AppColors.primary,
                            // Branded Blue Anchor
                            dotColor: AppColors.border,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // =====================================
              // 🕹️ SECTION 3: QUICK OPERATIONS PANEL
              // =====================================
              _buildModernHeader("Quick Operations", null),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child:
                      Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.02,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildQuickAction(
                                  Icons.directions_car_filled_rounded,
                                  'Buy Car',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MainScreen(initialIndex: 1),
                                    ),
                                  ),
                                ),
                                _buildQuickAction(
                                  Icons.sell_rounded,
                                  'Sell Car',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MainScreen(initialIndex: 2),
                                    ),
                                  ),
                                ),
                                _buildQuickAction(
                                  Icons.account_balance_wallet_rounded,
                                  'Car Loan',
                                  onTap: () => Get.toNamed('/loan'),
                                ),
                                _buildQuickAction(
                                  Icons.gpp_good_rounded,
                                  'PDI Verify',
                                  onTap: () => Get.toNamed('/my-pdi'),
                                ),
                              ],
                            ),
                          )
                          .animate(delay: 250.ms)
                          .slideY(begin: 0.1, curve: Curves.easeOutCubic)
                          .fadeIn(),
                ),
              ),

              // =====================================
              // 🏎️ SECTION 4: FEATURED VEHICLES MATRIX
              // =====================================
              _buildModernHeader(
                AppStrings.featuredCars,
                () => Get.toNamed(AppRoutes.buyCars),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (controller.allCars.isEmpty) {
                      return Center(
                        child: Text(
                          "No Vehicles Logged",
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.allCars.length,
                      itemBuilder: (context, index) {
                        final car = controller.allCars[index];
                        return Container(
                              width: 220,
                              // margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: CarCard(
                                isCompact: true,
                                car: car,
                                onTap: () => Get.toNamed(
                                  AppRoutes.carDetails,
                                  arguments: car,
                                ),
                              ),
                            )
                            .animate(delay: (300 + (index * 80)).ms)
                            .fadeIn()
                            .slideX(begin: 0.1, curve: Curves.easeOutCubic);
                      },
                    );
                  }),
                ),
              ),

              // =====================================
              // 🏷️ SECTION 5: POPULAR MANUFACTURERS GRID
              // =====================================
              _buildModernHeader(AppStrings.popularBrands, null),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= StaticData.popularBrands.length) return null;
                    return _BrandItem(brand: StaticData.popularBrands[index])
                        .animate(delay: (400 + (index * 40)).ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn();
                  }, childCount: 8),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      );
    });
  }

  // --- ENHANCED UI COMPONENTS ---

  Widget _buildGlassIconButton(IconData icon, {bool hasBadge = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(icon, color: Colors.black87, size: 26),
            if (hasBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                // Controlled uniform brand tint
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.primary, // Pure 0xFF0F3073 Anchor
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(String title, VoidCallback? onSeeAll) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 10, 0), // removed bottom gap
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: const Color(0xFF1E293B),
              ),
            ),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  "View All",
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  // --- SUPPORTING UI HELPERS ---
}

class _BannerItem extends StatelessWidget {
  final HomeBanner banner;
  final VoidCallback onTap;

  const _BannerItem({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.grey200),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.grey200,
                  child: const Icon(Icons.image),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.78),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: AppSizes.paddingLG,
                right: AppSizes.paddingLG,
                bottom: AppSizes.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   banner.title,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: AppSizes.fontXXL,
                    //     fontWeight: FontWeight.bold,
                    //     color: AppColors.white,
                    //   ),
                    // ),
                    // SizedBox(height: AppSizes.xs),
                    // Text(
                    //   banner.description,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: AppSizes.fontSM,
                    //     color: AppColors.grey300,
                    //   ),
                    // ),
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: AppSizes.w(15),
            height: AppSizes.w(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconMD),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontXS,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final Map<String, String> brand;

  const _BrandItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("CLICKED BRAND: ${brand['name']}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              initialIndex: 1,
              brand: brand['name'], // ✅ CORRECT
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSizes.iconLG,
              height: AppSizes.iconLG,
              child: CachedNetworkImage(
                imageUrl: brand['logo']!,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox(),
                errorWidget: (_, __, ___) => Icon(
                  Icons.directions_car,
                  color: AppColors.grey400,
                  size: AppSizes.iconMD,
                ),
              ),
            ),
            SizedBox(height: AppSizes.xs / 2),
            Text(
              brand['name']!.split(' ').first,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontXS,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

extension SliverExt on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
