import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

final List<CustomLayerContainer> customLayersHerrenberg = [
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Public Transit"
        : "Öffentlicher Nahverkehr",
    icon: (context) => const Icon(
      Icons.train,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.stopsLayers[StopsLayerIds.bus]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.subway]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.rail]!,
      StaticTileLayers.liveBusLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Bicycle"
        : "Fahrrad",
    icon: (context) => const Icon(
      Icons.directions_bike,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.bikeParkLayer,
      Layer(
        LayerIds.bicycleInfrastructure,
        '3',
      ),
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Sharing Offers"
        : "Sharing Angebote",
    icon: (context) => const Icon(
      Icons.bike_scooter,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.citybikeLayer,
      StaticTileLayers.stopsLayers[StopsLayerIds.carpool]!,
    ],
  ),
  CustomLayerContainer(
    name: (context) =>
        TrufiBaseLocalization.of(context).localeName == "en" ? "Car" : "Auto",
    icon: (context) => SvgPicture.string(
      carDefaultIcon,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.parkingLayer,
      StaticTileLayers.chargingLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Others"
        : "Andere",
    icon: (context) => const Icon(
      Icons.map,
      color: Colors.grey,
    ),
    layers: [
      Layer(
        LayerIds.publicToilets,
        '3',
      ),
      StaticTileLayers.cifsLayer,
      StaticTileLayers.weatherLayer,
      Layer(
        LayerIds.lorawanGateways,
        '3',
      ),
    ],
  ),
];
