import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trufi_core/models/custom_layer.dart';

import '../custom_marker_ model.dart';
import '../markers_from_assets.dart';

class LorawanGatewaysLayer extends CustomLayer {
  List<Marker> markers = [];
  LorawanGatewaysLayer() : super("Lorawan Gateways") {
    load();
  }
  Future<void> load() async {
    final List<CustomMarker> customMarkers = await markersFromAssets(
      "assets/data/hb-layers/lorawan-gateways.geojson",
    );
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
