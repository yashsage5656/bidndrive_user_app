import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:bid_driving/features/enquiries/enquiry_controller.dart';
import 'package:bid_driving/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class InquiryScreen extends StatelessWidget {
  InquiryScreen({super.key});

  final controller = Get.put(InquiryController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // AppColors.background,

      appBar: AppBar(

        title: const Text("Car Inquiries", style: TextStyle(fontWeight: FontWeight.bold)),

        centerTitle: true,

        backgroundColor:AppColors.primary,

        elevation: 0,

      ),
      backgroundColor: isDark ? AppColors.darkNavy : AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        return RefreshIndicator(
          edgeOffset: 120, // Adjusted for the expanded AppBar
          color: AppColors.primary,
          onRefresh: () => controller.fetchInquiries(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(), // Premium scroll feel
            slivers: [
              /// 🎨 STYLISH EXPANDING HEADER

              /// 📄 LIST CONTENT (SLIVER)
              if (controller.inquiryList.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(isDark))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = controller.inquiryList[index];
                        return _buildPremiumCard(item, isDark);
                      },
                      childCount: controller.inquiryList.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPremiumCard(dynamic item, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.getEnquiryDetails, arguments: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkNavyLight : AppColors.white,
          borderRadius: BorderRadius.circular(28),
          // Subtlest internal gradient for luxury feel
          gradient: isDark
              ? null
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFBFDFF)],
          ),
          // Large, soft, floating shadow for depth
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : const Color(0xFF1A1A1A).withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Decorative background hint (matching primary theme)
              Positioned(
                right: -30,
                bottom: -30,
                child: Icon(Iconsax.car5,
                    size: 120, color: AppColors.primary.withOpacity(isDark ? 0.03 : 0.02)),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    /// 🚗 IMAGE (Hero enabled)
                    Hero(
                      tag: 'car_${item.image}', // Must match details screen
                      child: Container(
                        height: 95,
                        width: 95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: item.image.isNotEmpty
                              ? Image.network(item.image, fit: BoxFit.cover)
                              : _placeholder(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    /// 📄 CONTENT DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.contactName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  letterSpacing: -0.2,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              // Date or time can go here (optional placeholder)
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.contactEmail,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Price Line
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "₹ ",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: item.price.toString(), // Consider number formatting package
                                  style: TextStyle(
                                    color: isDark ? AppColors.white : AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Handled by ${item.adminName}",
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS TAG (Top Right ribbon style)
              Positioned(
                top: 0,
                right: 0,
                child: _buildStatusChip(item.status),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// 📭 EMPTY STATE UI
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
                Iconsax.note_2,
                size: 80,
                color: isDark ? AppColors.white.withOpacity(0.2) : AppColors.grey300
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No inquiries found",
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later for new leads.",
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 🖼️ IMAGE PLACEHOLDER
  Widget _placeholder() {
    return Container(
      height: 95,
      width: 95,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Iconsax.car, color: AppColors.grey500, size: 30),
    );
  }
  Widget _buildStatusChip(String status) {
    final statusLower = status.toLowerCase();
    bool isPending = statusLower == "pending";
    bool isRejected = statusLower == "rejected";

    Color chipColor;
    if (isPending) {
      chipColor = Colors.orange;
    } else if (isRejected) {
      chipColor = AppColors.error;
    } else {
      chipColor = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
    );
  }
}