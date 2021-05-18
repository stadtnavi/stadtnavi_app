import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class WeatherFeature {
final String address;
   final  String airTemperatureC;
   final  String roadTemperatureC;
   final  String precipitationType;
   final  String roadCondition;
   final  String updatedAt;


  final LatLng position;
  WeatherFeature({
    @required this.address,
    @required this.airTemperatureC,
    @required this.roadTemperatureC,
    @required this.precipitationType,
    @required this.roadCondition,
    @required this.updatedAt,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static WeatherFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    // String id;
    String address;
    String airTemperatureC;
    String roadTemperatureC;
    String precipitationType;
    String roadCondition;
    String updatedAt;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "address":
          address = element.values.first.dartStringValue;
          break;
        case "airTemperatureC":
          airTemperatureC = element.values.first.dartIntValue?.toString();
          break;
        case "roadTemperatureC":
          roadTemperatureC = element.values.first.dartIntValue?.toString();
          break;
        case "precipitationType":
          precipitationType = element.values.first.dartIntValue?.toString();
          break;
        case "roadCondition":
          roadCondition = element.values.first.dartIntValue?.toString();
          break;
        case "updatedAt":
          updatedAt = element.values.first.dartStringValue;
          break;
        default:
      }
    }

    return WeatherFeature(
      address: address,
      airTemperatureC: airTemperatureC,
      roadTemperatureC: roadTemperatureC,
      precipitationType: precipitationType,
      roadCondition: roadCondition,
      updatedAt: updatedAt,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
