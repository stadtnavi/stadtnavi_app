import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';


class MapMarkersRepositoryContainer {
  static Map<String, PoiFeature> poiFeatures = {};
  static Map<String, CityBikeFeature> cityBikeFeature={};
  static Map<String, StopFeature> stopFeature={};
  static Map<String, BikeParkFeature> bikeParkFeature={};
  static Map<String, ParkingFeature> parkingFeature={};
  static Map<String, WeatherFeature> weatherFeature={};
  static Map<String, RoadworksFeature> roadworksFeature={};
  static Map<String, ChargingFeature> chargingFeature={};
}
