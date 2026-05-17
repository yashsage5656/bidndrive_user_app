import 'dart:async';
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

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if all fields are filled
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      _verifyOtp();
    }
  }

  void _onKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Get.offAllNamed(AppRoutes.profileSetup);
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your phone',
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
    );

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.authGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppSizes.md),

                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                          size: AppSizes.iconSM,
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideX(begin: -0.2, end: 0),

                  SizedBox(height: AppSizes.xl),

                  // Icon
                  Container(
                    width: AppSizes.w(25),
                    height: AppSizes.w(25),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.message_outlined,
                      size: AppSizes.iconXL,
                      color: AppColors.primary,
                    ),
                  ).animate().scale(duration: 400.ms).fadeIn(),

                  SizedBox(height: AppSizes.lg),

                  // Title
                  Text(
                    AppStrings.otpVerification,
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontHeading,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ).animate(delay: 100.ms).fadeIn(),

                  SizedBox(height: AppSizes.sm),

                  // Subtitle
                  Text(
                    '${AppStrings.enterOtp}\n+91 98765 43210',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontMD,
                      color: AppColors.grey400,
                      height: 1.5,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  SizedBox(height: AppSizes.xl),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: AppSizes.w(12),
                        height: AppSizes.w(14),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) => _onKeyDown(event, index),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontXXL,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.inputRadius,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.white.withOpacity(0.2),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.inputRadius,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.white.withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.inputRadius,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onOtpChanged(value, index),
                          ),
                        ),
                      );
                    }),
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  SizedBox(height: AppSizes.xl),

                  // Timer / Resend
                  _canResend
                      ? GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            AppStrings.resendOtp,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontMD,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: '${AppStrings.resendIn} ',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontMD,
                              color: AppColors.grey400,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                  SizedBox(height: AppSizes.xl),

                  // Verify Button
                  CustomButton(
                    text: AppStrings.verify,
                    onPressed: _isLoading ? null : _verifyOtp,
                    isLoading: _isLoading,
                  ).animate(delay: 400.ms).fadeIn(),

                  SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
