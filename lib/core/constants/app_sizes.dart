import 'package:flutter/material.dart';

/// Responsive Size Utility
/// Initialize in main.dart with AppSizes.init(context)
class AppSizes {
  AppSizes._();

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double textScaleFactor;

  /// Initialize sizes - call this in your main widget's build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    textScaleFactor = _mediaQueryData.textScaleFactor.clamp(0.8, 1.2);
  }

  // Screen Size Checks
  static bool get isSmallScreen => screenWidth < 360;
  static bool get isMediumScreen => screenWidth >= 360 && screenWidth < 400;
  static bool get isLargeScreen => screenWidth >= 400;

  // Responsive Width
  static double w(double percentage) => blockSizeHorizontal * percentage;

  // Responsive Height
  static double h(double percentage) => blockSizeVertical * percentage;

  // Safe Area Responsive Width
  static double sw(double percentage) => safeBlockHorizontal * percentage;

  // Safe Area Responsive Height
  static double sh(double percentage) => safeBlockVertical * percentage;

  // Responsive Font Size
  static double fs(double size) => size * textScaleFactor;

  // Fixed Spacing Values (responsive)
  static double get xs => w(1); // ~4px
  static double get sm => w(2); // ~8px
  static double get md => w(4); // ~16px
  static double get lg => w(6); // ~24px
  static double get xl => w(8); // ~32px
  static double get xxl => w(10); // ~40px

  // Padding
  static double get paddingXS => w(2);
  static double get paddingSM => w(3);
  static double get paddingMD => w(4);
  static double get paddingLG => w(5);
  static double get paddingXL => w(6);

  // Card & Component Sizes
  static double get cardRadius => w(3);
  static double get buttonRadius => w(2.5);
  static double get inputRadius => w(3);
  static double get chipRadius => w(5);

  // Button Heights
  static double get buttonHeightSM => h(5);
  static double get buttonHeightMD => h(6);
  static double get buttonHeightLG => h(7);

  // Icon Sizes
  static double get iconXS => w(4);
  static double get iconSM => w(5);
  static double get iconMD => w(6);
  static double get iconLG => w(8);
  static double get iconXL => w(10);

  // Avatar Sizes
  static double get avatarSM => w(10);
  static double get avatarMD => w(15);
  static double get avatarLG => w(20);
  static double get avatarXL => w(25);

  // Font Sizes (responsive)
  static double get fontXS => fs(10);
  static double get fontSM => fs(12);
  static double get fontMD => fs(14);
  static double get fontLG => fs(16);
  static double get fontXL => fs(18);
  static double get fontXXL => fs(20);
  static double get fontHeading => fs(24);
  static double get fontDisplay => fs(32);

  // Bottom Nav
  static double get bottomNavHeight => h(8);

  // App Bar Height
  static double get appBarHeight => h(7);

  // Card Heights
  static double get carCardHeight => h(28);
  static double get bannerHeight => h(22);

  // Image Sizes
  static double get carImageHeight => h(20);
  static double get thumbnailSize => w(20);
}
