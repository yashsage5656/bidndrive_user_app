import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_session.dart';

class AuthLocalStorage {
  AuthLocalStorage._();

  static final AuthLocalStorage instance = AuthLocalStorage._();
  static const String _sessionKey = 'auth_session';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  UserSession? getSession() {
    final rawSession = _prefs?.getString(_sessionKey);
    if (rawSession == null || rawSession.isEmpty) {
      return null;
    }

    return UserSession.fromJson(
      jsonDecode(rawSession) as Map<String, dynamic>,
    );
  }

  Future<void> saveSession(UserSession session) async {
    await _prefs?.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  Future<void> clearSession() async {
    await _prefs?.remove(_sessionKey);
  }
}
