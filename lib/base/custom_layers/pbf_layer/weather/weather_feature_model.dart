import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class WeatherFeature {
  final String address;
  final String? airTemperatureC;
  final String? airPressureRelhPa;
  final String? moisturePercentage;
  final String? roadTemperatureC;
  final String? precipitationType;
  final String? roadCondition;
  final String? icePercentage;
  final String? updatedAt;

  final LatLng position;

  WeatherFeature({
    required this.address,
    required this.airTemperatureC,
    required this.airPressureRelhPa,
    required this.moisturePercentage,
    required this.roadTemperatureC,
    required this.precipitationType,
    required this.roadCondition,
    required this.icePercentage,
    required this.updatedAt,
    required this.position,
  });

  static WeatherFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    String? address = properties['address']?.dartStringValue;
    int? airTemperatureC = properties['airTemperatureC']?.dartIntValue?.toInt();
    int? roadTemperatureC =
        properties['roadTemperatureC']?.dartIntValue?.toInt();
    int? precipitationType =
        properties['precipitationType']?.dartIntValue?.toInt();
    int? roadCondition = properties['roadCondition']?.dartIntValue?.toInt();
    String? updatedAt = properties['updatedAt']?.dartStringValue;
    int? airPressureRelhPa =
        properties['airPressureRelhPa']?.dartIntValue?.toInt();
    int? moisturePercentage =
        properties['moisturePercentage']?.dartIntValue?.toInt();
    int? icePercentage = properties['icePercentage']?.dartIntValue?.toInt();

    return WeatherFeature(
      address: address ?? '',
      airTemperatureC: airTemperatureC?.toString(),
      airPressureRelhPa: airPressureRelhPa?.toString(),
      moisturePercentage: moisturePercentage?.toString(),
      roadTemperatureC: roadTemperatureC?.toString(),
      precipitationType: precipitationType?.toString(),
      roadCondition: roadCondition?.toString(),
      icePercentage: icePercentage?.toString(),
      updatedAt: updatedAt,
      position: LatLng(
        geoJsonPoint!.geometry!.coordinates[1],
        geoJsonPoint.geometry!.coordinates[0],
      ),
    );
  }
}
