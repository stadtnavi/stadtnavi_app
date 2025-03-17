import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';


class CarSharingFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String id;
  final String? networkId;
  final Network? network;
  final String? name;
  final String? formFactors;
  final int? vehiclesAvailable;
  final int? spacesAvailable;
  final bool? operative;

  final LatLng position;
  CarSharingFeature({
    required this.geoJsonPoint,
    required this.id,
    required this.networkId,
    required this.network,
    required this.name,
    required this.formFactors,
    required this.vehiclesAvailable,
    required this.spacesAvailable,
    required this.operative,
    required this.position,
  });
  static CarSharingFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    String? id = properties['id']?.dartStringValue;
    if (id == null) return null;
    String? networkId = properties['network']?.dartStringValue;
 Network? network=networks[networkId];
    String? name = properties['name']?.dartStringValue;
    String? formFactors = properties['formFactors']?.dartStringValue;
    int? vehiclesAvailable =
        properties['vehiclesAvailable']?.dartIntValue?.toInt();
    int? spacesAvailable = properties['spacesAvailable']?.dartIntValue?.toInt();
    bool? operative = properties['operative']?.dartBoolValue;
    return CarSharingFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      networkId: networkId,
      network: network,
      name: name,
      formFactors: formFactors,
      vehiclesAvailable: vehiclesAvailable,
      spacesAvailable: spacesAvailable,
      operative: operative,
      position: LatLng(
        geoJsonPoint?.geometry?.coordinates[1] ?? 0,
        geoJsonPoint?.geometry?.coordinates[0] ?? 0,
      ),
    );
  }
}
class Network {
  final String icon;
  final String operatorName;
  final Name name;
  final String type;
  final List<String>? formFactors;
  final bool hideCode;
  final bool enabled;
  final Url? url;
  final bool? visibleInSettingsUi;
  final Season? season;

  Network({
    required this.icon,
    required this.operatorName,
    required this.name,
    required this.type,
    this.formFactors,
    required this.hideCode,
    required this.enabled,
    this.url,
    this.visibleInSettingsUi,
    this.season,
  });
}

class Name {
  final String de;
  final String? en;

  Name({required this.de, this.en});
}

class Url {
  final String de;
  final String? en;

  Url({required this.de, this.en});
}

class Season {
  final DateTime start;
  final DateTime end;
  final DateTime preSeasonStart;

  Season({
    required this.start,
    required this.end,
    required this.preSeasonStart,
  });
}

