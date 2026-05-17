import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:bid_driving/core/constants/app_text_style.dart';
import 'package:bid_driving/features/car_details/screens/car_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CarEnquiryScreen extends StatefulWidget {
  const CarEnquiryScreen({super.key});

  @override
  State<CarEnquiryScreen> createState() => _CarEnquiryScreenState();
}

class _CarEnquiryScreenState extends State<CarEnquiryScreen> {
  final controller = Get.find<CarController>();
  final messageController = TextEditingController();
  final priceController = TextEditingController();

  late dynamic car; // Using dynamic to match your setup

  @override
  void initState() {
    super.initState();
    car = Get.arguments;
    messageController.text = "I am interested in this car";
    priceController.text = car.price.toString();
  }

  void submit() {
    if (messageController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
      );
      return;
    }

    controller.sendCarEnquiry(
      carId: car.id,
      message: messageController.text,
      offeredPrice: int.parse(priceController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : AppColors.backgroundDark,
      appBar: AppBar(
        title: Text("Send Enquiry", style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// --- CAR PREVIEW CARD (High Contrast) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      car.image,
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${car.make} ${car.model}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Original: ₹ ${car.price}",
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// --- INPUT SECTION ---
            Text("Your Offer", style: AppTextStyles.h4.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildField(
              label: "Offer Price (₹)",
              controller: priceController,
              icon: Iconsax.money_send,
              isDark: isDark,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 20),

            _buildField(
              label: "Message to Seller",
              controller: messageController,
              icon: Iconsax.message_text,
              isDark: isDark,
              maxLines: 4,
            ),

            const SizedBox(height: 40),

            /// --- SUBMIT BUTTON ---
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "SEND ENQUIRY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? Colors.white10 : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}