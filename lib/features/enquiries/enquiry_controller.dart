import 'dart:convert';

import 'package:bid_driving/features/auth/services/api_client.dart';
import 'package:bid_driving/features/auth/services/auth_local_storage.dart';
import 'package:bid_driving/features/enquiries/enquiry_model.dart';
import 'package:get/get.dart';

class InquiryController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;
  var inquiryList = <InquiryModel>[].obs;

  @override
  void onInit() {
    fetchInquiries();
    super.onInit();
  }

  Future<void> fetchInquiries() async {
    try {
      isLoading.value = true;
      // ✅ PRINT TOKEN HERE
      final session = AuthLocalStorage.instance.getSession();
      print("🟢 ACCESS TOKEN: ${session?.accessToken}");
      print("🟡 REFRESH TOKEN: ${session?.refreshToken}");

      final response = await _apiClient.get("/api/car-enquiries"); // 🔥 change path

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['success'] == true) {
          final List list = body['data'] ?? [];

          inquiryList.value =
              list.map((e) => InquiryModel.fromJson(e)).toList();
        } else {
          Get.snackbar("Error", body['message'] ?? "Something went wrong");
        }
      } else {
        Get.snackbar("Error", "Server Error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("❌ ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}