import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  Future<String?> getDeviceToken() async {
    try {
      if (Firebase.apps.isEmpty) {
        debugPrint('FcmService -> Firebase not initialized, skipping token fetch');
        return null;
      }

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      debugPrint(
        'FcmService -> permission status: ${settings.authorizationStatus}',
      );

      final token = await messaging.getToken();
      debugPrint('FcmService -> device token: ${_maskToken(token)}');
      return token;
    } catch (error, stackTrace) {
      debugPrint('FcmService -> failed to get device token: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  String _maskToken(String? token) {
    if (token == null || token.isEmpty) {
      return 'empty';
    }

    if (token.length <= 16) {
      return token;
    }

    return '${token.substring(0, 8)}...${token.substring(token.length - 6)}';
  }
}
