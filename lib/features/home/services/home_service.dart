import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../auth/services/api_exception.dart';
import '../models/home_banner.dart';

class HomeService {
  HomeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<HomeBanner>> fetchBanners() async {
    final response = await _client.get(
      ApiConstants.uri('/api/banners'),
      headers: const {'Content-Type': 'application/json'},
    );

    final body = _parseResponseBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load banners'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load banners'),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'];
    if (data is! List) {
      return const <HomeBanner>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(HomeBanner.fromJson)
        .where((banner) => banner.imageUrl.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> _parseResponseBody(http.Response response) {
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
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
}
