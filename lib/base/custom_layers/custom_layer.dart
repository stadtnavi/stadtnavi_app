import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart';

abstract class CustomLayer {
  static const int minRenderMarkers = 13;

  final String id;
  final int weight;
  Function? onRefresh;
  CustomLayer(this.id, this.weight);
  bool isDefaultOn();
  void refresh() {
    if (onRefresh != null) onRefresh!();
  }

  static double getMarkerSize(int zoom) {
    return 20;
  }

  static int getClusterSize(int zoom) {
    return 30;
  }

  static Size getMarkerClusterSize(int zoom) {
    return Size(30, 30);
  }

  /// Build TrufiMarkers for this layer at the given zoom.
  List<TrufiMarker> buildTrufiMarkers(int zoom) => [];

  /// Build TrufiLines for this layer at the given zoom (e.g. roadworks polylines).
  List<TrufiLine> buildTrufiLines(int zoom) => [];

  String name(BuildContext context);

  Widget icon(BuildContext context);
}

class CustomLayerContainer {
  final List<CustomLayer> layers;
  final WidgetBuilder icon;
  final String Function(BuildContext context) name;
  CustomLayerContainer({
    required this.layers,
    required this.icon,
    required this.name,
  });
  bool? checkStatus(Map<String, bool> layersSatus) {
    bool active = true;
    bool inactive = false;
    for (final layer in layers) {
      active &= (layersSatus[layer.id] ?? true);
      inactive |= (layersSatus[layer.id] ?? false);
    }
    return active
        ? active
        : !inactive
            ? inactive
            : null;
  }
}
