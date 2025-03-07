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
    };

    return translations[key]?.call() ?? key;
  }
}
