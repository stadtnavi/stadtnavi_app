import 'dart:convert';
import 'package:hive/hive.dart';

class CustomLayerLocalStorage {
  static const String path = "custom_layers_storage";
  Future<bool> save(Map<String, bool> currentState) async {
    try {
      final _box = Hive.box(path);
      await _box.put(path, jsonEncode(currentState));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> load() async {
    final _box = Hive.box(path);
    final defaultMaps = {
      "Seil- und Zahnradbahnen": true,
      "Bus stops": true,
      "Metro Station": true,
      "Train stations": true,
      "LiveBusBeta": false,
      "Bike Parking Space": true,
      "Bicycle Infrastructure": true,
      "cycle_network": false,
      "bike_shops_rental": false,
      "Road Weather": true,
      "Roadworks": true,
      "parkAndRide": true,
      "gas_stations": false,
      "workshops_mv": false,
      "Charging": true,
      "Carpool stops": true,
      "scooter": true,
      "cargo_bicycle": true,
      "bicycle": true,
      "car": true,
      "taxi": false,
      "sights": false,
      "restaurants": false,
      "cafes": false,
      "bars_and_pubs": false,
      "entertainment_arts_and_culture": false,
      "sports_parks_playgrounds": false,
      "accommodation": false,
      "benches_and_viewpoints": false,
      "drinking_water_and_fountains": false,
      "toilets": false,
      "Public Toilets": false,
      "Lorawan Gateways": false,
      "groceries_and_beverages": false,
      "shops": false,
      "second-hand_and_sharing": false,
      "finance": false,
      "post_mailboxes_and_delivery_points": false,
      "administrative_facilities": false,
      "police_fire_department": false,
      "cemeteries": false,
      "trash_bins_and_recycling": false,
      "dog_waste_bag_stations": false,
      "medical_services": false,
      "education": false,
      "school_route_map": false,
      "social_facilities": false,
      "children_and_youth": false,
      "religious_sites": false,
      "animal_facilities": false,
      "Sharing": true
    };
    final jsonString = _box.get(path) ?? jsonEncode(defaultMaps);
    return jsonString != null
        ? (jsonDecode(jsonString) as Map<String, dynamic>?)?.map<String, bool>(
                (key, value) => MapEntry(key, value as bool)) ??
            {}
        : {};
  }
}
