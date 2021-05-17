import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'pbf_stops_enum.dart';

class ParkingFeature {
  final String address;
  final String name;
  final String forecast;
  final String state;
  final String coords;
  final String total;
  final String url;
  final String notes;

  final PBFParkingLayerIds type;

  final LatLng position;
  ParkingFeature({
    @required this.address,
    @required this.name,
    @required this.forecast,
    @required this.state,
    @required this.coords,
    @required this.total,
    @required this.url,
    @required this.notes,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static ParkingFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String address;
    String name;
    String forecast;
    String state;
    String coords;
    String total;
    String url;
    String notes;
    PBFParkingLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "lot_type":
          type = pbfParkingLayerIdsstringToEnum(element.values.first.stringValue);
          break;
        case "address":
          address = element.values.first.stringValue;
          break;
        case "name":
          name = element.values.first.stringValue;
          break;
        case "forecast":
          forecast = element.values.first.stringValue;
          break;
        case "state":
          state = element.values.first.stringValue;
          break;
        case "coords":
          coords = element.values.first.stringValue;
          break;
        case "total":
          total = element.values.first.stringValue;
          break;
        case "url":
          url = element.values.first.stringValue;
          break;
        case "notes":
          notes = element.values.first.stringValue;
          break;
        default:
      }
    }
    return ParkingFeature(
      address: address,
      name: name,
      forecast: forecast,
      state: state,
      coords: coords,
      total: total,
      url: url,
      notes: notes,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
