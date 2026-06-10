import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../models/user_session.dart';
import 'auth_local_storage.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    AuthLocalStorage? storage,
  }) : _client = client ?? http.Client(),
       _storage = storage ?? AuthLocalStorage.instance;

  final http.Client _client;
  final AuthLocalStorage _storage;

  Future<UserSession?>? _refreshFuture;
  Future<http.StreamedResponse> putMultipart(
      String path, {
        required Map<String, String> fields,
        Uint8List? fileBytes,
        String? fileField,
        String? fileName,
      }) async {
    final uri = ApiConstants.uri(path);

    final request = http.MultipartRequest(
      'PUT',
      uri,
    );

    final headers = await _authorizedHeaders(fields

    );

    request.headers.addAll(headers);

    request.fields.addAll(fields);

    if (fileBytes != null &&
        fileField != null &&
        fileName != null) {

      request.files.add(
        http.MultipartFile.fromBytes(
          fileField,
          fileBytes,
          filename: fileName,
        ),
      );
    }

    return await request.send();
  }
  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    return _sendAuthorized(
      requestBuilder: () async => _client.get(
        ApiConstants.uri(path),
        headers: await _authorizedHeaders(headers),
      ),
      label: 'GET $path',
    );
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendAuthorized(
      requestBuilder: () async => _client.post(
        ApiConstants.uri(path),
        headers: await _authorizedHeaders(headers),
        body: body == null
            ? null
            : body is String
            ? body
            : jsonEncode(body),
      ),
      label: 'POST $path',
    );
  }

  Future<http.Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendAuthorized(
      requestBuilder: () async => _client.put(
        ApiConstants.uri(path),
        headers: await _authorizedHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      ),
      label: 'PUT $path',
    );
  }

  Future<http.Response> sendMultipart(
    String path, {
    String method = 'POST',
    required Map<String, String> fields,
    List<http.MultipartFile>? files,
  }) async {
    return _sendAuthorized(
      requestBuilder: () async {
        final request = http.MultipartRequest(
          method,
          ApiConstants.uri(path),
        );
        request.headers.addAll(
          await _authorizedHeaders({'Content-Type': ''}),
        );
        request.fields.addAll(fields);
        if (files != null && files.isNotEmpty) {
          request.files.addAll(files);
        }

        final streamedResponse = await request.send();
        return http.Response.fromStream(streamedResponse);
      },
      label: '$method $path [multipart]',
    );
  }

  Future<Map<String, String>> authorizedHeaders({
    Map<String, String>? extra,
  }) async {
    return _authorizedHeaders(extra);
  }

  Future<http.Response> _sendAuthorized(
    {
    required Future<http.Response> Function() requestBuilder,
    required String label,
  }
  ) async {
    final currentSession = _storage.getSession();
    debugPrint(
      'ApiClient -> $label with access=${_maskToken(currentSession?.accessToken)} refresh=${_maskToken(currentSession?.refreshToken)}',
    );

    var response = await requestBuilder();
    _logResponse('ApiClient -> $label initial response', response);

    if (!_shouldRefresh(response)) {
      return response;
    }

    debugPrint(
      'ApiClient -> $label triggering refresh flow for status=${response.statusCode}',
    );
    final refreshedSession = await _refreshSession();
    if (refreshedSession == null) {
      debugPrint('ApiClient -> $label refresh failed, returning original response');
      return response;
    }

    debugPrint(
      'ApiClient -> $label retrying with access=${_maskToken(refreshedSession.accessToken)} refresh=${_maskToken(refreshedSession.refreshToken)}',
    );
    response = await requestBuilder();
    _logResponse('ApiClient -> $label retry response', response);
    return response;
  }

  Future<Map<String, String>> _authorizedHeaders(
    Map<String, String>? extra,
  ) async {
    final session = _storage.getSession();
    if (session == null || session.accessToken.isEmpty) {
      throw const ApiException('Please login to continue');
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    };

    if (extra != null) {
      headers.addAll(extra);
    }

    headers.removeWhere((key, value) => value.isEmpty);
    return headers;
  }

  Future<UserSession?> _refreshSession() async {
    _refreshFuture ??= _doRefresh();
    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<UserSession?> _doRefresh() async {
    final session = _storage.getSession();
    if (session == null || session.refreshToken.isEmpty) {
      debugPrint('ApiClient -> refresh skipped: missing refresh token');
      await _handleExpiredSession();
      return null;
    }

    try {
      debugPrint(
        'ApiClient -> refreshing session with refresh=${_maskToken(session.refreshToken)}',
      );
      final response = await _client.post(
        ApiConstants.uri(ApiConstants.refreshTokenPath),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': session.refreshToken}),
      );
      _logResponse('ApiClient -> refresh response', response);
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
      final updatedSession = session.copyWith(
        accessToken: (data['accessToken'] ?? '').toString(),
        refreshToken: (data['refreshToken'] ?? '').toString(),
      );
      debugPrint(
        'ApiClient -> refresh success access=${_maskToken(updatedSession.accessToken)} refresh=${_maskToken(updatedSession.refreshToken)}',
      );
      await _storage.saveSession(updatedSession);
      _syncController(updatedSession);
      return updatedSession;
    } on ApiException catch (error, stackTrace) {
      debugPrint('ApiClient -> refresh ApiException: ${error.message}');
      debugPrintStack(stackTrace: stackTrace);
      await _handleExpiredSession();
      return null;
    } catch (error, stackTrace) {
      debugPrint('ApiClient -> refresh unexpected error: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _handleExpiredSession();
      return null;
    }
  }

  Future<void> _handleExpiredSession() async {
    await _storage.clearSession();
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().clearInMemorySession();
    }

    if (Get.key.currentContext != null && Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void _syncController(UserSession session) {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().setSession(session);
    }
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

  bool _shouldRefresh(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      return true;
    }

    final body = response.body.toLowerCase();
    return body.contains('invalid or expired token') ||
        body.contains('invalid token') ||
        body.contains('expired token') ||
        body.contains('jwt expired') ||
        body.contains('unauthorized');
  }

  void _logResponse(String label, http.Response response) {
    debugPrint(
      '$label -> status=${response.statusCode}, body=${_truncate(response.body)}',
    );
  }

  String _truncate(String value, {int maxLength = 500}) {
    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength)}...';
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
