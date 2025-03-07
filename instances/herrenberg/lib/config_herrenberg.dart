import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_config.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_options.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/transport_mode_config.dart';

final configHerrenberg = ConfigData(
  defaultSettings: DefaultSettings(
    walkReluctance: 3,
    walkBoardCost: 150,
  ),
  cityBike: CityBikeConfig(
    minZoomStopsNearYou: 10,
    showStationId: false,
    useSpacesAvailable: false,
    showCityBikes: true,
    networks: {
      "deer": NetworkConfig(
        icon: "brand_deer",
        operator: "deer",
        name: {"de": "deer", "en": "deer"},
        type: "car",
        formFactors: ["car"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.deer-carsharing.de/",
          "en": "https://www.deer-carsharing.de/"
        },
      ),
      "stadtmobil_stuttgart": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Stadtmobil Stuttgart", "en": "Stadtmobil Stuttgart"},
        type: "car",
        formFactors: ["car"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://stuttgart.stadtmobil.de/",
          "en": "https://stuttgart.stadtmobil.de/"
        },
      ),
      "regiorad_stuttgart": NetworkConfig(
        icon: "brand_regiorad",
        operator: "regiorad",
        name: {"de": "RegioRad Stuttgart"},
        type: "bicycle",
        formFactors: ["bicycle"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.regioradstuttgart.de",
          "en": "https://www.regioradstuttgart.de"
        },
      ),
      "bolt_stuttgart": NetworkConfig(
        icon: "brand_bolt",
        operator: "bolt",
        name: {"de": "Bolt OÜ", "en": "Bolt OÜ"},
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        hideCode: true,
        enabled: true,
        url: {"de": "https://www.bolt.eu/", "en": "https://www.bolt.eu/"},
      ),
      "bolt_reutlingen_tuebingen": NetworkConfig(
        icon: "brand_bolt",
        operator: "bolt",
        name: {"de": "Bolt OÜ", "en": "Bolt OÜ"},
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        hideCode: true,
        enabled: true,
        url: {"de": "https://www.bolt.eu/", "en": "https://www.bolt.eu/"},
      ),
      "zeus_ludwigsburg": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "zeus_pforzheim": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "zeus_tubingen": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "voi_karlsruhe": NetworkConfig(
        icon: "brand_voi",
        operator: "voi",
        name: {"de": "Voi Scooter Karlsruhe", "en": "Voi Scooter Karlsruhe"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
      ),
      "tier_ludwigsburg": NetworkConfig(
        icon: "tier_scooter",
        name: {"de": "TIER Ludwigsburg", "en": "TIER Ludwigsburg"},
        type: "scooter",
        url: {"de": "https://www.tier.app/de", "en": "https://www.tier.app/"},
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "taxi": NetworkConfig(
        icon: "brand_taxi",
        operator: "taxi",
        name: {"de": "Taxi", "en": "Taxi"},
        type: "taxi",
        formFactors: ["car"],
        hideCode: true,
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "cargo-bike": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Freie Lastenräder Herrenberg",
          "en": "Free cargo bikes Herrenberg"
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.openbikebox.stadt-herrenberg": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {"de": "Lastenrad Herrenberg", "en": "Cargo bike Herrenberg"},
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
    },
  ),
);

final configStadtnavi = ConfigData(
  showBikeAndPublicItineraries: true,
  showBikeAndParkItineraries: true,
  optimize: 'TRIANGLE',
  suggestCarMinDistance: 800,
  suggestWalkMaxDistance: 3000,
  suggestBikeAndPublicMinDistance: 3000,
  suggestBikeAndParkMinDistance: 3000,
  defaultSettings: DefaultSettings(
    optimize: 'TRIANGLE',
    safetyFactor: 0.4,
    slopeFactor: 0.3,
    timeFactor: 0.3,
    walkReluctance: 3,
    walkBoardCost: 150,
  ),
  defaultOptions: DefaultOptions(
    walkSpeed: [0.83, 1.38, 1.94],
  ),
  cityBike: CityBikeConfig(
    minZoomStopsNearYou: 10,
    showStationId: false,
    useSpacesAvailable: false,
    showCityBikes: true,
    operators: {
      "taxi": OperatorConfig(
        icon: "brand_taxi",
        name: {"de": "Taxi"},
        colors: {"background": "#FFCD00"},
      ),
      "deer": OperatorConfig(
        icon: "brand_deer",
        name: {"de": "deer"},
        url: {"de": "https://www.deer-carsharing.de/"},
        colors: {"background": "#3C8325"},
      ),
      "bolt": OperatorConfig(
        icon: "brand_bolt",
        name: {"de": "bolt"},
        colors: {"background": "#30D287"},
      ),
      "voi": OperatorConfig(
        icon: "brand_voi",
        name: {"de": "VOI"},
        colors: {"background": "#F26961"},
      ),
      "regiorad": OperatorConfig(
        icon: "brand_regiorad",
        name: {"de": "RegioRad"},
        colors: {"background": "#009fe4"},
      ),
      "stadtmobil": OperatorConfig(
        icon: "brand_stadtmobil",
        name: {"de": "stadtmobil"},
        colors: {"background": "#FF8A36"},
      ),
      "zeus": OperatorConfig(
        icon: "brand_zeus",
        name: {"de": "ZEUS Scooters", "en": "ZEUS Scooters"},
        colors: {"background": "#F75118"},
      ),
      "other": OperatorConfig(
        icon: "brand_other",
        name: {"de": "Weitere Anbieter"},
        colors: {"background": "#C84674"},
      ),
    },
    networks: {},
  ),
  transportModes: {
    "nearYouTitle": TransportModeConfig(
      nearYouLabel: {"de": "Fahrpläne und Routen"},
    ),
    "bus": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      smallIconZoom: 16,
      nearYouLabel: {"de": "Bushaltestellen in der Nähe"},
    ),
    "rail": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {"de": "Bahnhaltestellen in der Nähe"},
    ),
    "tram": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Tramhaltestellen in der Nähe"},
    ),
    "subway": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {"de": "U-Bahnhaltestellen in der Nähe"},
    ),
    "airplane": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Flughäfen in der Nähe"},
    ),
    "ferry": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Fähranleger in der Nähe"},
    ),
    "carpool": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {
        "de": "Mitfahrpunkte in der Nähe",
        "en": "Nearby carpool stops on the map",
      },
    ),
    "funicular": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
    ),
    "citybike": TransportModeConfig(
      availableForSelection: true,
      defaultValue: false,
      nearYouLabel: {
        "de": "Sharing-Angebote in der Nähe",
        "en": "Shared mobility near you",
      },
    ),
  },
  modeToOTP: {
    'carpool': 'CARPOOL',
  },
);
