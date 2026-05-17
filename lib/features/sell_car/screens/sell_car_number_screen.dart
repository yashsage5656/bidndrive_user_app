import 'package:bid_driving/features/sell_car/services/rc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class SellCarNumberScreen extends StatefulWidget {
  const SellCarNumberScreen({super.key});

  @override
  State<SellCarNumberScreen> createState() => _SellCarNumberScreenState();
}

class _SellCarNumberScreenState extends State<SellCarNumberScreen> {
  final _carNumberController = TextEditingController();
  bool _isLoading = false;
  final TextEditingController rcController = TextEditingController();

  @override
  void dispose() {
    _carNumberController.dispose();
    super.dispose();
  }

  void _fetchDetails() {
    final registrationNumber = _carNumberController.text.trim().toUpperCase();
    if (registrationNumber.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter car registration number',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Get.toNamed(
        AppRoutes.carCondition,
        arguments: {'registrationNumber': registrationNumber},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.md),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: AppSizes.w(25),
                        height: AppSizes.w(25),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sell_outlined,
                          size: AppSizes.iconXL,
                          color: AppColors.primary,
                        ),
                      ).animate().scale(duration: 400.ms).fadeIn(),

                      SizedBox(height: AppSizes.lg),

                      Text(
                        AppStrings.sellYourCar,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontXL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ).animate(delay: 100.ms).fadeIn(),

                      SizedBox(height: AppSizes.xs),

                      Text(
                        'Get the best price for your car within 24 hours',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          color: AppColors.textSecondary,
                        ),
                      ).animate(delay: 200.ms).fadeIn(),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.xl),

                // Car Number Input
                Text(
                  AppStrings.enterCarNumber,
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ).animate(delay: 300.ms).fadeIn(),

                SizedBox(height: AppSizes.sm),

                // Number Plate Style Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    border: Border.all(color: AppColors.grey300),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadowLight, blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Blue strip
                      Container(
                        width: AppSizes.w(10),
                        height: AppSizes.h(8),
                        decoration: BoxDecoration(
                          color: AppColors.info,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.cardRadius),
                            bottomLeft: Radius.circular(AppSizes.cardRadius),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'IND',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontXS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Input
                      Expanded(
                        child: TextField(
                          controller: rcController,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9 ]'),
                            ),
                            LengthLimitingTextInputFormatter(13),
                          ],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontLG,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'MH 02 AB 1234',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: AppSizes.fontLG,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey400,
                              letterSpacing: 2,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMD,
                              vertical: AppSizes.paddingMD,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

                SizedBox(height: AppSizes.lg),

                // Fetch Button
                CustomButton(
                  text: AppStrings.fetchDetails,
                  onPressed:  () async {
                    final rc = rcController.text.trim().toUpperCase();

                    if (rc.isEmpty) {
                      Get.snackbar("Error", "Enter RC number");
                      return;
                    }

                    // Get.back(); // close input dialog
                    //
                    // // 🔄 SHOW LOADER
                    // Get.dialog(
                    //   const Center(child: CircularProgressIndicator()),
                    //   barrierDismissible: false,
                    // );

                    try {
                      final result = await RcService.verifyRc(rc);

                      // Get.back(); // ✅ ALWAYS CLOSE LOADER

                      if (result != null) {
                        Get.toNamed(
                          AppRoutes.carCondition,
                          arguments: result,
                        );
                      }
                    } catch (e) {
                      Get.back(); // ✅ CLOSE LOADER EVEN ON ERROR

                      // 🎯 USER-FRIENDLY MESSAGE
                      String message = "Unable to fetch RC details.";

                      if (e.toString().contains("500")) {
                        message =
                        "Server is busy right now.\nPlease try again in a moment.";
                      } else if (e.toString().contains("Socket")) {
                        message = "No internet connection.";
                      }

                      showErrorDialog(message);
                    }
                  },
                  isLoading: _isLoading,
                  icon: Icons.search,
                ).animate(delay: 500.ms).fadeIn(),

                SizedBox(height: AppSizes.xl),

                // Or Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.grey300)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                      child: Text(
                        'OR',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.grey300)),
                  ],
                ),

                SizedBox(height: AppSizes.lg),

                // Manual Entry Button
                CustomButton(
                  text: 'Enter Details Manually',
                  isOutlined: true,
                  icon: Icons.edit,
                  onPressed: (){
                    Get.toNamed(
                      AppRoutes.carCondition,
                      // arguments: result,
                    );
                  }, // 👈 UPDATED
                ).animate(delay: 600.ms).fadeIn(),

                SizedBox(height: AppSizes.xl),

                // How it works
                Text(
                  'How it works',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: AppSizes.md),

                _StepItem(
                  number: '1',
                  title: 'Enter Car Details',
                  description:
                      'Share your car number and answer a few questions',
                ).animate(delay: 700.ms).fadeIn().slideX(begin: -0.1, end: 0),

                _StepItem(
                  number: '2',
                  title: 'Get Price Estimate',
                  description: 'Receive instant price quote for your car',
                ).animate(delay: 800.ms).fadeIn().slideX(begin: -0.1, end: 0),

                _StepItem(
                  number: '3',
                  title: 'Schedule Inspection',
                  description: 'Book a free inspection at your doorstep',
                ).animate(delay: 900.ms).fadeIn().slideX(begin: -0.1, end: 0),

                _StepItem(
                  number: '4',
                  title: 'Get Paid',
                  description: 'Receive payment within 24 hours of inspection',
                  isLast: true,
                ).animate(delay: 1000.ms).fadeIn().slideX(begin: -0.1, end: 0),

                SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showRcDialog() {

    Get.dialog(
      AlertDialog(
        title: const Text("Enter RC Number"),
        content: TextField(
          controller: rcController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: "Exp- MP09ZJ5990",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final rc = rcController.text.trim().toUpperCase();

              if (rc.isEmpty) {
                Get.snackbar("Error", "Enter RC number");
                return;
              }

              Get.back(); // close input dialog

              // 🔄 SHOW LOADER
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                final result = await RcService.verifyRc(rc);

                Get.back(); // ✅ ALWAYS CLOSE LOADER

                if (result != null) {
                  Get.toNamed(
                    AppRoutes.carCondition,
                    arguments: result,
                  );
                }
              } catch (e) {
                Get.back(); // ✅ CLOSE LOADER EVEN ON ERROR

                // 🎯 USER-FRIENDLY MESSAGE
                String message = "Unable to fetch RC details.";

                if (e.toString().contains("500")) {
                  message =
                  "Server is busy right now.\nPlease try again in a moment.";
                } else if (e.toString().contains("Socket")) {
                  message = "No internet connection.";
                }

                showErrorDialog(message);
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }  void showErrorDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              const Text(
                "Something went wrong",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.fontMD,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: AppColors.grey300),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
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




