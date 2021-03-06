import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

abstract class CustomLayer {
  final String id;
  final String weight;
  Function? onRefresh;
  CustomLayer(this.id, this.weight);

  void refresh() {
    if (onRefresh != null) onRefresh!();
  }

  LayerOptions buildLayerOptions(int zoom);

  LayerOptions? buildLayerOptionsPriority(int zoom);

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
