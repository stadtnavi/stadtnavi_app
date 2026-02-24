import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

extension TransportModeExtension on TransportMode {
  static String? _secondaryTranslate(
    TransportMode mode,
    StadtnaviBaseLocalization localization,
  ) {
    return {
      TransportMode.airplane: null,
      TransportMode.bicycle: null,
      TransportMode.bus: null,
      TransportMode.cableCar: null,
      TransportMode.car: null,
      TransportMode.carPool: null,
      TransportMode.ferry: localization.instructionVehicleMetro,
      TransportMode.flexible: null,
      TransportMode.funicular: null,
      TransportMode.gondola: null,
      TransportMode.legSwitch: null,
      TransportMode.rail: localization.instructionVehicleLightRail,
      TransportMode.subway: localization.instructionVehicleMetro,
      TransportMode.tram: null,
      TransportMode.transit: null,
      TransportMode.walk: null,
      // route icons for specific types of transportation
      TransportMode.trufi: null,
      TransportMode.micro: null,
      TransportMode.miniBus: null,
      TransportMode.lightRail: localization.instructionVehicleLightRail,
    }[mode];
  }

  String getSecondaryTranslate(StadtnaviBaseLocalization localization) =>
      _secondaryTranslate(this, localization) ?? 'No translate';
}
