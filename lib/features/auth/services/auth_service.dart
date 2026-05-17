import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../models/user_session.dart';
import 'api_client.dart';
import 'api_exception.dart';

class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    debugPrint('AuthService -> login request for $email');
    final response = await _client.post(
      ApiConstants.uri(ApiConstants.loginPath),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    debugPrint(
      'AuthService -> login response status=${response.statusCode}, body=${_truncate(response.body)}',
    );

    return _parseUserSession(response, fallback: 'Login failed');
  }

  Future<UserSession> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) async {
    debugPrint('AuthService -> register request for $email');
    final request = http.MultipartRequest(
      'POST',
      ApiConstants.uri(ApiConstants.registerPath),
    )
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['firstName'] = firstName
      ..fields['lastName'] = lastName
      ..fields['phone'] = phone;

    if (profileImageBytes != null && profileImageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'profileImage',
          profileImageBytes,
          filename: profileImageName ?? 'profile.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    debugPrint(
      'AuthService -> register response status=${response.statusCode}, body=${_truncate(response.body)}',
    );
    return _parseUserSession(response, fallback: 'Registration failed');
  }

  Future<TokenPair> refreshTokens(String refreshToken) async {
    debugPrint(
      'AuthService -> refreshTokens request refresh=${_maskToken(refreshToken)}',
    );
    final response = await _client.post(
      ApiConstants.uri(ApiConstants.refreshTokenPath),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    debugPrint(
      'AuthService -> refreshTokens response status=${response.statusCode}, body=${_truncate(response.body)}',
    );

    final body = _parseResponseBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to refresh session'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to refresh session'),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return TokenPair(
      accessToken: (data['accessToken'] ?? '').toString(),
      refreshToken: (data['refreshToken'] ?? '').toString(),
    );
  }

  Future<void> updateFcmToken(String deviceToken) async {
    final apiClient = Get.find<ApiClient>();
    debugPrint(
      'AuthService -> updateFcmToken request token=${_maskToken(deviceToken)}',
    );
    final response = await apiClient.put(
      ApiConstants.updateFcmPath,
      body: {'deviceToken': deviceToken},
    );
    debugPrint(
      'AuthService -> updateFcmToken response status=${response.statusCode}, body=${_truncate(response.body)}',
    );

    final body = _parseResponseBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to update FCM token'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to update FCM token'),
        statusCode: response.statusCode,
      );
    }
  }

  Future<UserSession> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.sendMultipart(
      ApiConstants.updateProfilePath,
      method: 'PUT',
      fields: {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      },
      files: profileImageBytes != null && profileImageBytes.isNotEmpty
          ? [
              http.MultipartFile.fromBytes(
                'profileImage',
                profileImageBytes,
                filename: profileImageName ?? 'profile.jpg',
              ),
            ]
          : null,
    );

    return _parseUserSession(response, fallback: 'Unable to update profile');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final apiClient = Get.find<ApiClient>();
    final payload = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    try {
      final response = await apiClient.post(
        ApiConstants.changePasswordPath,
        body: payload,
      );

      debugPrint(
        'changePassword -> status: ${response.statusCode}, body: ${response.body}',
      );

      final body = _parseResponseBody(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _messageFromBody(
            body,
            fallback: 'Unable to change password (${response.statusCode})',
          ),
          statusCode: response.statusCode,
        );
      }

      if (body['success'] != true) {
        throw ApiException(
          _messageFromBody(body, fallback: 'Unable to change password'),
          statusCode: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('changePassword -> error: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  UserSession _parseUserSession(
    http.Response response, {
    required String fallback,
  }) {
    final body = _parseResponseBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: fallback),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: fallback),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return UserSession.fromApiJson(data);
  }

  Map<String, dynamic> _parseResponseBody(http.Response response) {
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      return <String, dynamic>{
        'success': false,
        'message': response.body,
      };
    }

    throw const ApiException('Unexpected server response');
  }

  String _messageFromBody(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final message = body['message']?.toString().trim();
    return message == null || message.isEmpty ? fallback : message;
  }

  String _truncate(String value, {int maxLength = 500}) {
    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength)}...';
  }

  String _maskToken(String token) {
    if (token.isEmpty) {
      return 'empty';
    }

    if (token.length <= 16) {
      return token;
    }

    return '${token.substring(0, 8)}...${token.substring(token.length - 6)}';
  }
}
