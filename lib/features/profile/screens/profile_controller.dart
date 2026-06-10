import 'dart:convert';

import 'package:bid_driving/features/auth/services/api_client.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  RxBool isLoading = false.obs;
  Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get(
        '/api/auth/profile',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {

        profile.value = ProfileModel.fromJson(
          data['data'],
        );

        print(
          "📱 MOBILE NO: ${profile.value?.phone}",
        );

      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to load profile",
        );
      }
    } catch (e) {
      print("❌ PROFILE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}


class ProfileModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String profileImage;

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.profileImage,
  });

  String get fullName => "$firstName $lastName";

  factory ProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProfileModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}