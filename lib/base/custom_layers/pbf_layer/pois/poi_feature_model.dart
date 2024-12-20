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
      poiEnum: PoiCategoryEnum.fromCode(category3),
      position: LatLng(
        geoJsonPoint.geometry?.coordinates[1] ?? 0,
        geoJsonPoint.geometry?.coordinates[0] ?? 0,
      ),
    );
  }
}

enum PoiCategoryEnum {
  bus(
    selfCode: "bus",
    codes: ["bus"],
  ),
  subway(
    selfCode: "subway",
    codes: ["subway"],
  ),
  rail(
    selfCode: "rail",
    codes: ["rail"],
  ),
  parkAndRideForBikes(
    selfCode: "parkAndRideForBikes",
    codes: ["parkAndRideForBikes"],
  ),
  bikeRepair(
    selfCode: "bike_repair",
    codes: ["bike_repair"],
  ),
  cycleNetwork(
    selfCode: "cycle_network",
    codes: ["cycle_network"],
  ),
  bikeShops(
    selfCode: "bike_shop",
    codes: ["bike_shop"],
  ),
  bikeRental(
    selfCode: "bike_rental",
    codes: ["bike_rental"],
  ),
  weatherStations(
    selfCode: "weatherStations",
    codes: ["weatherStations"],
  ),
  roadworks(
    selfCode: "roadworks",
    codes: ["roadworks"],
  ),
  parkAndRide(
    selfCode: "parkAndRide",
    codes: ["parkAndRide"],
  ),
  chargingStations(
    selfCode: "chargingStations",
    codes: ["chargingStations"],
  ),
  gasStations(
    selfCode: "gas_stations",
    codes: ["gas_station"],
  ),
  workshopsMv(
    selfCode: "workshops_mv",
    codes: ["workshop_car", "workshop_motorcycle_and_scooter"],
  ),
  scooter(
    selfCode: "scooter",
    codes: ["scooter"],
  ),
  bicycle(
    selfCode: "bicycle",
    codes: ["bicycle"],
  ),
  cargoBicycle(
    selfCode: "cargo_bicycle",
    codes: ["cargo_bicycle"],
  ),
  car(
    selfCode: "car",
    codes: ["car"],
  ),
  carpoolStops(
    selfCode: "carpool_stops",
    codes: ["carpool_stops"],
  ),
  taxi(
    selfCode: "taxi",
    codes: ["taxi"],
  ),
  sights(
    selfCode: "sights",
    codes: ["sights"],
  ),
  restaurants(
    selfCode: "restaurants",
    codes: ["restaurants", "beer_garden"],
  ),
  cafes(
    selfCode: "cafes",
    codes: ["cafe", "ice_cream"],
  ),
  barsAndPubs(
    selfCode: "bars_and_pubs",
    codes: ["bar_or_pub"],
  ),
  entertainmentArtsAndCulture(
    selfCode: "entertainment_arts_and_culture",
    codes: [
      "theater_and_opera",
      "museums_and_galleries",
      "cinemas",
      "event_fair_etc",
      "music",
      "other",
      "tourist_information"
    ],
  ),
  sportsParksPlaygrounds(
    selfCode: "sports_parks_playgrounds",
    codes: [
      "other",
      "football",
      "tennis",
      "baseball",
      "basketball",
      "boules_court",
      "bowling_or_skittles",
      "fitness_studio_and_sports_centers",
      "golf",
      "skatepark",
      "swimming_pool_or_outdoor_pool",
      "volleyball",
      "table_tennis",
      "park",
      "playground",
    ],
  ),
  accommodation(
    selfCode: "accommodation",
    codes: ["hotel", "youth_hostel"],
  ),
  benchesAndViewpoints(
    selfCode: "benches_and_viewpoints",
    codes: ["wave_lounger", "other_bench", "viewpoint"],
  ),
  drinkingWaterAndFountains(
    selfCode: "drinking_water_and_fountains",
    codes: ["fountain", "drinking_water"],
  ),
  toilets(
    selfCode: "toilets",
    codes: ["public_toilet", "friendly_toilet", "customer_toilet"],
  ),
  loarawanGateways(
    selfCode: "loarawan_gateways",
    codes: ["loarawan_gateways"],
  ),
  groceriesAndBeverages(
    selfCode: "groceries_and_beverages",
    codes: [
      "supermarkets",
      "beverages",
      "bakery",
      "organic_market",
      "farmers_market",
    ],
  ),
  shops(
    selfCode: "shops",
    codes: [
      "shopping_center",
      "clothing_and_accessories",
      "shoes_shop",
      "fabric_and_yarn",
      "arts_and_crafts",
      "photography",
      "games",
      "music",
      "electronics",
      "books",
      "gifts",
      "kiosk_stationery",
      "garden_and_agriculture",
      "pet_supplies",
      "diy_store",
      "furniture_and_home_decor",
      "car",
      "motorcycle_and_scooter",
      "outdoor_and_sports",
      "hairdresser",
      "cosmetics_and_beauty",
      "drugstore",
    ],
  ),
  secondHandAndSharing(
    selfCode: "second-hand_and_sharing",
    codes: ["second-hand_and_sharing"],
  ),
  finance(
    selfCode: "finance",
    codes: ["bank", "cash_withdrawal", "atm"],
  ),
  postMailboxesAndDeliveryPoints(
    selfCode: "post_mailboxes_and_delivery_points",
    codes: ["post_office", "mailbox", "parcel_station"],
  ),
  administrativeFacilities(
    selfCode: "administrative_facilities",
    codes: ["administrative_facility"],
  ),
  policeFireDepartment(
    selfCode: "police_fire_department",
    codes: ["police", "fire_department"],
  ),
  cemeteries(
    selfCode: "cemeteries",
    codes: ["cemetery"],
  ),
  trashBinsAndRecycling(
    selfCode: "trash_bins_and_recycling",
    codes: ["recycling", "trash_bin"],
  ),
  dogWasteBagStations(
    selfCode: "dog_waste_bag_stations",
    codes: ["dog_waste_bag_station"],
  ),
  medicalServices(
    selfCode: "medical_services",
    codes: [
      "hospital",
      "doctor",
      "pharmacy",
      "dentistry",
      "hearing_aid_acoustics",
      "optics",
      "medical_supply_store_orthopedics",
    ],
  ),
  education(
    selfCode: "education",
    codes: [
      "universities_and_research",
      "schools",
      "community_colleges",
      "library",
      "music_and_language_school",
    ],
  ),
  schoolRouteMap(
    selfCode: "school_route_map",
    codes: ["school_route_map"],
  ),
  socialFacilities(
    selfCode: "social_facilities",
    codes: ["community_center", "housing_care_and_nursing"],
  ),
  childrenAndYouth(
    selfCode: "children_and_youth",
    codes: ["youth_facility", "childcare"],
  ),
  religiousSites(
    selfCode: "religious_sites",
    codes: ["other", "church", "mosque", "synagogue"],
  ),
  animalFacilities(
    selfCode: "animal_facilities",
    codes: ["animal_shelter", "veterinarians_and_animal_clinic"],
  );

  final String selfCode;
  final List<String> codes;

  const PoiCategoryEnum({required this.selfCode, required this.codes});

  static PoiCategoryEnum? fromSelfCode(String code) {
    return PoiCategoryEnum.values
        .where((e) => e.selfCode == code)
        .cast<PoiCategoryEnum?>()
        .firstWhere((element) => element != null, orElse: () => null);
  }

  static PoiCategoryEnum fromCode(String code) {
    for (final value in PoiCategoryEnum.values) {
      if (value.codes.contains(code)) return value;
    }
    throw Exception("Should never happened, $code enum doesn't exist ");
  }

  String toSelfCode() => selfCode;

  List<String> toCodes() => codes;
}
