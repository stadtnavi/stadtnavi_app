import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'stops_enum.dart';

class StopFeature {
  final String code;
  final String gtfsId;
  final String name;
  final String parentStation;
  final String patterns;
  final String platform;
  final StopsLayerIds type;

  final LatLng position;
  StopFeature({
    @required this.code,
    @required this.gtfsId,
    @required this.name,
    @required this.parentStation,
    @required this.patterns,
    @required this.platform,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static StopFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String code;
    String gtfsId;
    String name;
    String parentStation;
    String patterns;
    String platform;
    StopsLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "code":
          code = element.values.first.dartStringValue;
          break;
        case "gtfsId":
          gtfsId = element.values.first.dartStringValue;
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "parentStation":
          parentStation = element.values.first.dartStringValue;
          break;
        case "patterns":
          patterns = element.values.first.dartStringValue;
          break;
        case "platform":
          platform = element.values.first.dartStringValue;
          break;
        case "type":
          type =
              stopsLayerIdsstringToEnum(element.values.first.dartStringValue);
          break;
        default:
      }
    }
    if (type == StopsLayerIds.carpool && !name.contains("P+M")) {
      type = null;
    }
    return StopFeature(
      code: code,
      gtfsId: gtfsId,
      name: name,
      parentStation: parentStation,
      patterns: patterns,
      platform: platform,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
