class InquiryModel {
  final String id;

  /// 👤 CONTACT
  final String contactName;
  final String contactEmail;
  final String contactPhone;

  /// 🚗 CAR
  final String carName;
  final String city;
  final int price;
  final String image;

  /// 📊
  final String status;
  final String message;

  /// 👨‍💼 ADMIN
  final String adminName;

  InquiryModel({
    required this.id,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.carName,
    required this.city,
    required this.price,
    required this.image,
    required this.status,
    required this.message,
    required this.adminName,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    final car = json['carId'];

    Map<String, dynamic> basic = {};
    Map<String, dynamic> selling = {};
    List images = [];

    if (car != null && car is Map<String, dynamic>) {
      basic = car['basicDetails'] ?? {};
      selling = car['sellingDetails'] ?? {};
      images = car['images'] ?? [];
    }

    return InquiryModel(
      id: json['_id'] ?? '',

      /// 👤 CONTACT
      contactName: json['contactDetails']?['name'] ?? '',
      contactEmail: json['contactDetails']?['email'] ?? '',
      contactPhone: json['contactDetails']?['phone'] ?? '',

      /// 🚗 CAR
      carName: basic.isNotEmpty
          ? "${basic['make'] ?? ''} ${basic['model'] ?? ''}"
          : "No Car Info",

      city: selling['city'] ?? "Unknown",

      price: json['offeredPrice'] ?? 0,

      image: (images.isNotEmpty && images[0]['url'] != null)
          ? images[0]['url']
          : '',

      /// 📊
      status: json['status'] ?? '',
      message: json['message'] ?? '',

      /// 👨‍💼 ADMIN
      adminName:
      "${json['adminId']?['firstName'] ?? ''} ${json['adminId']?['lastName'] ?? ''}",
    );
  }
}