final Map<String, Network> networks = {
  // deer
  "deer": Network(
    icon: "brand_deer",
    operatorName: "deer",
    name: Name(de: "deer", en: "deer"),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.deer-carsharing.de/",
      en: "https://www.deer-carsharing.de/",
    ),
  ),

  // stadtmobil_stuttgart
  "stadtmobil_stuttgart": Network(
    icon: "brand_stadtmobil",
    operatorName: "stadtmobil",
    name: Name(
      de: "Stadtmobil Stuttgart",
      en: "Stadtmobil Stuttgart",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://stuttgart.stadtmobil.de/",
      en: "https://stuttgart.stadtmobil.de/",
    ),
  ),

  // stadtmobil_karlsruhe
  "stadtmobil_karlsruhe": Network(
    icon: "brand_stadtmobil",
    operatorName: "stadtmobil",
    name: Name(
      de: "Stadtmobil Karlsruhe",
      en: "Stadtmobil Karlsruhe",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://karlsruhe.stadtmobil.de/",
      en: "https://karlsruhe.stadtmobil.de/",
    ),
  ),

  // flinkster_carsharing
  "flinkster_carsharing": Network(
    icon: "brand_flinkster",
    operatorName: "flinkster",
    name: Name(
      de: "Flinkster",
      en: "Flinkster",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.flinkster.de/de/start",
      en: "https://www.flinkster.de/en/home",
    ),
  ),

  // oekostadt_renningen
  "oekostadt_renningen": Network(
    icon: "brand_stadtmobil",
    operatorName: "stadtmobil",
    name: Name(
      de: "Ökostadt Renningen e.V.",
      en: "Ökostadt Renningen e.V.",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://carsharing-renningen.de/",
      en: "https://carsharing-renningen.de/",
    ),
  ),

  // teilauto_neckar-alb
  "teilauto_neckar-alb": Network(
    icon: "brand_stadtmobil",
    operatorName: "stadtmobil",
    name: Name(
      de: "Teilauto Neckar-Alb",
      en: "Teilauto Neckar-Alb",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.teilauto-neckar-alb.de/",
      en: "https://www.teilauto-neckar-alb.de/",
    ),
  ),

  // regiorad_stuttgart
  "regiorad_stuttgart": Network(
    icon: "brand_regiorad",
    operatorName: "regiorad",
    name: Name(
      de: "RegioRad Stuttgart",
      // No "en" en el original, se agrega si se desea
      en: "RegioRad Stuttgart",
    ),
    type: "bicycle",
    formFactors: ["bicycle"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.regioradstuttgart.de",
      en: "https://www.regioradstuttgart.de",
    ),
  ),

  // bolt_stuttgart
  "bolt_stuttgart": Network(
    icon: "brand_bolt",
    operatorName: "bolt",
    name: Name(
      de: "Bolt OÜ",
      en: "Bolt OÜ",
    ),
    type: "scooter",
    formFactors: ["scooter", "bicycle"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.bolt.eu/",
      en: "https://www.bolt.eu/",
    ),
  ),

  // bolt_reutlingen_tuebingen
  "bolt_reutlingen_tuebingen": Network(
    icon: "brand_bolt",
    operatorName: "bolt",
    name: Name(
      de: "Bolt OÜ",
      en: "Bolt OÜ",
    ),
    type: "scooter",
    formFactors: ["scooter", "bicycle"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.bolt.eu/",
      en: "https://www.bolt.eu/",
    ),
  ),

  // zeo_bruchsal
  "zeo_bruchsal": Network(
    icon: "brand_zeus",
    operatorName: "other",
    name: Name(
      de: "Zeo Bruchsal",
      en: "Zeo Bruchsal",
    ),
    type: "car",
    formFactors: ["car"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://www.zeo-carsharing.de/",
      en: "https://www.zeo-carsharing.de/",
    ),
  ),

  // zeus_ludwigsburg
  "zeus_ludwigsburg": Network(
    icon: "brand_zeus",
    operatorName: "zeus",
    name: Name(
      de: "Zeus Scooters",
      en: "Zeus Scooters",
    ),
    type: "scooter",
    formFactors: ["scooter"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://zeusscooters.com",
      en: "https://zeusscooters.com",
    ),
  ),

  // zeus_pforzheim
  "zeus_pforzheim": Network(
    icon: "brand_zeus",
    operatorName: "zeus",
    name: Name(
      de: "Zeus Scooters",
      en: "Zeus Scooters",
    ),
    type: "scooter",
    formFactors: ["scooter"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://zeusscooters.com",
      en: "https://zeusscooters.com",
    ),
  ),

  // zeus_tubingen
  "zeus_tubingen": Network(
    icon: "brand_zeus",
    operatorName: "zeus",
    name: Name(
      de: "Zeus Scooters",
      en: "Zeus Scooters",
    ),
    type: "scooter",
    formFactors: ["scooter"],
    hideCode: true,
    enabled: true,
    url: Url(
      de: "https://zeusscooters.com",
      en: "https://zeusscooters.com",
    ),
  ),

  // voi_de
  "voi_de": Network(
    icon: "brand_voi",
    operatorName: "voi",
    name: Name(
      de: "Voi Scooter",
      en: "Voi Scooter",
    ),
    type: "scooter",
    // No se especifican formFactors en el original
    hideCode: true,
    enabled: true,
  ),

  // dott_boblingen
  "dott_boblingen": Network(
    icon: "brand_dott",
    operatorName: "dott",
    name: Name(
      de: "Dott Böblingen",
      en: "Dott Böblingen",
    ),
    type: "scooter",
    hideCode: true,
    enabled: true,
    visibleInSettingsUi: true,
    url: Url(
      de: "https://ridedott.com/de/fahr-mit-uns/",
      en: "https://ridedott.com/ride-with-us/",
    ),
  ),

  // dott_ludwigsburg
  "dott_ludwigsburg": Network(
    icon: "brand_dott",
    operatorName: "dott",
    name: Name(
      de: "Dott Ludwigsburg",
      en: "Dott Ludwigsburg",
    ),
    type: "scooter",
    hideCode: true,
    enabled: true,
    visibleInSettingsUi: true,
    url: Url(
      de: "https://ridedott.com/de/fahr-mit-uns/",
      en: "https://ridedott.com/ride-with-us/",
    ),
  ),

  // dott_reutlingen
  "dott_reutlingen": Network(
    icon: "brand_dott",
    operatorName: "dott",
    name: Name(
      de: "Dott Reutlingen",
      en: "Dott Reutlingen",
    ),
    type: "scooter",
    formFactors: ["scooter", "bicycle"],
    hideCode: true,
    enabled: true,
    visibleInSettingsUi: true,
    url: Url(
      de: "https://ridedott.com/de/fahr-mit-uns/",
      en: "https://ridedott.com/ride-with-us/",
    ),
  ),

  // dott_stuttgart
  "dott_stuttgart": Network(
    icon: "brand_dott",
    operatorName: "dott",
    name: Name(
      de: "Dott Stuttgart",
      en: "Dott Stuttgart",
    ),
    type: "scooter",
    hideCode: true,
    enabled: true,
    visibleInSettingsUi: true,
    url: Url(
      de: "https://ridedott.com/de/fahr-mit-uns/",
      en: "https://ridedott.com/ride-with-us/",
    ),
  ),

  // dott_tubingen
  "dott_tubingen": Network(
    icon: "brand_dott",
    operatorName: "dott",
    name: Name(
      de: "Dott Tübingen",
      en: "Dott Tübingen",
    ),
    type: "scooter",
    formFactors: ["scooter", "bicycle"],
    hideCode: true,
    enabled: true,
    visibleInSettingsUi: true,
    url: Url(
      de: "https://ridedott.com/de/fahr-mit-uns/",
      en: "https://ridedott.com/ride-with-us/",
    ),
  ),

  // de.stadtnavi.gbfs.alf
  "de.stadtnavi.gbfs.alf": Network(
    icon: "cargobike",
    operatorName: "other",
    name: Name(
      de: "Lastenrad Alf",
      en: "Cargobike Alf",
    ),
    type: "cargo_bicycle",
    hideCode: false, // No se indica hideCode, asumiendo false o el valor deseado
    enabled: true,
    season: Season(
      start: DateTime(DateTime.now().year + 10, 1, 1),
      end: DateTime(DateTime.now().year + 10, 12, 31),
      preSeasonStart: DateTime(DateTime.now().year, 1, 1),
    ),
  ),

  // de.stadtnavi.gbfs.gueltstein
  "de.stadtnavi.gbfs.gueltstein": Network(
    icon: "cargobike",
    operatorName: "other",
    name: Name(
      de: "Lastenrad Gültstein-Mobil",
      en: "Cargobike Gültstein-Mobil",
    ),
    type: "cargo_bicycle",
    enabled: true,
    season: Season(
      start: DateTime(DateTime.now().year + 10, 1, 1),
      end: DateTime(DateTime.now().year + 10, 12, 31),
      preSeasonStart: DateTime(DateTime.now().year, 1, 1),
    ),
    hideCode: false,
  ),

  // de.stadtnavi.gbfs.stadtrad
  "de.stadtnavi.gbfs.stadtrad": Network(
    icon: "cargobike",
    operatorName: "other",
    name: Name(
      de: "stadtRad der Stadt Herrenberg",
      en: "City of Herrberg's StadtRad",
    ),
    type: "cargo_bicycle",
    enabled: true,
    season: Season(
      start: DateTime(DateTime.now().year + 10, 1, 1),
      end: DateTime(DateTime.now().year + 10, 12, 31),
      preSeasonStart: DateTime(DateTime.now().year, 1, 1),
    ),
    hideCode: false,
  ),

  // de.stadtnavi.gbfs.bananologen
  "de.stadtnavi.gbfs.bananologen": Network(
    icon: "cargobike",
    operatorName: "other",
    name: Name(
      de: "Lastenrad Bananologen",
      en: "Cargobike Bananologen",
    ),
    type: "cargo_bicycle",
    enabled: true,
    season: Season(
      start: DateTime(DateTime.now().year + 10, 1, 1),
      end: DateTime(DateTime.now().year + 10, 12, 31),
      preSeasonStart: DateTime(DateTime.now().year, 1, 1),
    ),
    hideCode: false,
  ),
};
