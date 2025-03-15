import 'package:latlong2/latlong.dart';


class GeojsonMarker {
  final String id;
  final LatLng position;
  final String? svgIcon;
  final String? name;
  final String? popupContent;
  final String? openingHours;
  final String? openingHoursText;
  final String? openingHoursLink;
  final String? address;
  final String? website;
  final String? phone;
  final String? email;
  final String? imageUrl;

static final Map<String, String> cacheIcons = {};
  GeojsonMarker({
    required this.id,
    required this.position,
    required this.svgIcon,
    required this.name,
    required this.popupContent,
    required this.openingHours,
    required this.openingHoursText,
    required this.openingHoursLink,
    required this.address,
    required this.website,
    required this.phone,
    required this.email,
    required this.imageUrl,
  });

  static  GeojsonMarker? fromJson(json) {
    final id=json['id'];
    if(id==null)return null;
    final properties = json['properties'] ?? {};
    final geometry = json['geometry'] ?? {};
    final coordinates = geometry['coordinates'] ?? [0.0, 0.0];
    final iconId = properties['icon']['id'];

    final svgTemp = properties['icon']['svg'] ?? cacheIcons[iconId];
    if (properties['icon']['svg'] != null) {
      cacheIcons[iconId] = properties['icon']['svg'];
    }
    return GeojsonMarker(
      id: id,
      position: LatLng(
        (coordinates[1] as num).toDouble(),
        (coordinates[0] as num).toDouble(),
      ),
      svgIcon: svgTemp,
      name: properties['name'],
      popupContent: properties['popupContent'],
      openingHours: properties['openingHours'],
      openingHoursText: properties['openingHoursText'],
      openingHoursLink: properties['openingHoursLink'],
      address: properties['address'],
      website: properties['website'],
      phone: properties['phone'],
      email: properties['email'],
      imageUrl: properties['imageUrl'],
    );
  }
}

class MultiLineStringModel {
  final List<LatLng> coordinates;
  final double weight;
  final String color;

  const MultiLineStringModel({
    required this.coordinates,
    required this.weight,
    required this.color,
  });

  factory MultiLineStringModel.fromJson(Map<String, dynamic> map) {
    final coordinates = <LatLng>[];

    final List lines = map['geometry']?['coordinates'] ?? [];
    for (var line in lines) {
      for (var point in line) {
        coordinates.add(LatLng(point[1], point[0]));
      }
    }

    return MultiLineStringModel(
      coordinates: coordinates,
      weight: 2.5,
      color: "#864A91",
    );
  }
}
