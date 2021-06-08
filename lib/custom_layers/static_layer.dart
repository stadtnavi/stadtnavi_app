import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

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
// TODO: translate layer containers
final List<CustomLayerContainer> customLayers = [
  CustomLayerContainer(
    name: (context) => TrufiLocalization.of(context).localeName == "en"
        ? "Public Transit"
        : "",
    icon: (context) => const Icon(
      Icons.train,
      color: Colors.grey,
    ),
    layers: [
      stopsLayers[StopsLayerIds.bus],
      stopsLayers[StopsLayerIds.rail],
      stopsLayers[StopsLayerIds.subway],
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiLocalization.of(context).localeName == "en"
        ? "Bicycle infrastructure"
        : "",
    icon: (context) => const Icon(
      Icons.directions_bike,
      color: Colors.grey,
    ),
    layers: [
      bikeParkLayer,
      Layer(LayerIds.bicycleInfrastructure),
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiLocalization.of(context).localeName == "en" ? "Pedestrian" : "",
    icon: (context) => const Icon(
      Icons.directions_walk,
      color: Colors.grey,
    ),
    layers: [
      Layer(LayerIds.publicToilets),
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiLocalization.of(context).localeName == "en" ? "Sharing" : "",
    icon: (context) => const Icon(
      Icons.bike_scooter,
      color: Colors.grey,
    ),
    layers: [
      stopsLayers[StopsLayerIds.carpool],
      citybikeLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiLocalization.of(context).localeName == "en" ? "Car" : "",
    icon: (context) => const Icon(
      Icons.local_taxi,
      color: Colors.grey,
    ),
    layers: [
      parkingLayer,
      chargingLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiLocalization.of(context).localeName == "en"
        ? "General Information"
        : "",
    icon: (context) => const Icon(
      Icons.map,
      color: Colors.grey,
    ),
    layers: [
      Layer(LayerIds.publicToilets),
      weatherLayer,
      cifsLayer,
      Layer(LayerIds.lorawanGateways)
    ],
  ),
];
