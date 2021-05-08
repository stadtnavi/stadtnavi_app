import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/custom_marker_model.dart';
import 'package:stadtnavi_app/custom_layers/markers_from_assets.dart';
import 'package:trufi_core/models/custom_layer.dart';

enum LayerIds {
  bicycleInfrastructure,
  bicycleParking,
  charging,
  lorawanGateways,
  publicToilets,
  unknown
}

extension LayerIdsToString on LayerIds {
  String enumToString() {
    final Map<LayerIds, String> enumStrings = {
      LayerIds.bicycleInfrastructure: "Bicycle Infrastructure",
      LayerIds.bicycleParking: "Bicycle Parking",
      LayerIds.charging: "Charging",
      LayerIds.lorawanGateways: "Lorawan Gateways",
      LayerIds.publicToilets: "Public Toilets",
      LayerIds.unknown: "Unknown"
    };

    return enumStrings[this];
  }
}

Map<LayerIds, String> layerFileNames = {
  LayerIds.bicycleInfrastructure: "bicycleinfrastructure.geojson",
  LayerIds.bicycleParking: "bicycle-parking.geojson",
  LayerIds.charging: "charging.geojson",
  LayerIds.lorawanGateways: "lorawan-gateways.geojson",
  LayerIds.publicToilets: "toilet.geojson",
};

class Layer extends CustomLayer {
  List<Marker> markers = [];

  Layer(LayerIds layerId) : super(layerId.enumToString()) {
    load();
  }

  Future<void> load() async {
    final fileName = layerFileNames.entries
        .firstWhere((element) => element.key.enumToString() == id)
        .value;

    final List<CustomMarker> customMarkers =
        await markersFromAssets("assets/data/hb-layers/$fileName");

    markers = customMarkers
        .map((element) => Marker(
              height: 15,
              width: 15,
              point: element.position,
              anchorPos: AnchorPos.align(AnchorAlign.center),
              builder: (context) => GestureDetector(
                child: SvgPicture.string(element.image),
              ),
            ))
        .toList();
    refresh();
  }

  @override
  LayerOptions get layerOptions => MarkerLayerOptions(markers: markers);
}
