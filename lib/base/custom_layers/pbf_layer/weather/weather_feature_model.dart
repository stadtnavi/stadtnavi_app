import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class WeatherFeature {
  final String address;
  final String? airTemperatureC;
  final String? roadTemperatureC;
  final String? precipitationType;
  final String? roadCondition;
  final String? updatedAt;

  final LatLng position;
  WeatherFeature({
    required this.address,
    required this.airTemperatureC,
    required this.roadTemperatureC,
    required this.precipitationType,
    required this.roadCondition,
    required this.updatedAt,
    required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static WeatherFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    // String id;
    String? address = properties['address']?.dartStringValue;
    int? airTemperatureC = properties['airTemperatureC']?.dartIntValue?.toInt();
    int? roadTemperatureC =
        properties['roadTemperatureC']?.dartIntValue?.toInt();
    int? precipitationType =
        properties['precipitationType']?.dartIntValue?.toInt();
    int? roadCondition = properties['roadCondition']?.dartIntValue?.toInt();
    String? updatedAt = properties['updatedAt']?.dartStringValue;

    return WeatherFeature(
      address: address ?? '',
      airTemperatureC: airTemperatureC?.toString(),
      roadTemperatureC: roadTemperatureC?.toString(),
      precipitationType: precipitationType?.toString(),
      roadCondition: roadCondition?.toString(),
      updatedAt: updatedAt,
      position: LatLng(
        geoJsonPoint!.geometry!.coordinates[1],
        geoJsonPoint.geometry!.coordinates[0],
      ),
    );
  }
}
