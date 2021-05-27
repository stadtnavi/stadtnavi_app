import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'charging_enum.dart';

class ChargingFeature {
  final String id;
  final String name;
  final String c;
  final String ca;
  final String tb;

  final ChargingLayerIds type;

  final LatLng position;
  ChargingFeature({
    @required this.id,
    @required this.name,
    @required this.c,
    @required this.ca,
    @required this.tb,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static ChargingFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    String name;
    String c;
    String ca;
    String tb;
    ChargingLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartIntValue?.toString();
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "c":
          c = element.values.first.dartIntValue?.toString();
          break;
        case "ca":
          ca = element.values.first.dartIntValue?.toString();
          break;
        case "tb":
          tb = element.values.first.dartIntValue?.toString();
          break;
        default:
      }
    }

    return ChargingFeature(
      id: id,
      name: name,
      c: c,
      ca: ca,
      tb: tb,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
