import 'dart:convert';
import 'package:bid_driving/features/laon/loan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/services/api_client.dart';

class LoanController extends GetxController {
  var isLoading = false.obs;
  var loanList = <LoanModel>[].obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMyLoans();
    });
  }

  // ================= FETCH LOANS =================
  Future<void> fetchMyLoans() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get("/api/loans/my-loans");

      print("LOANS STATUS: ${response.statusCode}");
      print("LOANS BODY: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['success'] == true) {
          final List list = body['data'] ?? [];

          loanList.value =
              list.map((e) => LoanModel.fromJson(e)).toList();
        } else {
          _showError(body['message'] ?? "Something went wrong");
        }
      } else {
        _showError("Server Error ${response.statusCode}");
      }
    } catch (e) {
      print("❌ ERROR: $e");
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  void _showError(String message) {
    Future.microtask(() {
      Get.snackbar("Error", message);
    });
  }

  void _showSuccess(String message) {
    Future.microtask(() {
      Get.snackbar("Success", message);
    });
  }
  // ================= CREATE LOAN =================
  Future<bool> createLoan({
    required String carType,
    required int amount,
    required int tenureMonths,
    required String purpose,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        "/api/loans/create",
        body: {
          "car_type": carType,
          "amount": amount,
          "tenure_months": tenureMonths,
          "purpose": purpose,
        },
      );

      final body = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {

        _showSuccess("Loan created successfully ✅");

        await fetchMyLoans(); // 🔥 update list

        return true; // ✅ SUCCESS
      } else {
        _showError(body['message'] ?? "Failed");
        return false;
      }
    } catch (e) {
      _showError(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  // ================= TOKEN =================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ================= SAFE SNACKBARS =================
  void showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar("Error", message);
    });
  }

  void showSuccess(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar("Success", message);
    });
  }
}