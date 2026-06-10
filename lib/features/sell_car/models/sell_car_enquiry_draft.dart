import 'dart:typed_data';

class SellCarImageAttachment {
  const SellCarImageAttachment({
    required this.bytes,
    required this.name,
  });

  final Uint8List bytes;
  final String name;
}

class SellCarEnquiryDraft {
  const SellCarEnquiryDraft({
    this.enquiryId,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.color,
    required this.expectedPrice,
    required this.city,
    required this.fuelType,
    required this.transmission,
    required this.ownership,
    required this.description,
    required this.images,
    required this.contactNumber,
  });

  final String? enquiryId;

  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final String color;

  final int expectedPrice;
  final String city;
  final String fuelType;
  final String transmission;
  final String ownership;

  final String description;
  final String contactNumber;

  final List<SellCarImageAttachment> images;

  Map<String, dynamic> get carDetails => {
    'make': make,
    'model': model,
    'year': year,
    'registrationNumber': registrationNumber,
    'color': color,
  };

  Map<String, dynamic> get sellingDetails => {
    'expectedPrice': expectedPrice,
    'city': city,
    'fuelType': fuelType,
    'transmission': transmission,
    'ownership': ownership,
    'serviceHistoryAvailable': true,
  };

  Map<String, dynamic> toJson() {
    return {
      'enquiryId': enquiryId,
      'contactNumber': contactNumber,
      'description': description,
      'carDetails': carDetails,
      'sellingDetails': sellingDetails,
    };
  }

  SellCarEnquiryDraft copyWith({
    String? enquiryId,
    String? make,
    String? model,
    int? year,
    String? registrationNumber,
    String? color,
    int? expectedPrice,
    String? city,
    String? fuelType,
    String? transmission,
    String? ownership,
    String? description,
    String? contactNumber,
    List<SellCarImageAttachment>? images,
  }) {
    return SellCarEnquiryDraft(
      enquiryId: enquiryId ?? this.enquiryId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      registrationNumber:
      registrationNumber ?? this.registrationNumber,
      color: color ?? this.color,
      expectedPrice: expectedPrice ?? this.expectedPrice,
      city: city ?? this.city,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      ownership: ownership ?? this.ownership,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return '''
SellCarEnquiryDraft(
  enquiryId: $enquiryId,
  make: $make,
  model: $model,
  year: $year,
  registrationNumber: $registrationNumber,
  color: $color,
  expectedPrice: $expectedPrice,
  city: $city,
  fuelType: $fuelType,
  transmission: $transmission,
  ownership: $ownership,
  contactNumber: $contactNumber,
  description: $description,
  images: ${images.length}
)
''';
  }
}