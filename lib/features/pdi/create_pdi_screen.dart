import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:bid_driving/features/pdi/pdi_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Assuming your AppColors file is imported here
// import 'package:your_app/core/theme/app_colors.dart';

class CreatePdiScreen extends StatefulWidget {
  const CreatePdiScreen({super.key});

  @override
  State<CreatePdiScreen> createState() => _CreatePdiScreenState();
}

class _CreatePdiScreenState extends State<CreatePdiScreen> {
  final controller = Get.find<PdiController>();

  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final regController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final messageController = TextEditingController();

  String carType = "new";

  void submit() {
    // Logic remains unchanged as requested
    final body = {
      "carDetails": {
        "make": makeController.text,
        "model": modelController.text,
        "year": int.tryParse(yearController.text) ?? 2026,
        "carType": carType,
        "registrationNumber": regController.text,
      },
      "location": {
        "address": addressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "pincode": pincodeController.text,
      },
      "preferredDate": "2026-04-20",
      "preferredTime": "14:30",
      "message": messageController.text,
    };

    controller.createPdi(body);
  }

  // --- Enhanced UI Components ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavy,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: AppColors.grey50,
      labelStyle: const TextStyle(color: AppColors.grey600),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Create PDI", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.darkNavy,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Vehicle Information"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  TextField(controller: makeController, decoration: _inputDecoration("Make", Icons.directions_car)),
                  const SizedBox(height: 15),
                  TextField(controller: modelController, decoration: _inputDecoration("Model", Icons.model_training)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: yearController, decoration: _inputDecoration("Year", Icons.calendar_today), keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: carType,
                          decoration: _inputDecoration("Type", Icons.category),
                          items: ["new", "old"].map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!))).toList(),
                          onChanged: (val) => setState(() => carType = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(controller: regController, decoration: _inputDecoration("Registration Number", Icons.confirmation_number)),
                ],
              ),
            ),

            _sectionTitle("Inspection Location"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  TextField(controller: addressController, decoration: _inputDecoration("Address", Icons.location_on)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: cityController, decoration: _inputDecoration("City", Icons.location_city))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: stateController, decoration: _inputDecoration("State", Icons.map))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(controller: pincodeController, decoration: _inputDecoration("Pincode", Icons.pin_drop), keyboardType: TextInputType.number),
                ],
              ),
            ),

            _sectionTitle("Additional Notes"),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: _inputDecoration("Message for the inspector...", Icons.chat_bubble_outline),
            ),

            const SizedBox(height: 40),

            Obx(() {
              bool loading = controller.isLoading.value;
              return Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: loading ? null : AppColors.primaryGradient,
                  color: loading ? AppColors.grey300 : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [if (!loading) BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: loading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                      : const Text(
                    "SUBMIT INSPECTION REQUEST",
                    style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}