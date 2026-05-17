import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Theme Controller for managing light/dark mode
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Observable theme mode
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  // Theme mode getter
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    // Initialize with system theme or saved preference
    _updateSystemUI();
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _updateSystemUI();
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set specific theme mode
  void setDarkMode(bool isDark) {
    _isDarkMode.value = isDark;
    _updateSystemUI();
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Update system UI based on theme
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      _isDarkMode.value
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Color(0xFF1A1A1A),
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
    );
  }
}
