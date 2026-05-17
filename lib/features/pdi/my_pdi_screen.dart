import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:bid_driving/features/pdi/pdi_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPdiScreen extends StatelessWidget {
  const MyPdiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PdiController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Get.toNamed('/create-pdi');

      },
          label:Text('Create PDI',style: TextStyle(color: Colors.black),)

      ),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My PDI Requests"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pdiList.isEmpty) {
          return Center(
            child: Text(
              "No PDI Found",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchMyPdi,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.pdiList.length,
            itemBuilder: (context, index) {
              final item = controller.pdiList[index];

              final car = item['carDetails'];
              final location = item['location'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),

                  // 🚗 Car Title
                  title: Text(
                    "${car['make']} ${car['model']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),

                  // 📄 Details
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),

                      Text(
                        "Reg: ${car['registrationNumber']}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      Text(
                        "City: ${location['city']}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      Text(
                        "Date: ${DateTime.parse(item['preferredDate']).toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🔥 Status Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(item['status'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['status'].toString().toUpperCase(),
                          style: TextStyle(
                            color: getStatusColor(item['status']),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.grey400,
                  ),

                  onTap: () {
                    // 👉 Future: Navigate to detail screen
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // 🎨 Status Color Mapping
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return AppColors.warning;
      case "completed":
        return AppColors.success;
      case "cancelled":
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }
}