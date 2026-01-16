class ItineraryOptions {
  double delayThreshold;

  ItineraryOptions({this.delayThreshold = 180.0});

  factory ItineraryOptions.fromJson(Map<String, dynamic> json) {
    return ItineraryOptions(
      delayThreshold: (json['delayThreshold'] ?? 180).toDouble(),
    );
  }
}
