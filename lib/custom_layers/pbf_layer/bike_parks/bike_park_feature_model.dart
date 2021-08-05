import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'bike_parks_enum.dart';

class BikeParkFeature {
  final GeoJsonPoint geoJsonPoint;
  final String id;
  final String name;
  final String state;
  final String tags;
  final bool bicyclePlaces;
  final bool anyCarPlaces;
  final bool carPlaces;
  final bool wheelchairAccessibleCarPlaces;
  final bool realTimeData;
  final String capacity;
  final int bicyclePlacesCapacity;

  final BikeParkLayerIds type;

  final LatLng position;
  BikeParkFeature({
    @required this.geoJsonPoint,
    @required this.id,
    @required this.name,
    @required this.state,
    @required this.tags,
    @required this.bicyclePlaces,
    @required this.anyCarPlaces,
    @required this.carPlaces,
    @required this.wheelchairAccessibleCarPlaces,
    @required this.realTimeData,
    @required this.capacity,
    @required this.bicyclePlacesCapacity,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static BikeParkFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    String name;
    String state;
    String tags;
    bool bicyclePlaces;
    bool anyCarPlaces;
    bool carPlaces;
    bool wheelchairAccessibleCarPlaces;
    bool realTimeData;
    String capacity;
    int bicyclePlacesCapacity;
    BikeParkLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "state":
          state = element.values.first.dartStringValue;
          break;
        case "bicyclePlaces":
          bicyclePlaces = element.values.first.dartBoolValue;
          break;
        case "anyCarPlaces":
          anyCarPlaces = element.values.first.dartBoolValue;
          break;
        case "carPlaces":
          carPlaces = element.values.first.dartBoolValue;
          break;
        case "wheelchairAccessibleCarPlaces":
          wheelchairAccessibleCarPlaces = element.values.first.dartBoolValue;
          break;
        case "realTimeData":
          realTimeData = element.values.first.dartBoolValue;
          break;
        case "capacity":
          capacity = element.values.first.dartStringValue;
          break;
        case "capacity.bicyclePlaces":
          bicyclePlacesCapacity = element.values.first.dartIntValue.toInt();
          break;
        case "tags":
          tags = element.values.first.dartStringValue;
          break;
        default:
      }
    }
    type = tags != null
        ? tags.contains("osm:covered")
            ? BikeParkLayerIds.covered
            : BikeParkLayerIds.notCovered
        : null;
    if (type == null || bicyclePlaces == null || !bicyclePlaces) return null;
    return BikeParkFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      name: name,
      state: state,
      tags: tags,
      bicyclePlaces: bicyclePlaces,
      anyCarPlaces: anyCarPlaces,
      carPlaces: carPlaces,
      wheelchairAccessibleCarPlaces: wheelchairAccessibleCarPlaces,
      realTimeData: realTimeData,
      capacity: capacity,
      bicyclePlacesCapacity: bicyclePlacesCapacity,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
