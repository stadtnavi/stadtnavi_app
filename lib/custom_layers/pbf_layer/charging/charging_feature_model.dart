import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'charging_enum.dart';

class ChargingFeature {
  final GeoJsonPoint geoJsonPoint;
  final String id;
  final String name;
  final int capacity;
  final int available;
  final int tb;
  final int capacityUnknown;

  final ChargingLayerIds type;

  final LatLng position;
  ChargingFeature({
    @required this.geoJsonPoint,
    @required this.id,
    @required this.name,
    @required this.capacity,
    @required this.available,
    @required this.tb,
    @required this.capacityUnknown,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static ChargingFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    String name;
    int capacity;
    int available;
    int tb;
    int capacityUnknown;
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
          capacity = element.values.first.dartIntValue?.toInt();
          break;
        case "ca":
          available = element.values.first.dartIntValue?.toInt();
          break;
        case "tb":
          tb = element.values.first.dartIntValue?.toInt();
          break;
        case "cu":
          capacityUnknown = element.values.first.dartIntValue?.toInt();
          break;
        default:
      }
    }

    return ChargingFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      name: name,
      capacity: capacity,
      available: available,
      tb: tb,
      capacityUnknown: capacityUnknown,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
