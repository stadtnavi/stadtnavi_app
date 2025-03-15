import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class PoiFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String id;
  final String osmId;

  final String? address;
  final String? brand;
  final String category1;
  final String category2;
  final String category3;
  final String? changingTable;
  final String? cuisine;
  final String? dog;
  final bool? drinkingWater;
  final String? email;
  final bool? fee;
  final String? fuel;
  final String? internetAccess;
  final String? name;
  final String? openingHours;
  final String? operatorName;
  final String? osmType;
  final String? outdoorSeating;
  final String? phone;
  final String? sauna;
  final String? swimmingPool;
  final String? website;
  final String? wheelchair;

  final LatLng position;

  PoiFeature({
    this.geoJsonPoint,
    required this.id,
   required this.osmId,
    this.address,
    this.brand,
    required this.category1,
    required this.category2,
    required this.category3,
    this.changingTable,
    this.cuisine,
    this.dog,
    this.drinkingWater,
    this.email,
    this.fee,
    this.fuel,
    this.internetAccess,
    this.name,
    this.openingHours,
    this.operatorName,
    this.osmType,
    this.outdoorSeating,
    this.phone,
    this.sauna,
    this.swimmingPool,
    this.website,
    this.wheelchair,
    required this.position,
  });

  // ignore: prefer_constructors_over_static_methods
  static PoiFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint!.properties!;

    final String? id = properties['id']?.dartIntValue?.toString();
    final String? osmId = properties['osm_id']?.dartIntValue?.toString();
    if (osmId == null) return null;
    final String? address = properties['address']?.dartStringValue;
    final String? brand = properties['brand']?.dartStringValue;
    final String category1 = properties['category1']!.dartStringValue!;
    final String category2 = properties['category2']!.dartStringValue!;
    final String category3 = properties['category3']!.dartStringValue!;
    final String? changingTable = properties['changing_table']?.dartStringValue;
    final String? cuisine = properties['cuisine']?.dartStringValue;
    final String? dog = properties['dog']?.dartStringValue;
    final bool? drinkingWater = properties['drinking_water']?.dartBoolValue;
    final String? email = properties['email']?.dartStringValue;
    final bool? fee = properties['fee']?.dartBoolValue;
    final String? fuel = properties['fuel']?.dartStringValue;
    final String? internetAccess =
        properties['internet_access']?.dartStringValue;
    final String? name = properties['name']?.dartStringValue;
    final String? openingHours = properties['opening_hours']?.dartStringValue;
    final String? operatorName = properties['operator']?.dartStringValue;
    final String? osmType = properties['osm_type']?.dartStringValue;
    final String? outdoorSeating =
        properties['outdoor_seating']?.dartStringValue;
    final String? phone = properties['phone']?.dartStringValue;
    final String? sauna = properties['sauna']?.dartStringValue;
    final String? swimmingPool = properties['swimming_pool']?.dartStringValue;
    final String? website = properties['website']?.dartStringValue;
    final String? wheelchair = properties['wheelchair']?.dartStringValue;
    return PoiFeature(
      geoJsonPoint: geoJsonPoint,
      id: id ?? '',
      osmId: osmId,
      address: address,
      brand: brand,
      category1: category1,
      category2: category2,
      category3: category3,
      changingTable: changingTable,
      cuisine: cuisine,
      dog: dog,
      drinkingWater: drinkingWater,
      email: email,
      fee: fee,
      fuel: fuel,
      internetAccess: internetAccess,
      name: name,
      openingHours: openingHours,
      operatorName: operatorName,
      osmType: osmType,
      outdoorSeating: outdoorSeating,
      phone: phone,
      sauna: sauna,
      swimmingPool: swimmingPool,
      website: website,
      wheelchair: wheelchair,
      position: LatLng(
        geoJsonPoint.geometry?.coordinates[1] ?? 0,
        geoJsonPoint.geometry?.coordinates[0] ?? 0,
      ),
    );
  }
}
