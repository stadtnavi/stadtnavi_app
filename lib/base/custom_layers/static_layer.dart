import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/carsharing_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/scooter/scooter_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';

class MapMarkersRepositoryContainer {
  static final SortedList<PoiFeature> poiFeatures = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.osmId,
  );
  static SortedList<CityBikeFeature> cityBikeFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<StopFeature> stopFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.gtfsId,
  );
  static SortedList<BikeParkFeature> bikeParkFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<ParkingFeature> parkingFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<WeatherFeature> weatherFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.address,
  );
  static SortedList<RoadworksFeature> roadworksFeature = SortedList(
    compare: (a, b) => a.id.compareTo(b.id),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<ChargingFeature> chargingFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<CarSharingFeature> carSharingFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  static SortedList<ScooterFeature> scooterFeature = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  
}

class SortedList<T> {
  final Map<String, T> _map = {};
  final List<T> _sortedList = [];
  final int Function(T, T) compare;
  final String Function(T) getId;

  SortedList({required this.compare, required this.getId});

  void add(T item, {bool replace = false}) {
    String id = getId(item);

    if (_map.containsKey(id)) {
      if (replace) {
        _removeById(id);
      } else {
        return;
      }
    }

    _map[id] = item;
    _insertSorted(item);
  }

  void _insertSorted(T item) {
    int index = _sortedList.indexWhere((element) => compare(item, element) < 0);
    if (index == -1) {
      _sortedList.add(item);
    } else {
      _sortedList.insert(index, item);
    }
  }

  void remove(String id) {
    if (_map.containsKey(id)) {
      _removeById(id);
    }
  }

  void _removeById(String id) {
    T? item = _map.remove(id);
    if (item != null) {
      _sortedList.remove(item);
    }
  }

  List<T> get items => List.unmodifiable(_sortedList);
  bool contains(String id) => _map.containsKey(id);
  int get length => _sortedList.length;
  void clear() {
    _map.clear();
    _sortedList.clear();
  }
}
