import 'stadtnavi_base_localizations.dart';

extension StadtnaviLocalizationExtension on StadtnaviBaseLocalization {
  String translate(String key) {
    final Map<String, String Function()> translations = {
      "sharingOperatorsCarHeader": () => sharingOperatorsCarHeader,
      "sharingOperatorsCargoBicycleHeader": () =>
          sharingOperatorsCargoBicycleHeader,
      "sharingOperatorsBicycleHeader": () => sharingOperatorsBicycleHeader,
      "sharingOperatorsScooterHeader": () => sharingOperatorsScooterHeader,
      "sharingOperatorsMopedHeader": () => sharingOperatorsMopedHeader,
      "taxi-availability": () => taxiAvailability,
      "bicycle-availability": () => bicycleAvailability,
      "car-availability": () => carAvailability,
      "cargoBicycle-availability": () => cargoBicycleAvailability,
      "cargo_bicycle-availability": () => cargoBicycleAvailability,
      "parkAndRide-availability": () => parkAndRideAvailability,
      "scooter-availability": () => scooterAvailability,
      "scooter-station-no-id": () => scooterStationNoId,
      "bicycle-station-no-id": () => bicycleStationNoId,
      "cargo_bicycle-station-no-id": () => cargoBicycleStationNoId,
      "car-station-no-id": () => carStationNoId,
      "taxi-station-no-id": () => taxiStationNoId,
      "regiorad-start-using": () => regioradStartUsing,
      "stadtrad-start-using": () => stadtradStartUsing,
      "scooter-start-using": () => scooterStartUsing,
      "scooter-start-using-info": () => scooterStartUsingInfo,
      "bicycle-start-using": () => bicycleStartUsing,
      "bicycle-start-using-info": () => bicycleStartUsingInfo,
      "cargo_bicycle-start-using": () => cargoBicycleStartUsing,
      "cargo_bicycle-start-using-info": () => cargoBicycleStartUsingInfo,
      "car-start-using": () => carStartUsing,
      "car-start-using-info": () => carStartUsingInfo,
    };

    return translations[key]?.call() ?? key;
  }
}
