import 'package:stadtnavi_app/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_layer.dart';

import 'bike_parks/bike_parks_layer.dart';
import 'cifs/cifs_layer.dart';
import 'parking/parkings_layer.dart';
import 'stops/stops_enum.dart';
import 'weather/weather_layer.dart';

final Map<StopsLayerIds, StopsLayer> stopsLayers = {
  StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus),
  StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail),
  StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool),
};

final ParkingLayer parkingLayer = ParkingLayer("Parking");
final CityBikesLayer citybikeLayer = CityBikesLayer("Sharing");
final BikeParkLayer bikeParkLayer = BikeParkLayer("Bike Parking Space");
final CifsLayer cifsLayer = CifsLayer("Roadworks");
final WeatherLayer weatherLayer = WeatherLayer("Road Weather");
