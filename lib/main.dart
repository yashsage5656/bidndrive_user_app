import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/controllers/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/services/api_client.dart';
import 'features/auth/services/auth_local_storage.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp();
    debugPrint('main -> Firebase initialized');
  } catch (error, stackTrace) {
    debugPrint('main -> Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  await AuthLocalStorage.instance.init();

  // Initialize Theme Controller
  Get.put(ThemeController());
  Get.put(AuthController(), permanent: true);
  Get.put(ApiClient(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
