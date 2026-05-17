import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InquiryDetailsScreen extends StatelessWidget {
  InquiryDetailsScreen({super.key});

  final dynamic item = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // Using your Dark Navy for a premium feel or standard light background
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkNavy : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // --- 1. HERO IMAGE WITH MINT OVERLAY ---
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.darkNavy,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _imageSection(),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.darkNavy],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 2. DETAILS CONTENT ---
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Mint Status Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.carName,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _statusChip(item.status),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Iconsax.location, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        item.city,
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Mint Price Banner
                  _buildPriceBanner(isDark),

                  const SizedBox(height: 32),

                  _sectionTitle("Inquiry Message", Iconsax.message_2),
                  const SizedBox(height: 12),
                  _buildMessageCard(isDark),

                  const SizedBox(height: 32),

                  _sectionTitle("Bidder Profile", Iconsax.user_tag),
                  const SizedBox(height: 12),
                  _buildContactInfo(isDark),

                  const SizedBox(height: 120), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.wallet_3, color: AppColors.primary),
          const SizedBox(width: 12),
          const Text(
            "Offer Price",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const Spacer(),
          Text(
            "₹${item.price}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.success, // Using your success/mint color
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildMessageCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyLight : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 10)],
      ),
      child: Text(
        item.message,
        style: TextStyle(
          height: 1.5,
          color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContactInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyLight : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _contactRow(Iconsax.user, item.name, isDark),
          const Divider(height: 30, color: AppColors.border),
          _contactRow(Iconsax.sms, item.email, isDark),
          const Divider(height: 30, color: AppColors.border),
          _contactRow(Iconsax.call, item.phone, isDark),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String val, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 16),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ],
    );
  }

  Widget _imageSection() {
    return item.image.isNotEmpty
        ? Image.network(item.image, fit: BoxFit.cover)
        : Container(color: AppColors.darkNavy, child: const Icon(Iconsax.car, color: Colors.white24, size: 60));
  }

  Widget _buildActionButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      color: isDark ? AppColors.darkNavy : AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("DECLINE", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("ACCEPT", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}