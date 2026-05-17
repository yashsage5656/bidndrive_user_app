class CarEnquiry {
  const CarEnquiry({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.color,
    required this.mileage,
    required this.expectedPrice,
    required this.city,
    required this.fuelType,
    required this.transmission,
    required this.ownership,
    required this.kilometersDriven,
    required this.accidentHistory,
    required this.serviceHistoryAvailable,
    required this.enquiryType,
    required this.description,
    required this.status,
    required this.priority,
    required this.severity,
    required this.currentStep,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.inspectionType,
    required this.createdAt,
    required this.updatedAt,
    required this.customerName,
    required this.attachments,
  });

  final String id;
  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final String color;
  final int mileage;
  final int expectedPrice;
  final String city;
  final String fuelType;
  final String transmission;
  final String ownership;
  final int kilometersDriven;
  final String accidentHistory;
  final bool serviceHistoryAvailable;
  final String enquiryType;
  final String description;
  final String status;
  final String priority;
  final String severity;
  final String currentStep;
  final DateTime? scheduleDate;
  final String scheduleTime;
  final String inspectionType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String customerName;
  final List<String> attachments;

  String get title => '$make $model';

  String get subtitle => '$year • $fuelType • $transmission';

  factory CarEnquiry.fromJson(Map<String, dynamic> json) {
    final carDetails =
        json['carDetails'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final sellingDetails =
        json['sellingDetails'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final customerJourney =
        json['customerJourney'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final user = json['userId'];
    final attachments = json['attachments'];

    return CarEnquiry(
      id: (json['_id'] ?? '').toString(),
      make: (carDetails['make'] ?? '').toString(),
      model: (carDetails['model'] ?? '').toString(),
      year: _toInt(carDetails['year']),
      registrationNumber: (carDetails['registrationNumber'] ?? '').toString(),
      color: (carDetails['color'] ?? '').toString(),
      mileage: _toInt(carDetails['mileage']),
      expectedPrice: _toInt(sellingDetails['expectedPrice']),
      city: (sellingDetails['city'] ?? '').toString(),
      fuelType: (sellingDetails['fuelType'] ?? '').toString(),
      transmission: (sellingDetails['transmission'] ?? '').toString(),
      ownership: (sellingDetails['ownership'] ?? '').toString(),
      kilometersDriven: _toInt(sellingDetails['kilometersDriven']),
      accidentHistory: (sellingDetails['accidentHistory'] ?? '').toString(),
      serviceHistoryAvailable:
          sellingDetails['serviceHistoryAvailable'] == true,
      enquiryType: (json['enquiryType'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      priority: (json['priority'] ?? '').toString(),
      severity: (json['severity'] ?? '').toString(),
      currentStep: (customerJourney['currentStep'] ?? '').toString(),
      scheduleDate: _toDateTime(json['scheduleDate']),
      scheduleTime: (json['scheduleTime'] ?? '').toString(),
      inspectionType: (json['inspectionType'] ?? '').toString(),
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
      customerName: _parseCustomerName(user),
      attachments: attachments is List
          ? attachments.map((item) => item.toString()).toList()
          : const <String>[],
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDateTime(dynamic value) {
    final raw = value?.toString() ?? '';
    if (raw.isEmpty || raw == 'null') {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  static String _parseCustomerName(dynamic user) {
    if (user is! Map<String, dynamic>) {
      return '';
    }

    final firstName = (user['firstName'] ?? '').toString().trim();
    final lastName = (user['lastName'] ?? '').toString().trim();
    return '$firstName $lastName'.trim();
  }
}
