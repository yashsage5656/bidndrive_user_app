import 'dart:convert';
import 'package:get/get.dart';
import '../../../features/auth/services/api_client.dart';

class PdiController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  var isLoading = false.obs;
  var error = ''.obs;

  var pdiList = <dynamic>[].obs;

  // ✅ CREATE (already done)
  Future<void> createPdi(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      final response = await apiClient.post(
        '/api/pdi/create',
        body: body,
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "PDI Created");
        Get.offNamed('/my-pdi'); // 🔥 IMPORTANT
        fetchMyPdi(); // 🔥 auto refresh list
      } else {
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ GET LIST
  Future<void> fetchMyPdi() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await apiClient.get('/api/pdi/my');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        pdiList.value = data['data'];
      } else {
        error.value = data['message'] ?? "Failed to load";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchMyPdi(); // 🔥 auto load when screen opens
    super.onInit();
  }
}