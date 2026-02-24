import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
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
