import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RcService {
  static Future<Map<String, dynamic>?> verifyRc(String rcNumber) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.bidndrive.in/api/cj/rc-varification"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id_number": rcNumber,
        }),
      );

      final data = jsonDecode(response.body);

      print("📥 Status Code: ${response.statusCode}");

      // ✅ HANDLE STATUS CODE FIRST
      if (response.statusCode != 200) {
        throw Exception("Server error (${response.statusCode})");
      }

      if (data["success"] == true) {
        return data["response"]["data"];
      } else {
        throw Exception(data["message"] ?? "RC verification failed");
      }
    } catch (e) {
      print("❌ API ERROR: $e");
      rethrow; // 🔥 important
    }
  }}