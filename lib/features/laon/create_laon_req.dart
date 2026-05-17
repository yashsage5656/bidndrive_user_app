import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loan_controller.dart';

class CreateLoanScreen extends StatefulWidget {
  const CreateLoanScreen({super.key});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final LoanController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final tenureController = TextEditingController();
  final purposeController = TextEditingController();

  String carType = "new";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Loan Application", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fill in the details below to apply for a loan.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 25),

                    // --- Form Container ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel("Car Information"),
                          const SizedBox(height: 10),

                          // 🔹 Car Type Dropdown
                          DropdownButtonFormField<String>(
                            value: carType,
                            decoration: _inputDecoration("Car Category", Icons.directions_car_filled_outlined),
                            items: ["new", "used"].map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toUpperCase(), style: const TextStyle(fontSize: 15)),
                            )).toList(),
                            onChanged: (value) => setState(() => carType = value!),
                          ),

                          const SizedBox(height: 20),
                          _buildSectionLabel("Loan Details"),
                          const SizedBox(height: 10),

                          // 🔹 Amount Input
                          TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration("Loan Amount (₹)", Icons.account_balance_wallet_outlined),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Enter amount";
                              if (int.tryParse(value) == null) return "Invalid number";
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // 🔹 Tenure Input
                          TextFormField(
                            controller: tenureController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration("Tenure (Months)", Icons.calendar_month_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Enter tenure";
                              if (int.tryParse(value) == null) return "Invalid number";
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // 🔹 Purpose Input
                          TextFormField(
                            controller: purposeController,
                            maxLines: 3,
                            decoration: _inputDecoration("Purpose of Loan", Icons.description_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please state your purpose";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔥 Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {

                              final success = await controller.createLoan(
                                carType: carType,
                                amount: int.parse(amountController.text),
                                tenureMonths: int.parse(tenureController.text),
                                purpose: purposeController.text,
                              );

                              if (success) {
                                Get.offNamed('/loan'); // 🔥 go to list screen
                              }

                          }
                        },
                        child: const Text(
                          "SUBMIT APPLICATION",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔥 Smooth Loading Overlay
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // --- UI Helper Methods ---

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent[700], size: 20),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent[700],
        letterSpacing: 1.2,
      ),
    );
  }
}