import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'bike_parks_enum.dart';

class CifsFeature {
  final GeoJsonLineString? geoJsonPoint;
  final String id;
  final String locationStreet;
  final String? locationDirection;
  final String? starttime;
  final String? endtime;
  final String? description;
  final String? reference;
  final String? mode;
  final List<LatLng> polyline;
  final LatLng startPoint;
  final LatLng endPoint;
  final String? url;

  final CifsTypeIds? type;
  final CifsSubTypeIds? subType;
  CifsFeature({
    required this.geoJsonPoint,
    required this.id,
    required this.locationStreet,
    required this.locationDirection,
    required this.starttime,
    required this.endtime,
    required this.description,
    required this.reference,
    required this.mode,
    required this.url,
    required this.polyline,
    required this.type,
    required this.subType,
  })  : startPoint = polyline.first,
        endPoint = polyline.last;
  // ignore: prefer_constructors_over_static_methods
  static CifsFeature? fromGeoJsonLine(GeoJsonLineString? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    String? id = properties['id']?.dartStringValue;
    String? locationPolyline = properties['location.polyline']?.dartStringValue;
    String? locationStreet = properties['location.street']?.dartStringValue;
    String? locationDirection =
        properties['location.direction']?.dartStringValue;
    String? starttime = properties['starttime']?.dartStringValue;
    String? endtime = properties['endtime']?.dartStringValue;
    String? description = properties['description']?.dartStringValue;
    String? reference = properties['reference']?.dartStringValue;
    String? mode = properties['mode']?.dartStringValue;
    String? url = properties['details_url']?.dartStringValue;
    CifsTypeIds? type = properties['type'] != null
        ? cifsTypeIdsStringToEnum(properties['type']!.dartStringValue ?? '')
        : null;
    CifsSubTypeIds? subType = properties['subtype'] != null
        ? cifsSubTypeIdsStringToEnum(
            properties['subtype']!.dartStringValue ?? '')
        : null;
    final List<LatLng> polyline = [];
    final polylineList = (locationPolyline?.trim() ?? '').split(" ");
    for (int i = 0; i < polylineList.length; i += 2) {
      polyline.add(
        LatLng(
          double.tryParse(polylineList[i]) ?? 0,
          double.tryParse(polylineList[i + 1]) ?? 0,
        ),
      );
    }

    return CifsFeature(
      geoJsonPoint: geoJsonPoint,
      id: id ?? '',
      locationStreet: locationStreet ?? '',
      locationDirection: locationDirection,
      starttime: starttime,
      endtime: endtime,
      description: description,
      reference: reference,
      mode: mode,
      url: url,
      polyline: polyline,
      type: type,
      subType: subType,
    );
  }
}
