import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'bike_parks_enum.dart';

class BikeParkFeature {
  final String id;
  final String name;
  final String covered;
  final String spacesAvailable;
  final String maxCapacity;

  final BikeParkLayerIds type;

  final LatLng position;
  BikeParkFeature({
    @required this.id,
    @required this.name,
    @required this.covered,
    @required this.spacesAvailable,
    @required this.maxCapacity,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static BikeParkFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    String name;
    String covered;
    String spacesAvailable;
    String maxCapacity;
    BikeParkLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "covered":
          covered = element.values.first.dartBoolValue?.toString();
          type=covered=="true"?BikeParkLayerIds.covered:BikeParkLayerIds.notCovered;
          break;
        case "spacesAvailable":
          spacesAvailable = element.values.first.dartIntValue?.toString();
          break;
        case "maxCapacity":
          maxCapacity = element.values.first.dartIntValue.toString();
          break;
        default:
      }
    }

    return BikeParkFeature(
      id: id,
      name: name,
      covered: covered,
      spacesAvailable: spacesAvailable,
      maxCapacity: maxCapacity,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
