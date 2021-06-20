import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'parkings_enum.dart';

class ParkingFeature {
  final GeoJsonPoint geoJsonPoint;
  final String id;
  final String name;
  final String note;
  final String url;
  // OPERATIONAL, TEMPORARILY_CLOSED, CLOSED
  final String state;
  final String tags;
  final String openingHours;
  final String feeHours;
  final bool bicyclePlaces;
  final bool anyCarPlaces;
  final bool carPlaces;
  final bool wheelchairAccessibleCarPlaces;
  final bool realTimeData;
  final String capacity;
  final int bicyclePlacesCapacity;
  final int carPlacesCapacity;
  final int availabilityCarPlacesCapacity;
  final int totalDisabled;
  final int freeDisabled;
  final ParkingsLayerIds type;

  final LatLng position;
  ParkingFeature({
    @required this.geoJsonPoint,
    @required this.id,
    @required this.name,
    @required this.note,
    @required this.url,
    @required this.state,
    @required this.tags,
    @required this.openingHours,
    @required this.feeHours,
    @required this.bicyclePlaces,
    @required this.anyCarPlaces,
    @required this.carPlaces,
    @required this.wheelchairAccessibleCarPlaces,
    @required this.realTimeData,
    @required this.capacity,
    @required this.bicyclePlacesCapacity,
    @required this.carPlacesCapacity,
    @required this.availabilityCarPlacesCapacity,
    @required this.totalDisabled,
    @required this.freeDisabled,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static ParkingFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    String name;
    String note;
    String url;
    String state;
    String tags;
    String openingHours;
    String feeHours;
    bool bicyclePlaces;
    bool anyCarPlaces;
    bool carPlaces;
    bool wheelchairAccessibleCarPlaces;
    bool realTimeData;
    String capacity;
    int bicyclePlacesCapacity;
    int carPlacesCapacity;
    int availabilityCarPlacesCapacity;
    int totalDisabled;
    int freeDisabled;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "note":
          note = element.values.first.dartStringValue;
          break;
        case "name":
          name = element.values.first.dartStringValue;
          break;
        case "detailsUrl":
          url = element.values.first.dartStringValue;
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
        case "capacity.carPlaces":
          carPlacesCapacity = element.values.first.dartIntValue.toInt();
          break;
        case "availability.carPlaces":
          availabilityCarPlacesCapacity =
              element.values.first.dartIntValue.toInt();
          break;
        case "availability.wheelchairAccessibleCarPlaces":
          freeDisabled = element.values.first.dartIntValue.toInt();
          break;
        case "capacity.wheelchairAccessibleCarPlaces":
          totalDisabled = element.values.first.dartIntValue.toInt();
          break;
        case "tags":
          tags = element.values.first.dartStringValue;
          break;
        case "openingHours":
          openingHours = element.values.first.dartStringValue;
          break;
        case "feeHours":
          feeHours = element.values.first.dartStringValue;
          break;
        default:
      }
    }

    if (anyCarPlaces == null || !anyCarPlaces) return null;
    // ignore: unnecessary_raw_strings
    final regex = RegExp(r"lot_type:([^,]+)");
    final regexResult = tags != null ? regex.firstMatch(tags) : null;
    final String stringType = regexResult?.group(1);

    final ParkingsLayerIds type = stringType != null
        ? pbfParkingLayerIdsstringToEnum(stringType)
        : ParkingsLayerIds.parkingSpot;
    return ParkingFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      name: name,
      note: note,
      url: url,
      state: state,
      tags: tags,
      openingHours: openingHours,
      feeHours: feeHours,
      bicyclePlaces: bicyclePlaces,
      anyCarPlaces: anyCarPlaces,
      carPlaces: carPlaces,
      wheelchairAccessibleCarPlaces: wheelchairAccessibleCarPlaces,
      realTimeData: realTimeData,
      capacity: capacity,
      bicyclePlacesCapacity: bicyclePlacesCapacity,
      carPlacesCapacity: carPlacesCapacity,
      availabilityCarPlacesCapacity: availabilityCarPlacesCapacity,
      totalDisabled: totalDisabled,
      freeDisabled: freeDisabled,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }

  bool markerState() {
    if (carPlacesCapacity != null && availabilityCarPlacesCapacity != null) {
      return availabilityCarPlacesCapacity != 0;
    } else if (totalDisabled != null && freeDisabled != null) {
      return freeDisabled != 0;
    } else {
      return null;
    }
  }
}
