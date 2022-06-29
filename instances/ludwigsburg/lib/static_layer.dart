import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

final List<CustomLayerContainer> customLayersLudwigsburg = [
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
        url: 'https://node21-iot.apps.okd.swlb.de/radservice.json',
        isOnline: true,
        nameDE: 'RadSERVICE Stationen',
      ),
      StaticTileLayers.bicycleNetworkLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Sharing"
        : "Sharing-Angebote",
    icon: (context) => const Icon(
      Icons.bike_scooter,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.citybikeLayer,
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
      StaticTileLayers.parkingZonesLayer,
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
        url: 'https://node21-iot.apps.okd.swlb.de/nettetoilette.json',
        isOnline: true,
      ),
      StaticTileLayers.cifsLayer,
      // Hide "Straßenwetter" Layer
      // StaticTileLayers.weatherLayer,
      Layer(
        LayerIds.lorawanGateways,
        '3',
        url: 'https://node21-iot.apps.okd.swlb.de/lora.json',
        isOnline: true,
      ),
    ],
  ),
];
