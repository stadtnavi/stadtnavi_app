import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'bike_parks_enum.dart';

class CifsFeature {
  final GeoJsonLineString geoJsonPoint;
  final String id;
  final String locationStreet;
  final String locationDirection;
  final String starttime;
  final String endtime;
  final String description;
  final String reference;
  final String mode;
  final List<LatLng> polyline;
  final LatLng startPoint;
  final LatLng endPoint;
  final String url;

  final CifsTypeIds type;
  final CifsSubTypeIds subType;
  CifsFeature({
    @required this.geoJsonPoint,
    @required this.id,
    @required this.locationStreet,
    @required this.locationDirection,
    @required this.starttime,
    @required this.endtime,
    @required this.description,
    @required this.reference,
    @required this.mode,
    @required this.url,
    @required this.polyline,
    @required this.type,
    @required this.subType,
  })  : startPoint = polyline.first,
        endPoint = polyline.last;
  // ignore: prefer_constructors_over_static_methods
  static CifsFeature fromGeoJsonLine(GeoJsonLineString geoJsonPoint) {
    String id;
    String locationPolyline;
    String locationStreet;
    String locationDirection;
    String starttime;
    String endtime;
    String description;
    String reference;
    String mode;
    String url;
    CifsTypeIds type;
    CifsSubTypeIds subType;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "location.polyline":
          locationPolyline = element.values.first.dartStringValue;
          break;
        case "location.street":
          locationStreet = element.values.first.dartStringValue;
          break;
        case "location.direction":
          locationDirection = element.values.first.dartStringValue;
          break;
        case "starttime":
          starttime = element.values.first.dartStringValue;
          break;
        case "endtime":
          endtime = element.values.first.dartStringValue;
          break;
        case "description":
          description = element.values.first.dartStringValue;
          break;
        case "reference":
          reference = element.values.first.dartStringValue;
          break;
        case "mode":
          mode = element.values.first.dartStringValue;
          break;
        case "details_url":
          url = element.values.first.dartStringValue;
          break;
        case "type":
          type = cifsTypeIdsStringToEnum(element.values.first.dartStringValue);
          break;
        case "subtype":
          subType =
              cifsSubTypeIdsStringToEnum(element.values.first.dartStringValue);
          break;
        default:
      }
    }
    final List<LatLng> polyline = [];
    final polylineList = locationPolyline.split(" ");
    for (int i = 0; i < polylineList.length; i += 2) {
      polyline.add(
        LatLng(
          double.tryParse(polylineList[i]),
          double.tryParse(polylineList[i + 1]),
        ),
      );
    }

    return CifsFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      locationStreet: locationStreet,
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
