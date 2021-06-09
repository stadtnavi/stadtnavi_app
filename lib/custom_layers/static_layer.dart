import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';
import 'package:flutter_svg/svg.dart';
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
        : "Öffentlicher Nahverkehr",
    icon: (context) => const Icon(
      Icons.train,
      color: Colors.grey,
    ),
    layers: [
      stopsLayers[StopsLayerIds.bus],
      stopsLayers[StopsLayerIds.subway],
      stopsLayers[StopsLayerIds.rail],
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiLocalization.of(context).localeName == "en"
        ? "Bicycle"
        : "Fahrrad",
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
    name: (context) => TrufiLocalization.of(context).localeName == "en"
        ? "Sharing Offers"
        : "Sharing Angebote",
    icon: (context) => const Icon(
      Icons.bike_scooter,
      color: Colors.grey,
    ),
    layers: [
      citybikeLayer,
      stopsLayers[StopsLayerIds.carpool],
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiLocalization.of(context).localeName == "en" ? "Car" : "Auto",
    icon: (context) => SvgPicture.string(
      carDefaultIcon,
      color: Colors.grey,
    ),
    layers: [
      parkingLayer,
      chargingLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiLocalization.of(context).localeName == "en" ? "Others" : "Andere",
    icon: (context) => const Icon(
      Icons.map,
      color: Colors.grey,
    ),
    layers: [
      Layer(LayerIds.publicToilets),
      cifsLayer,
      weatherLayer,
      Layer(LayerIds.lorawanGateways),
    ],
  ),
];
