import 'package:flutter/material.dart';

/// Transport mode enum for stadtnavi OTP integration.
/// Replaces trufi_core's TransportMode within the OTP module.
enum TransportMode {
  error,
  airplane,
  bicycle,
  bus,
  cableCar,
  car,
  carPool,
  ferry,
  flexible,
  funicular,
  gondola,
  legSwitch,
  rail,
  subway,
  tram,
  transit,
  walk,
  trufi,
  micro,
  miniBus,
  lightRail,
}

const defaultTransportModes = <TransportMode>[
  TransportMode.bus,
  TransportMode.rail,
  TransportMode.subway,
  TransportMode.walk,
];

TransportMode getTransportMode({
  required String mode,
  String? specificTransport,
}) {
  TransportMode value = TransportMode.walk;
  if (specificTransport != null) {
    final String enumType = specificTransport.toUpperCase();
    value = enumType.contains(TransportMode.trufi.name)
        ? TransportMode.trufi
        : enumType.contains(TransportMode.micro.name)
            ? TransportMode.bus
            : enumType.contains(TransportMode.miniBus.name)
                ? TransportMode.miniBus
                : enumType.contains(TransportMode.gondola.name)
                    ? TransportMode.gondola
                    : enumType.contains(TransportMode.lightRail.name)
                        ? TransportMode.lightRail
                        : _getTransportModeByMode(mode);
  } else {
    value = _getTransportModeByMode(mode);
  }
  return value;
}

TransportMode _getTransportModeByMode(String mode) {
  return TransportModeExtension.names.keys.firstWhere(
    (key) => key.name == mode,
    orElse: () => TransportMode.walk,
  );
}

extension TransportModeExtension on TransportMode {
  static const names = <TransportMode, String>{
    TransportMode.error: "ERROR",
    TransportMode.airplane: "AIRPLANE",
    TransportMode.bicycle: "BICYCLE",
    TransportMode.bus: "BUS",
    TransportMode.cableCar: "CABLE_CAR",
    TransportMode.car: "CAR",
    TransportMode.carPool: "CARPOOL",
    TransportMode.ferry: "FERRY",
    TransportMode.flexible: "FLEXIBLE",
    TransportMode.funicular: "FUNICULAR",
    TransportMode.gondola: "GONDOLA",
    TransportMode.legSwitch: "LEG_SWITCH",
    TransportMode.rail: "RAIL",
    TransportMode.subway: "SUBWAY",
    TransportMode.tram: "TRAM",
    TransportMode.transit: "TRANSIT",
    TransportMode.walk: "WALK",
    TransportMode.trufi: "TRUFI",
    TransportMode.micro: "MICRO",
    TransportMode.miniBus: "MINIBUS",
    TransportMode.lightRail: "LIGHT RAIL",
  };

  static const _icons = <TransportMode, IconData?>{
    TransportMode.airplane: Icons.airplanemode_active,
    TransportMode.bicycle: Icons.directions_bike,
    TransportMode.bus: Icons.directions_bus,
    TransportMode.cableCar: null,
    TransportMode.car: Icons.drive_eta,
    TransportMode.carPool: Icons.drive_eta,
    TransportMode.ferry: Icons.directions_ferry,
    TransportMode.flexible: Icons.warning,
    TransportMode.funicular: null,
    TransportMode.gondola: null,
    TransportMode.legSwitch: Icons.warning,
    TransportMode.rail: Icons.train,
    TransportMode.subway: Icons.directions_subway,
    TransportMode.tram: Icons.warning,
    TransportMode.transit: Icons.directions_transit,
    TransportMode.walk: Icons.directions_walk,
    TransportMode.trufi: Icons.local_taxi,
    TransportMode.micro: Icons.directions_bus,
    TransportMode.miniBus: Icons.airport_shuttle,
    TransportMode.lightRail: Icons.train,
  };

  static final _defaultColors = <TransportMode, Color?>{
    TransportMode.airplane: null,
    TransportMode.bicycle: const Color(0xff666666),
    TransportMode.bus: const Color(0xffff260c),
    TransportMode.cableCar: null,
    TransportMode.car: Colors.black,
    TransportMode.carPool: const Color(0xff9fc726),
    TransportMode.ferry: null,
    TransportMode.flexible: null,
    TransportMode.funicular: null,
    TransportMode.gondola: null,
    TransportMode.legSwitch: null,
    TransportMode.rail: const Color(0xff018000),
    TransportMode.subway: Colors.blueAccent[700],
    TransportMode.tram: null,
    TransportMode.transit: null,
    TransportMode.walk: Colors.grey[700],
    TransportMode.trufi: const Color(0xffd81b60),
    TransportMode.micro: const Color(0xffd81b60),
    TransportMode.miniBus: const Color(0xffd81b60),
    TransportMode.lightRail: const Color(0xffd81b60),
  };

  static final _defaultBackgroundColors = <TransportMode, Color?>{
    TransportMode.airplane: null,
    TransportMode.bicycle: Colors.grey[200],
    TransportMode.bus: const Color(0xffff260c),
    TransportMode.cableCar: null,
    TransportMode.car: Colors.black,
    TransportMode.carPool: const Color(0xff9fc726),
    TransportMode.ferry: const Color(0xff1B3661),
    TransportMode.flexible: null,
    TransportMode.funicular: null,
    TransportMode.gondola: null,
    TransportMode.legSwitch: null,
    TransportMode.rail: const Color(0xff018000),
    TransportMode.subway: Colors.blueAccent[700],
    TransportMode.tram: null,
    TransportMode.transit: null,
    TransportMode.walk: Colors.grey[200],
    TransportMode.trufi: const Color(0xffd81b60),
    TransportMode.micro: const Color(0xffd81b60),
    TransportMode.miniBus: const Color(0xffd81b60),
    TransportMode.lightRail: const Color(0xffd81b60),
  };

  static const qualifiers = <TransportMode, String>{
    TransportMode.bicycle: 'RENT',
  };

  static final visibleSettings = <TransportMode, bool>{
    TransportMode.error: false,
    TransportMode.airplane: false,
    TransportMode.bicycle: false,
    TransportMode.bus: true,
    TransportMode.cableCar: false,
    TransportMode.car: false,
    TransportMode.carPool: true,
    TransportMode.ferry: false,
    TransportMode.flexible: false,
    TransportMode.funicular: false,
    TransportMode.gondola: false,
    TransportMode.legSwitch: false,
    TransportMode.rail: true,
    TransportMode.subway: true,
    TransportMode.tram: false,
    TransportMode.transit: false,
    TransportMode.walk: false,
    TransportMode.trufi: false,
    TransportMode.micro: false,
    TransportMode.miniBus: false,
    TransportMode.lightRail: false,
  };

  String get name => names[this] ?? 'ERROR';
  String? get qualifier => qualifiers[this];

  Color get color =>
      _defaultColors[this] ?? const Color(0xff1B3661);

  Color get backgroundColor =>
      _defaultBackgroundColors[this] ?? const Color(0xff1B3661);

  Widget getImage({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child: _icons[this] != null
            ? Icon(
                _icons[this],
                color: color ?? this.color,
              )
            : const Icon(
                Icons.error,
                color: Colors.red,
              ),
      ),
    );
  }

  bool get visible => visibleSettings[this] ?? false;
}
