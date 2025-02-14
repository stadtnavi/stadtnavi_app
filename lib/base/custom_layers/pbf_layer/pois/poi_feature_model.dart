import 'package:latlong2/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

class PoiFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String id;
  final String? osmId;

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

  final PoiCategoryEnum poiEnum;
  final LatLng position;

  PoiFeature({
    this.geoJsonPoint,
    required this.id,
    this.osmId,
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
    required this.poiEnum,
    required this.position,
  });

  // ignore: prefer_constructors_over_static_methods
  static PoiFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint!.properties!;

    final String? id = properties['id']?.dartIntValue?.toString();
    final String? osmId = properties['osm_id']?.dartIntValue?.toString();

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
    final poiEnum=PoiCategoryEnum.fromCode(category2);
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
      poiEnum: poiEnum!,
      position: LatLng(
        geoJsonPoint.geometry?.coordinates[1] ?? 0,
        geoJsonPoint.geometry?.coordinates[0] ?? 0,
      ),
    );
  }
}

enum PoiCategoryEnum {
  bus(selfCode: "bus"),
  subway(selfCode: "subway"),
  rail(selfCode: "rail"),
  parkAndRideForBikes(selfCode: "parkAndRideForBikes"),
  bikeRepair(selfCode: "bike_repair"),
  cycleNetwork(selfCode: "cycle_network"),
  bikeShops(selfCode: "bike_shops_rental"),
  bikeRental(selfCode: "bike_rental"),
  weatherStations(selfCode: "weatherStations"),
  roadworks(selfCode: "roadworks"),
  parkAndRide(selfCode: "parkAndRide"),
  chargingStations(selfCode: "chargingStations"),
  gasStations(selfCode: "gas_stations"),
  workshopsMv(selfCode: "workshops_mv"),
  scooter(selfCode: "scooter"),
  bicycle(selfCode: "bicycle"),
  cargoBicycle(selfCode: "cargo_bicycle"),
  car(selfCode: "car"),
  carpoolStops(selfCode: "carpool"),
  taxi(selfCode: "taxi"),
  sights(selfCode: "sights"),
  restaurants(selfCode: "restaurants"),
  cafes(selfCode: "cafes"),
  barsAndPubs(selfCode: "bars_and_pubs"),
  entertainmentArtsAndCulture(selfCode: "entertainment_arts_and_culture"),
  sportsParksPlaygrounds(selfCode: "sports_parks_playgrounds"),
  accommodation(selfCode: "accommodation"),
  benchesAndViewpoints(selfCode: "benches_and_viewpoints"),
  drinkingWaterAndFountains(selfCode: "drinking_water_and_fountains"),
  toilets(selfCode: "toilets"),
  loarawanGateways(selfCode: "loarawan_gateways"),
  groceriesAndBeverages(selfCode: "groceries_and_beverages"),
  shops(selfCode: "shops"),
  secondHandAndSharing(selfCode: "second-hand_and_sharing"),
  finance(selfCode: "finance"),
  postMailboxesAndDeliveryPoints(
      selfCode: "post_mailboxes_and_delivery_points"),
  administrativeFacilities(selfCode: "administrative_facilities"),
  policeFireDepartment(selfCode: "police_fire_department"),
  cemeteries(selfCode: "cemeteries"),
  trashBinsAndRecycling(selfCode: "trash_bins_and_recycling"),
  dogWasteBagStations(selfCode: "dog_waste_bag_stations"),
  medicalServices(selfCode: "medical_services"),
  education(selfCode: "education"),
  schoolRouteMap(selfCode: "school_route_map"),
  socialFacilities(selfCode: "social_facilities"),
  childrenAndYouth(selfCode: "children_and_youth"),
  religiousSites(selfCode: "religious_sites"),
  animalFacilities(selfCode: "animal_facilities"),
  transit(selfCode: "transit"),
  funicular(selfCode: "funicular"),
  vehicles(selfCode: "vehicles"),
  administrativeFacility(selfCode: "administrative_facility"),
  carShop(selfCode: "car_shop"),
  supermarket(selfCode: "supermarkets"),
  pharmacy(selfCode: "pharmacy"),
  library(selfCode: "library"),
  parcelStation(selfCode: "parcel_station"),
  recycling(selfCode: "recycling"),
  touristInformation(selfCode: "tourist_information"),
  veterinariansAndAnimalClinic(selfCode: "veterinarians_and_animal_clinic"),
  police(selfCode: "police"),
  hospital(selfCode: "hospital"),
  postOffice(selfCode: "post_office"),
  university(selfCode: "universities_and_research"),
  schools(selfCode: "schools"),
  fireDepartment(selfCode: "fire_department"),
  workshopsCar(selfCode: "workshop_car"),
  workshopMotorcycleAndScooter(selfCode: "workshop_motorcycle_and_scooter");

  final String selfCode;

  const PoiCategoryEnum({required this.selfCode});

  static PoiCategoryEnum? fromSelfCode(String code) {
    try {
      return PoiCategoryEnum.values.firstWhere((e) => e.selfCode == code);
    } catch (_) {
      return null; 
    }
  }

  static PoiCategoryEnum? fromCode(String code) {
    for (final value in PoiCategoryEnum.values) {
      if (value.selfCode==code) return value;
    }
    return null;
  }

  String toSelfCode() => selfCode;
}
