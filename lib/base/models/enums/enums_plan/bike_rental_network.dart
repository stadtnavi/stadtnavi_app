part of 'enums_plan.dart';

enum BikeRentalNetwork {
  taxi,
  carSharing,
  cargoBike,
  scooter,
  openbikeHerrenberg,
  regioradStuttgart,
}

BikeRentalNetwork getBikeRentalNetwork(String? value) {
  return BikeRentalNetworkExtension.values.keys.firstWhere(
    (key) => key.name == value,
    orElse: () {
      return BikeRentalNetwork.cargoBike;
    },
  );
}

extension BikeRentalNetworkExtension on BikeRentalNetwork {
  static const values = <BikeRentalNetwork, String>{
    BikeRentalNetwork.taxi: 'taxi',
    BikeRentalNetwork.carSharing: 'car-sharing',
    BikeRentalNetwork.cargoBike: 'cargo-bike',
    BikeRentalNetwork.scooter: 'tier_ludwigsburg',
    BikeRentalNetwork.openbikeHerrenberg: 'de.openbikebox.stadt-herrenberg',
    BikeRentalNetwork.regioradStuttgart:
        'de.mfdz.flinkster.cab.regiorad_stuttgart',
  };

  static final images = <BikeRentalNetwork, SvgPicture>{
    BikeRentalNetwork.taxi: SvgPicture.string(taxi),
    BikeRentalNetwork.carSharing: SvgPicture.string(carSharing),
    BikeRentalNetwork.cargoBike: SvgPicture.string(regioRad),
    BikeRentalNetwork.scooter: SvgPicture.string(scooterSvg),
    BikeRentalNetwork.openbikeHerrenberg: SvgPicture.string(regioRad),
    BikeRentalNetwork.regioradStuttgart: SvgPicture.string(regioRad),
  };

  static final colors = <BikeRentalNetwork, Color>{
    BikeRentalNetwork.taxi: const Color(0xfff1b736),
    BikeRentalNetwork.carSharing: const Color(0xffff834a),
    BikeRentalNetwork.cargoBike: const Color(0xff009fe4),
    BikeRentalNetwork.scooter: const Color(0xff0F1A50),
    BikeRentalNetwork.openbikeHerrenberg: const Color(0xff009fe4),
    BikeRentalNetwork.regioradStuttgart: const Color(0xff009fe4),
  };

  static final visibles = <BikeRentalNetwork, bool>{
    BikeRentalNetwork.taxi: false,
    BikeRentalNetwork.carSharing: false,
    BikeRentalNetwork.cargoBike: false,
    BikeRentalNetwork.scooter: true,
    BikeRentalNetwork.openbikeHerrenberg: false,
    BikeRentalNetwork.regioradStuttgart: true,
  };

  static String _translates(
    BikeRentalNetwork mode,
    TrufiBaseLocalization localization,
  ) {
    final isEn = localization.localeName == 'en';
    return {
          BikeRentalNetwork.taxi: isEn ? 'Taxi rank' : 'Taxistand',
          BikeRentalNetwork.carSharing:
              isEn ? 'Cargo bike rental station' : 'Lastenrad-Station',
          BikeRentalNetwork.cargoBike:
              isEn ? 'Cargo bike rental station' : 'Lastenrad-Station',
          BikeRentalNetwork.scooter: isEn ? 'E-Scooter' : 'e-scooter',
          BikeRentalNetwork.openbikeHerrenberg:
              isEn ? 'Cargo bike rental station' : 'Lastenrad-Station',
          BikeRentalNetwork.regioradStuttgart:
              isEn ? 'Cargo bike rental station' : 'Lastenrad-Station',
        }[mode] ??
        'errorType';
  }

  String getTranslate(TrufiBaseLocalization localization) =>
      _translates(this, localization);

  static String _translatesTitle(
    BikeRentalNetwork mode,
    TrufiBaseLocalization localization,
  ) {
    final isEn = localization.localeName == 'en';
    return {
          BikeRentalNetwork.carSharing:
              isEn ? 'Fetch a rental bike:' : 'Leihrad ausleihen:',
          BikeRentalNetwork.cargoBike:
              isEn ? 'Fetch a rental bike:' : 'Leihrad ausleihen:',
          BikeRentalNetwork.scooter: isEn ? 'Rent a kick scooter:' : 'Scooter ausleihen:',
          BikeRentalNetwork.openbikeHerrenberg:
              isEn ? 'Fetch a rental bike:' : 'Leihrad ausleihen:',
          BikeRentalNetwork.regioradStuttgart:
              isEn ? 'Fetch a rental bike:' : 'Leihrad ausleihen:',
        }[mode] ??
        'errorType';
  }

  String getTranslateTitle(TrufiBaseLocalization localization) =>
      _translatesTitle(this, localization);

  String get name => values[this] ?? 'car-sharing';

  SvgPicture get image => images[this] ?? SvgPicture.string(regioRad);

  Color get color => colors[this] ?? Colors.black;

  bool get visible => visibles[this] ?? false;
}

const defaultBikeRentalNetworks = <BikeRentalNetwork>[
  BikeRentalNetwork.taxi,
  BikeRentalNetwork.carSharing,
  BikeRentalNetwork.cargoBike,
  BikeRentalNetwork.scooter,
  BikeRentalNetwork.openbikeHerrenberg,
  BikeRentalNetwork.regioradStuttgart,
];
