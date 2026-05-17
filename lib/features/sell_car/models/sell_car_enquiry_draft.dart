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
    required this.kilometersDriven,
    required this.expectedPrice,
    required this.city,
    required this.fuelType,
    required this.transmission,
    required this.ownership,
    required this.accidentHistory,
    required this.description,
    required this.images,
  });

  final String? enquiryId;
  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final String color;
  final int kilometersDriven;
  final int expectedPrice;
  final String city;
  final String fuelType;
  final String transmission;
  final String ownership;
  final String accidentHistory;
  final String description;
  final List<SellCarImageAttachment> images;

  Map<String, dynamic> get carDetails => {
    'make': make,
    'model': model,
    'year': year,
    'registrationNumber': registrationNumber,
    'color': color,
    'mileage': kilometersDriven,
  };

  Map<String, dynamic> get sellingDetails => {
    'expectedPrice': expectedPrice,
    'city': city,
    'fuelType': fuelType,
    'transmission': transmission,
    'ownership': ownership,
    'kilometersDriven': kilometersDriven,
    'accidentHistory': accidentHistory,
  };

  SellCarEnquiryDraft copyWith({
    String? enquiryId,
  }) {
    return SellCarEnquiryDraft(
      enquiryId: enquiryId ?? this.enquiryId,
      make: make,
      model: model,
      year: year,
      registrationNumber: registrationNumber,
      color: color,
      kilometersDriven: kilometersDriven,
      expectedPrice: expectedPrice,
      city: city,
      fuelType: fuelType,
      transmission: transmission,
      ownership: ownership,
      accidentHistory: accidentHistory,
      description: description,
      images: images,
    );
  }
}
