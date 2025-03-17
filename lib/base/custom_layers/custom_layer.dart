import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

abstract class CustomLayer {
static const int minRenderMarkers=13;

  final String id;
  final int weight;
  Function? onRefresh;
  CustomLayer(this.id, this.weight);
  bool isDefaultOn();
  void refresh() {
    if (onRefresh != null) onRefresh!();
  }

  // double getMarkerSize(int zoom) => (zoom < 15) ? 20 : 20 + (zoom - 15) * 5;
  static double getMarkerSize(int zoom) {
    return 20;
    // print(zoom);
    // const sizeMap = <int, double>{
    //   15: 20,
    //   16: 20,
    //   17: 20,
    //   18: 20,
    //   19: 20,
    //   20: 20,
    // };

    // return sizeMap[zoom] ?? (zoom > 18 ? 30 : 20);
  }

  static int getClusterSize(int zoom) {
    return 30;
    // const clusterSizeMap = <int, int>{
    //   15: 30,
    //   16: 30,
    //   17: 30,
    //   18: 30,
    //   19: 35,
    //   20: 30,
    // };

    // return clusterSizeMap[zoom] ?? (zoom > 18 ? 30 : 20);
  }

  static Size getMarkerClusterSize(int zoom) {
    return Size(30, 30);
    // const markerClusterSizeMap = <int, Size>{
    //   15: Size(30, 30),
    //   16: Size(30, 30),
    //   17: Size(30, 30),
    //   18: Size(30, 30),
    //   19: Size(30, 30),
    //   20: Size(30, 30),
    // };

    // // Fallback, por ejemplo Size(30, 35) si no está en el map
    // return markerClusterSizeMap[zoom] ?? const Size(25, 25);
  }
  static Marker buildDot({required LatLng point,Color? color}){
    return Marker(
                      height: 5,
                      width: 5,
                      point: point,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
  }

  Widget? buildOverlapLayer(int zoom) => null;

  List<Marker>? buildClusterMarkers(int zoom) => null;

  Widget buildMarkerLayer(int zoom);

  Widget? buildAreaLayer(int zoom) => null;

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
