import 'package:stadtnavi_app/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_layer.dart';

import 'pbf_layer/bike_parks/bike_parks_layer.dart';
import 'pbf_layer/cifs/cifs_layer.dart';
import 'pbf_layer/parking/parkings_layer.dart';
import 'pbf_layer/stops/stops_enum.dart';
import 'pbf_layer/weather/weather_layer.dart';

final Map<StopsLayerIds, StopsLayer> stopsLayers = {
  StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus),
  StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail),
  StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool),
  StopsLayerIds.subway: StopsLayer(StopsLayerIds.subway),
};

final ParkingLayer parkingLayer = ParkingLayer("Parking");
final CityBikesLayer citybikeLayer = CityBikesLayer("Sharing");
final BikeParkLayer bikeParkLayer = BikeParkLayer("Bike Parking Space");
final CifsLayer cifsLayer = CifsLayer("Roadworks");
final WeatherLayer weatherLayer = WeatherLayer("Road Weather");
final ChargingLayer chargingLayer = ChargingLayer("Charging");
