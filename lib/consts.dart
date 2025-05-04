class ApiConfig {
  ApiConfig._privateConstructor();

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String baseDomain = "api.dev.stadtnavi.eu"; // For dev
  // String baseDomain = "api.stadtnavi.de"; // For PROD

  String get openTripPlannerUrl => "https://$baseDomain/otp/gtfs/v1";
  String get faresURL => "https://$baseDomain/fares";
  
  String get carpoolOffers =>
      "https://dev.stadtnavi.eu/carpool-offers"; // For dev
  // String get carpoolOffers =>
  //     "https://herrenberg.stadtnavi.de/carpool-offers"; // For PROD

  String get matomo =>
      "https://track.dev.stadtnavi.eu/matomo.php"; // For dev
  // String get matomo =>
  //     "https://track.stadtnavi.de/matomo.php"; // For PROD
}
