import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_config.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';

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
      "stadtmobil_karlsruhe": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Stadtmobil Karlsruhe", "en": "Stadtmobil Karlsruhe"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://karlsruhe.stadtmobil.de/",
          "en": "https://karlsruhe.stadtmobil.de/"
        },
      ),
      "flinkster_carsharing": NetworkConfig(
        icon: "brand_flinkster",
        operator: "flinkster",
        name: {"de": "Flinkster", "en": "Flinkster"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.flinkster.de/de/start",
          "en": "https://www.flinkster.de/en/home",
        },
      ),
      "oekostadt_renningen": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {
          "de": "Ökostadt Renningen e.V.",
          "en": "Ökostadt Renningen e.V."
        },
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://carsharing-renningen.de/",
          "en": "https://carsharing-renningen.de/",
        },
      ),
      "teilauto_neckar-alb": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Teilauto Neckar-Alb", "en": "Teilauto Neckar-Alb"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.teilauto-neckar-alb.de/",
          "en": "https://www.teilauto-neckar-alb.de/",
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
      "zeo_bruchsal": NetworkConfig(
        icon: "brand_zeus",
        operator: "other",
        name: {"de": "Zeo Bruchsal", "en": "Zeo Bruchsal"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.zeo-carsharing.de/",
          "en": "https://www.zeo-carsharing.de/",
        },
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
      "voi_de": NetworkConfig(
        icon: "brand_voi",
        operator: "voi",
        name: {"de": "Voi Scooter", "en": "Voi Scooter"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
      ),
      "dott_boblingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Böblingen",
          "en": "Dott Böblingen",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_ludwigsburg": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Ludwigsburg",
          "en": "Dott Ludwigsburg",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_reutlingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Reutlingen",
          "en": "Dott Reutlingen",
        },
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_stuttgart": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Stuttgart",
          "en": "Dott Stuttgart",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_tubingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Tübingen",
          "en": "Dott Tübingen",
        },
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "de.stadtnavi.gbfs.alf": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Alf",
          "en": "Cargobike Alf",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.gueltstein": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Gültstein-Mobil",
          "en": "Cargobike Gültstein-Mobil",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.stadtrad": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "stadtRad der Stadt Herrenberg",
          "en": "City of Herrenberg's StadtRad",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.bananologen": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Bananologen",
          "en": "Cargobike Bananologen",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
    },
  ),
);
