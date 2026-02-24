import 'package:stadtnavi_core/base/custom_layers/config/pbf_layer_registry.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/carsharing_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/scooter/scooter_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

/// Registers all PBF layer fetchers with [PbfLayerRegistry].
///
/// Call this once at app startup before the map tile provider is used.
void registerPbfLayers() {
  PbfLayerRegistry.register(CityBikesLayer, CityBikesLayer.fetchPBF);
  PbfLayerRegistry.register(StopsLayer, StopsLayer.fetchPBF);
  PbfLayerRegistry.register(ParkingLayer, ParkingLayer.fetchPBF);
  PbfLayerRegistry.register(MapPoiLayer, MapPoiLayer.fetchPBF);
  PbfLayerRegistry.register(BikeParkLayer, BikeParkLayer.fetchPBF);
  PbfLayerRegistry.register(RoadworksLayer, RoadworksLayer.fetchPBF);
  PbfLayerRegistry.register(WeatherLayer, WeatherLayer.fetchPBF);
  PbfLayerRegistry.register(ChargingLayer, ChargingLayer.fetchPBF);
  PbfLayerRegistry.register(CarSharingLayer, CarSharingLayer.fetchPBF);
  PbfLayerRegistry.register(ScooterLayer, ScooterLayer.fetchPBF);
}
