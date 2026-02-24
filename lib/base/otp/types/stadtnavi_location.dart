import 'package:latlong2/latlong.dart';

import 'stadtnavi_place.dart';

/// Location model for stadtnavi OTP integration.
/// Replaces trufi_core's TrufiLocation within the OTP module.
class StadtnaviLocation implements StadtnaviPlace {
  final String description;
  final double latitude;
  final double longitude;
  final List<String>? alternativeNames;
  final Map<String, String>? localizedNames;
  final String? address;
  final String? type;

  StadtnaviLocation({
    required this.description,
    required this.latitude,
    required this.longitude,
    this.alternativeNames,
    this.localizedNames,
    this.address,
    this.type,
  });

  StadtnaviLocation copyWith({
    String? description,
    double? latitude,
    double? longitude,
    List<String>? alternativeNames,
    Map<String, String>? localizedNames,
    String? address,
    String? type,
  }) {
    return StadtnaviLocation(
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      alternativeNames: alternativeNames ?? this.alternativeNames,
      localizedNames: localizedNames ?? this.localizedNames,
      address: address ?? this.address,
      type: type ?? this.type,
    );
  }

  factory StadtnaviLocation.fromJson(Map<String, dynamic> json) {
    return StadtnaviLocation(
      description: json["description"] as String,
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double,
      type: json["type"] as String?,
      address: json["address"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "type": type,
      "address": address ?? '',
    };
  }

  @override
  bool operator ==(Object other) =>
      other is StadtnaviLocation &&
      other.description == description &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.type == type;

  @override
  int get hashCode =>
      description.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return '$latitude,$longitude';
  }

  bool get isLatLngDefined {
    return latitude != 0 && longitude != 0;
  }

  LatLng get latLng {
    return LatLng(latitude, longitude);
  }
}
