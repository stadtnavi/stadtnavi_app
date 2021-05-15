import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trufi_core/models/map_tile_provider.dart';

enum MapLayerIds {
  streets,
  satellite,
  bike,
}

extension LayerIdsToString on MapLayerIds {
  String enumToString() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Streets",
      MapLayerIds.satellite: "Satellite",
      MapLayerIds.bike: "Bike",
    };

    return enumStrings[this];
  }
}

Map<MapLayerIds, List<LayerOptions>> mapLayerOptions = {
  MapLayerIds.streets: [
    TileLayerOptions(
      tileProvider: NetworkTileProvider(),
      urlTemplate: "https://tiles.stadtnavi.eu/streets/{z}/{x}/{y}@2x.png",
    ),
  ],
  MapLayerIds.satellite: [
    TileLayerOptions(
      tileProvider: NetworkTileProvider(),
      urlTemplate: "https://api.stadtnavi.de/tiles/orthophoto/{z}/{x}/{y}.jpg",
    ),
    TileLayerOptions(
      tileProvider: NetworkTileProvider(),
      backgroundColor: Colors.transparent,
      urlTemplate:
          "https://tiles.stadtnavi.eu/satellite-overlay/{z}/{x}/{y}@2x.png",
    ),
  ],
  MapLayerIds.bike: [
    TileLayerOptions(
      urlTemplate:
          "https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png",
      subdomains: ["a", "b", "c"],
    ),
  ],
};
Map<MapLayerIds, String> layerImage = {
  MapLayerIds.streets: "assets/images/maptype-streets.png",
  MapLayerIds.satellite: "assets/images/maptype-satellite.png",
  MapLayerIds.bike: "assets/images/maptype-terrain.png",
};

class MapLayer extends MapTileProvider {
  final MapLayerIds mapLayerId;
  final String mapKey;

  MapLayer(this.mapLayerId, {this.mapKey}) : super();

  @override
  List<LayerOptions> buildTileLayerOptions() {
    return mapLayerOptions[mapLayerId];
  }

  @override
  String get id => mapLayerId.enumToString();

  @override
  WidgetBuilder get imageBuilder => (context) => Image.asset(
        layerImage[mapLayerId],
        fit: BoxFit.cover,
      );
}

class NetworkTileProvider extends TileProvider {
  Map<String, String> headers;
  NetworkTileProvider({
    this.headers = const {"Referer": "https://herrenberg.stadtnavi.de/"},
  });
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return NetworkImage(getTileUrl(coords, options), headers: headers);
  }
}
