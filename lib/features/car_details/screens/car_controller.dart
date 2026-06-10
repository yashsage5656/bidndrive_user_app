import 'dart:convert';
import 'package:bid_driving/features/auth/services/api_client.dart';
import 'package:bid_driving/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CarController extends GetxController {
  var isLoading = false.obs;

  /// 🔥 DATA
  var allCars = <CarModel>[].obs;       // original list
  var filteredCars = <CarModel>[].obs;  // filtered list

  final ApiClient apiClient = ApiClient();

  /// 🚀 FETCH + FILTER
  Future<void> fetchCars({
    String? brand,
    String? fuel,
    String? transmission,
    int? minPrice,
    int? maxPrice,
    String? city,
    String? carType,
    int? minYear,
    int? maxYear,
    String? km,
    String? owner,
  }) async {
    try {
      isLoading.value = true;

      print("\n========= 🚀 FETCH START =========");

      final response = await apiClient.get( '/api/admin/cars?page=1&limit=100',);

      print("📡 API STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final List cars = data['data']['cars'];

          print("📦 TOTAL CARS FROM API: ${cars.length}");

          /// 🔥 PARSE
          final List<CarModel> parsedCars =
          cars.map((e) => CarModel.fromJson(e)).toList();

          /// 🔥 STORE ORIGINAL
          allCars.value = parsedCars;

          /// 🔥 FILTER
          final filtered = parsedCars.where((car) {
            bool match = true;

            /// BRAND
            if (brand != null && brand.isNotEmpty) {
              match = match &&
                  car.make.toLowerCase().contains(
                    brand.toLowerCase(),
                  );
            }

            /// FUEL
            if (fuel != null && fuel.isNotEmpty) {
              match = match &&
                  car.fuelType.toLowerCase() ==
                      fuel.toLowerCase();
            }

            /// TRANSMISSION
            if (transmission != null &&
                transmission.isNotEmpty) {
              match = match &&
                  car.transmission.toLowerCase() ==
                      transmission.toLowerCase();
            }

            /// PRICE
            if (minPrice != null) {
              match = match && car.price >= minPrice;
            }

            if (maxPrice != null) {
              match = match && car.price <= maxPrice;
            }

            /// CITY
            if (city != null && city.isNotEmpty) {
              match = match &&
                  car.city.toLowerCase() ==
                      city.toLowerCase();
            }

            /// CAR TYPE
            if (carType != null &&
                carType.isNotEmpty) {
              match = match &&
                  car.bodyType.toLowerCase() ==
                      carType.toLowerCase();
            }

            /// YEAR
            if (minYear != null) {
              match = match && car.year >= minYear;
            }

            if (maxYear != null) {
              match = match && car.year <= maxYear;
            }

            /// OWNER
            if (owner != null && owner.isNotEmpty) {
              match = match &&
                  car.ownership.toLowerCase().contains(
                    owner.toLowerCase(),
                  );
            }

            /// KM FILTER
            if (km != null && km.isNotEmpty) {
              switch (km) {
                case "0-10k":
                  match = match && car.mileage <= 10000;
                  break;

                case "10k-50k":
                  match = match &&
                      car.mileage > 10000 &&
                      car.mileage <= 50000;
                  break;

                case "50k+":
                  match = match && car.mileage > 50000;
                  break;
              }
            }

            print(
              "🔍 ${car.make} | MATCH: $match",
            );

            return match;
          }).toList();

          /// 🔥 SAVE FILTERED
          filteredCars.value = filtered;

          print("🎯 FILTERED COUNT: ${filteredCars.length}");
        } else {
          showError(data['message'] ?? "Something went wrong");
        }
      } else {
        showError("Failed to fetch cars");
      }
    } catch (e) {
      print("❌ ERROR: $e");
      showError(e.toString());
    } finally {
      isLoading.value = false;

      print("========= ✅ FETCH END =========\n");
    }
  }

  /// 🔄 CLEAR FILTER
  void clearFilters() {
    filteredCars.value = allCars;
    print("🧹 FILTER CLEARED → ${filteredCars.length} cars restored");
  }

  /// ⚠️ ERROR HANDLER
  void showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isOverlaysOpen) {
        Get.snackbar("Error", message);
      }
    });
  }

  /// 📩 ENQUIRY
  Future<void> sendCarEnquiry({
    required String carId,
    required String message,
    required int offeredPrice,
  }) async {
    try {
      final response = await apiClient.post(
        '/api/car-enquiries/cars/$carId',
        body: {
          "message": message,
          "offeredPrice": offeredPrice,
        },
      );

      print("📨 ENQUIRY STATUS: ${response.statusCode}");
      print("📨 ENQUIRY BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(AppRoutes.getEnq);
        Get.snackbar("Success", "Enquiry sent successfully");
      } else {
        Get.snackbar("Error", "Failed to send enquiry");
      }
    } catch (e) {
      print("❌ ENQUIRY ERROR: $e");
      Get.snackbar("Error", e.toString());
    }
  }
}

