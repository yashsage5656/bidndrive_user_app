import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/user_session.dart';
import '../services/auth_local_storage.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';

class AuthController extends GetxController {
  AuthController({
    AuthService? authService,
    AuthLocalStorage? storage,
    FcmService? fcmService,
  }) : _authService = authService ?? AuthService(),
       _storage = storage ?? AuthLocalStorage.instance,
       _fcmService = fcmService ?? FcmService();

  final AuthService _authService;
  final AuthLocalStorage _storage;
  final FcmService _fcmService;

  final Rxn<UserSession> _session = Rxn<UserSession>();

  UserSession? get session => _session.value;
  bool get isLoggedIn => _session.value != null;

  Future<void> restoreSession() async {
    final savedSession = _storage.getSession();
    if (savedSession == null) {
      _session.value = null;
      return;
    }

    try {
      final refreshedTokens = await _authService.refreshTokens(
        savedSession.refreshToken,
      );
      final updatedSession = savedSession.copyWith(
        accessToken: refreshedTokens.accessToken,
        refreshToken: refreshedTokens.refreshToken,
      );
      await _storage.saveSession(updatedSession);
      _session.value = updatedSession;
      await _syncFcmTokenIfPossible();
    } on ApiException {
      await logout();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final previousSession = _storage.getSession();
    final userSession = await _authService.login(
      email: email,
      password: password,
    );
    final mergedSession = _mergeSessionWithStoredData(
      incoming: userSession,
      previous: previousSession,
    );
    debugPrint(
      'AuthController -> login session image=${mergedSession.profileImage.isEmpty ? 'empty' : mergedSession.profileImage}',
    );
    await _persistSession(mergedSession);
    await _syncFcmTokenIfPossible();
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required bool acceptedTerms,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) async {
    if (!acceptedTerms) {
      throw const ApiException('Please accept the terms and conditions');
    }

    final userSession = await _authService.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profileImageBytes: profileImageBytes,
      profileImageName: profileImageName,
    );
    await _persistSession(userSession);
    await _syncFcmTokenIfPossible();
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) async {
    final currentSession = _session.value;
    if (currentSession == null) {
      throw const ApiException('Please login to continue');
    }

    final updatedResponse = await _authService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profileImageBytes: profileImageBytes,
      profileImageName: profileImageName,
    );

    final mergedSession = currentSession.copyWith(
      firstName: updatedResponse.firstName,
      lastName: updatedResponse.lastName,
      phone: updatedResponse.phone,
      profileImage: updatedResponse.profileImage,
      email: updatedResponse.email.isEmpty
          ? currentSession.email
          : updatedResponse.email,
      accessToken: updatedResponse.accessToken.isEmpty
          ? currentSession.accessToken
          : updatedResponse.accessToken,
      refreshToken: updatedResponse.refreshToken.isEmpty
          ? currentSession.refreshToken
          : updatedResponse.refreshToken,
      userId: updatedResponse.userId.isEmpty
          ? currentSession.userId
          : updatedResponse.userId,
    );

    await _persistSession(mergedSession);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_session.value == null) {
      throw const ApiException('Please login to continue');
    }

    await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    clearInMemorySession();
    await _storage.clearSession();
  }

  void setSession(UserSession session) {
    _session.value = session;
  }

  void clearInMemorySession() {
    _session.value = null;
  }

  Future<void> _persistSession(UserSession userSession) async {
    await _storage.saveSession(userSession);
    _session.value = userSession;
  }

  UserSession _mergeSessionWithStoredData({
    required UserSession incoming,
    UserSession? previous,
  }) {
    if (previous == null) {
      return incoming;
    }

    final isSameUser = previous.userId.isNotEmpty &&
        incoming.userId.isNotEmpty &&
        previous.userId == incoming.userId;
    final isSameEmail = previous.email.isNotEmpty &&
        incoming.email.isNotEmpty &&
        previous.email.toLowerCase() == incoming.email.toLowerCase();

    if (!isSameUser && !isSameEmail) {
      return incoming;
    }

    return incoming.copyWith(
      firstName: incoming.firstName.isEmpty ? previous.firstName : incoming.firstName,
      lastName: incoming.lastName.isEmpty ? previous.lastName : incoming.lastName,
      phone: incoming.phone.isEmpty ? previous.phone : incoming.phone,
      profileImage: incoming.profileImage.isEmpty
          ? previous.profileImage
          : incoming.profileImage,
    );
  }

  Future<void> _syncFcmTokenIfPossible() async {
    if (_session.value == null) {
      return;
    }

    try {
      final deviceToken = await _fcmService.getDeviceToken();
      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('AuthController -> FCM token unavailable, skipping update');
        return;
      }

      await _authService.updateFcmToken(deviceToken);
    } catch (error, stackTrace) {
      debugPrint('AuthController -> updateFcmToken failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
