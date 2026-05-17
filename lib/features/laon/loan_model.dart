class LoanModel {
  final String id;
  final String userId;
  final String carType;
  final int amount;
  final int tenureMonths;
  final String purpose;
  final String status;
  final DateTime createdAt;

  LoanModel({
    required this.id,
    required this.userId,
    required this.carType,
    required this.amount,
    required this.tenureMonths,
    required this.purpose,
    required this.status,
    required this.createdAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      carType: json['car_type'] ?? '',
      amount: json['amount'] ?? 0,
      tenureMonths: json['tenure_months'] ?? 0,
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}