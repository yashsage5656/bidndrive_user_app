import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../auth/services/api_client.dart';
import '../../auth/services/api_exception.dart';
import '../models/sell_car_enquiry_draft.dart';
import '../models/sell_car_enquiry.dart';

class SellCarService {
  SellCarService();

  Future<List<SellCarEnquiry>> fetchEnquiries() async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.get('/api/enquiries');
    final body = _parseResponseBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load your cars'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load your cars'),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'];
    if (data is! List) {
      return const <SellCarEnquiry>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(SellCarEnquiry.fromJson)
        .toList();
  }

  Future<SellCarEnquiry> fetchEnquiryDetails(String enquiryId) async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.get('/api/enquiries/$enquiryId');
    final body = _parseResponseBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load car details'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to load car details'),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Car details response was invalid');
    }

    return SellCarEnquiry.fromJson(data);
  }

  Future<String> createSellEnquiry(SellCarEnquiryDraft draft) async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.sendMultipart(
      '/api/enquiries',
      method: 'POST',
      fields: {
        'carDetails': jsonEncode(draft.carDetails),
        'enquiryType': 'sell',
        'description': draft.description,
        'sellingDetails': jsonEncode(draft.sellingDetails),
      },
      files: [
        for (final image in draft.images)
        http.MultipartFile.fromBytes(
          'enquiryImage',
          image.bytes,
          filename: image.name,
        ),
      ],
    );
    final body = _parseResponseBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to submit sell enquiry'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to submit sell enquiry'),
        statusCode: response.statusCode,
      );
    }

    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final enquiryId = (data['_id'] ?? '').toString();
    if (enquiryId.isEmpty) {
      throw const ApiException('Enquiry created but enquiry ID was missing');
    }

    return enquiryId;
  }

  Future<void> scheduleInspection({
    required String enquiryId,
    required String scheduleDate,
    required String scheduleTime,
    required String inspectionType,
    required String additionalInfo,
  }) async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.put(
      '/api/enquiries/$enquiryId/schedule',
      body: {
        'scheduleDate': scheduleDate,
        'scheduleTime': scheduleTime,
        'inspectionType': inspectionType,
        'additionalInfo': additionalInfo,
      },
    );
    final body = _parseResponseBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to schedule inspection'),
        statusCode: response.statusCode,
      );
    }

    if (body['success'] != true) {
      throw ApiException(
        _messageFromBody(body, fallback: 'Unable to schedule inspection'),
        statusCode: response.statusCode,
      );
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
}