class CarModel {
  String id;

  /// 🚗 BASIC
  String make;
  String model;
  int year;
  int mileage;
  String registrationNumber;
  String color;

  /// 🖼 IMAGES
  List<String> images;
  String image; // first image shortcut

  /// 💰 SELLING
  int price;
  bool priceNegotiable;
  String city;
  String state;
  String pincode;
  String condition;
  String description;

  /// ⚙️ SPECS
  String fuelType;
  String transmission;
  String ownership;
  String bodyType;
  String engineCapacity;
  int seats;

  /// 📊 META
  String status;
  int viewCount;
  String createdAt;

  CarModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.registrationNumber,
    required this.color,
    required this.images,
    required this.image,
    required this.price,
    required this.priceNegotiable,
    required this.city,
    required this.state,
    required this.pincode,
    required this.condition,
    required this.description,
    required this.fuelType,
    required this.transmission,
    required this.ownership,
    required this.bodyType,
    required this.engineCapacity,
    required this.seats,
    required this.status,
    required this.viewCount,
    required this.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    final basic = json['basicDetails'] ?? {};
    final specs = json['specifications'] ?? {};
    final selling = json['sellingDetails'] ?? {};
    final imageList = json['images'] as List? ?? [];

    /// 🔥 SAFE IMAGE PARSING (FIXES YOUR ISSUE)
    final List<String> parsedImages = imageList
        .map((e) => e['url']?.toString() ?? '')
        .where((url) => url.isNotEmpty && url.startsWith('http'))
        .toList();

    return CarModel(
      id: json['_id'] ?? '',

      /// 🚗 BASIC
      make: basic['make'] ?? '',
      model: basic['model'] ?? '',
      year: basic['year'] ?? 0,
      mileage: basic['mileage'] ?? 0,
      registrationNumber: basic['registrationNumber'] ?? '',
      color: basic['color'] ?? '',

      /// 🖼 IMAGES
      images: parsedImages,
      image: parsedImages.isNotEmpty ? parsedImages.first : '',

      /// 💰 SELLING
      price: selling['expectedPrice'] ?? 0,
      priceNegotiable: selling['priceNegotiable'] ?? false,
      city: selling['city'] ?? '',
      state: selling['state'] ?? '',
      pincode: selling['pincode'] ?? '',
      condition: selling['condition'] ?? '',
      description: selling['description'] ?? '',

      /// ⚙️ SPECS
      fuelType: specs['fuelType'] ?? '',
      transmission: specs['transmission'] ?? '',
      ownership: specs['ownership'] ?? '',
      bodyType: specs['bodyType'] ?? '',
      engineCapacity: specs['engineCapacity'] ?? '',
      seats: specs['seats'] ?? 0,

      /// 📊 META
      status: json['status'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }}