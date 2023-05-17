import 'package:stadtnavi_core/base/custom_layers/live_bus/live_bus_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bicycle_network/bicycle_network_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parkings_zones_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

import 'pbf_layer/bike_parks/bike_parks_layer.dart';

class StaticTileLayers {
  static Map<StopsLayerIds, StopsLayer> stopsLayers = {
    StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus, '4'),
    StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail, '4'),
    StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool, '4'),
    StopsLayerIds.subway: StopsLayer(StopsLayerIds.subway, '4'),
  };
  static ParkingLayer parkingLayer = ParkingLayer("Parking", '4');
  static ParkingZonesLayer parkingZonesLayer =
      ParkingZonesLayer("Parking Zones", '1');
  static CityBikesLayer citybikeLayer = CityBikesLayer("Sharing", '5');
  static BikeParkLayer bikeParkLayer = BikeParkLayer("Bike Parking Space", '4');
  static BicycleNetworkLayer bicycleNetworkLayer =
      BicycleNetworkLayer("Bicycle Network Space", '2');
  static CifsLayer cifsLayer = CifsLayer("Roadworks", '3');
  static LiveBusLayer liveBusLayer = LiveBusLayer("LiveBusBeta", '3');
  static WeatherLayer weatherLayer = WeatherLayer("Road Weather", '3');
  static ChargingLayer chargingLayer = ChargingLayer("Charging", '4');
}