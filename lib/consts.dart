class ApiConfig {
  ApiConfig._privateConstructor();

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String baseDomain = "api.stadtnavi.eu";

  String get openTripPlannerUrl => "https://$baseDomain/otp/gtfs/v1";
  String get faresURL => "https://$baseDomain/fares";
}
