import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'parkings_enum.dart';

class ParkingFeature {
  final String id;
  final String address;
  final String name;
  final String feeHours;
  final String openingHours;
  final String free;
  final String forecast;
  final String state;
  final String coords;
  final String total;
  final String url;
  final String notes;

  final ParkingsLayerIds type;

  final LatLng position;
  ParkingFeature({
    @required this.id,
    @required this.address,
    @required this.name,
    @required this.feeHours,
    @required this.openingHours,
    @required this.free,
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
    String id;
    String address;
    String name;
    String feeHours;
    String openingHours;
    String free;
    String forecast;
    String state;
    String coords;
    String total;
    String url;
    String notes;
    ParkingsLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "lot_type":
          type = pbfParkingLayerIdsstringToEnum(
              element.values.first.dartStringValue);
          break;
        case "address":
          address = element.values.first.dartStringValue;
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "fee_hours":
          feeHours = element.values.first.dartStringValue;
          break;
        case "opening_hours":
          openingHours = element.values.first.dartStringValue;
          break;
        case "free":
          free = element.values.first.dartIntValue?.toString();
          break;
        case "forecast":
          forecast = element.values.first.dartBoolValue?.toString();
          break;
        case "state":
          state = element.values.first.dartStringValue;
          break;
        case "coords":
          coords = element.values.first.dartStringValue;
          break;
        case "total":
          total = element.values.first.dartIntValue?.toString();
          break;
        case "url":
          url = element.values.first.dartStringValue;
          break;
        case "notes":
          notes = element.values.first.dartStringValue;
          break;
        default:
      }
    }

    return ParkingFeature(
      id: id,
      address: address,
      name: name,
      feeHours: feeHours,
      openingHours: openingHours,
      free: free,
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
