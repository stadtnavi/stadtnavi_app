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

Map<MapLayerIds, String> mapLayerUrl = {
  MapLayerIds.streets:
      "https://api.maptiler.com/maps/streets/{z}/{x}/{y}@2x.png?key={key}",
  MapLayerIds.satellite:
      "https://api.maptiler.com/maps/basic/{z}/{x}/{y}@2x.png?key={key}",
  MapLayerIds.bike:
      "https://a.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png",
};
Map<MapLayerIds, String> layerImage = {
  MapLayerIds.streets: "assets/images/maptype-streets.png",
  MapLayerIds.satellite: "assets/images/maptype-satellite.png",
  MapLayerIds.bike: "assets/images/maptype-terrain.png",
};

class MapLayer extends MapTileProvider {
  final MapLayerIds mapLayerId;
  final String mapKey;

  MapLayer(this.mapLayerId, this.mapKey) : super();

  @override
  TileLayerOptions buildTileLayerOptions() {
    return TileLayerOptions(
      urlTemplate: mapLayerUrl[mapLayerId],
      additionalOptions: {
        'key': mapKey,
      },
    );
  }

  @override
  String get id => mapLayerId.enumToString();

  @override
  WidgetBuilder get imageBuilder => (context) => Image.asset(
        layerImage[mapLayerId],
        fit: BoxFit.cover,
      );
}
