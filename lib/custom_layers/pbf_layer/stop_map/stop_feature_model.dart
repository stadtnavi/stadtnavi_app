
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'pbf_stops_enum.dart';

class StopFeature {
  final String code;
  final List<String> gtfsId;
  final String name;
  final String parentStation;
  final String patterns;
  final String platform;
  final PBFStopsLayerIds type;

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
    List<String> gtfsId;
    String name;
    String parentStation;
    String patterns;
    String platform;
    PBFStopsLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "code":
          code = element.values.first.dartStringValue;
          break;
        case "gtfsId":
          gtfsId = [element.values.first.dartStringValue];
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
          type = pbfStopsLayerIdsstringToEnum(
              element.values.first.dartStringValue);
          break;
        default:
      }
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
