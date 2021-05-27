import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/markers_from_assets.dart';
import 'package:stadtnavi_app/custom_layers/widget/marker_modal.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'custom_marker_modal.dart';
import 'custom_marker_model.dart';

enum LayerIds {
  bicycleInfrastructure,
  bicycleParking,
  // charging,
  lorawanGateways,
  publicToilets
}

extension LayerIdsToString on LayerIds {
  String enumToString() {
    final Map<LayerIds, String> enumStrings = {
      LayerIds.bicycleInfrastructure: "Bicycle Infrastructure",
      LayerIds.bicycleParking: "Bicycle Parking",
      // LayerIds.charging: "Charging",
      LayerIds.lorawanGateways: "Lorawan Gateways",
      LayerIds.publicToilets: "Public Toilets"
    };

    return enumStrings[this];
  }
}

Map<LayerIds, String> layerFileNames = {
  LayerIds.bicycleInfrastructure: "bicycleinfrastructure.geojson",
  LayerIds.bicycleParking: "bicycle-parking.geojson",
  // LayerIds.charging: "charging.geojson",
  LayerIds.lorawanGateways: "lorawan-gateways.geojson",
  LayerIds.publicToilets: "toilet.geojson",
};

class Layer extends CustomLayer {
  List<CustomMarker> customMarkers = [];
  Layer(LayerIds layerId) : super(layerId.enumToString()) {
    load();
  }

  Future<void> load() async {
    final fileName = layerFileNames.entries
        .firstWhere((element) => element.key.enumToString() == id)
        .value;

    customMarkers = await markersFromAssets("assets/data/hb-layers/$fileName");

    refresh();
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
    switch (zoom) {
      case 13:
        markerSize = 5;
        break;
      case 14:
        markerSize = 10;
        break;
      case 15:
        markerSize = 15;
        break;
      case 16:
        markerSize = 20;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    return MarkerLayerOptions(
      markers: markerSize != null
          ? customMarkers
              .map((element) => Marker(
                    height: markerSize,
                    width: markerSize,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        showBottomMarkerModal(
                          context: context,
                          builder: (BuildContext context) => CustomMarkerModal(
                            element: element,
                          ),
                        );
                      },
                      child: SvgPicture.string(element.image),
                    ),
                  ))
              .toList()
          : [],
    );
  }
}
