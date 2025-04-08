import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class StopFeature {
  final String? code;
  final String gtfsId;
  final String? name;
  final String? parentStation;
  final String? patterns;
  final String? platform;
  final String type;

  final LatLng position;
  StopFeature({
    required this.code,
    required this.gtfsId,
    required this.name,
    required this.parentStation,
    required this.patterns,
    required this.platform,
    required this.type,
    required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static StopFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    if (geoJsonPoint?.properties!['type'] == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};

    String? code = properties['code']?.dartStringValue;
    String? gtfsId = properties['gtfsId']?.dartStringValue;
    if (gtfsId == null) return null;
    String? name = properties['name']?.dartStringValue;
    String? parentStation = properties['parentStation']?.dartStringValue;
    String? patterns = properties['patterns']?.dartStringValue;
    String? platform = properties['platform']?.dartStringValue;
    String? type = properties['type'] != null
        ? properties['type']?.dartStringValue ?? ''
        : null;
    if (type == "CARPOOL" &&
        !(name ?? '').contains("P+M") &&
        !(gtfsId).contains(":mfdz:") &&
        !(gtfsId).contains(":bbnavi:")) {
      type = null;
    }
    if (type == null) return null;
    return StopFeature(
      code: code,
      gtfsId: gtfsId,
      name: name,
      parentStation: parentStation,
      patterns: patterns,
      platform: platform,
      type: type,
      position: LatLng(
        geoJsonPoint!.geometry!.coordinates[1],
        geoJsonPoint.geometry!.coordinates[0],
      ),
    );
  }
}
