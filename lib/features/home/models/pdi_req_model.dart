class PdiRequestModel {
  final Map<String, dynamic> carDetails;
  final Map<String, dynamic> location;
  final String preferredDate;
  final String preferredTime;
  final String message;

  PdiRequestModel({
    required this.carDetails,
    required this.location,
    required this.preferredDate,
    required this.preferredTime,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "carDetails": carDetails,
      "location": location,
      "preferredDate": preferredDate,
      "preferredTime": preferredTime,
      "message": message,
    };
  }
}