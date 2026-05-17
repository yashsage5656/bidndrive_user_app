import 'package:bid_driving/features/laon/loan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLoansScreen extends StatelessWidget {
  final LoanController controller = Get.put(LoanController());

  MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background for contrast
      appBar: AppBar(
        title: const Text(
          "My Loans",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/loan-req'),
        label: const Text("Request Loan"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent[700],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.loanList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "No Loans Found",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 80), // Padding for FAB
          itemCount: controller.loanList.length,
          itemBuilder: (context, index) {
            final loan = controller.loanList[index];

            // Dynamic color logic based on status
            final Color statusColor = loan.status.toLowerCase() == "pending"
                ? Colors.orange
                : Colors.green;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      // Status Indicator Strip
                      Container(width: 6, color: statusColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹${loan.amount}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      loan.status.toUpperCase(),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.directions_car_filled_outlined, "Car Type", loan.carType),
                              _buildInfoRow(Icons.calendar_today_outlined, "Tenure", "${loan.tenureMonths} Months"),
                              _buildInfoRow(Icons.description_outlined, "Purpose", loan.purpose),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Text(
                                    loan.createdAt.toLocal().toString().split(' ')[0],
                                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Helper widget to keep code clean
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey[400]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}