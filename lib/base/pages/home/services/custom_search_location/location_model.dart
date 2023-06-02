import 'package:stadtnavi_core/base/pages/home/services/custom_search_location/search_location_utils.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

class LocationModel {
  LocationModel({
    this.geometry,
    this.type,
    this.name,
    this.street,
  });

  Geometry? geometry;
  String? type;
  String? name;
  String? street;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final nameLabel = getNameLabel(json["properties"], plain: true);
    return LocationModel(
      geometry: Geometry.fromJson(json["geometry"] as Map<String, dynamic>),
      type: getIconProperties(json),
      name: nameLabel[0],
      street: nameLabel[1],
    );
  }

  TrufiLocation toTrufiLocation() {
    return TrufiLocation(
      description: name ?? 'Not description',
      latitude: geometry?.coordinates?[1] ?? 0,
      longitude: geometry?.coordinates?[0] ?? 0,
      address: street,
      type: type,
    );
  }
}

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  List<double>? coordinates;
  String? type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(
            (json["coordinates"] as List).map((x) => x.toDouble())),
        type: json["type"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from((coordinates ?? []).map((x) => x)),
        "type": type,
      };
}
