import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/hb_parking_map/pbf_hb_parking_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stop_map/pbf_stops_layer.dart';
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
      tileProvider: CustomTileProvider(),
      urlTemplate: "https://tiles.stadtnavi.eu/streets/{z}/{x}/{y}@2x.png",
    ),
  ],
  MapLayerIds.satellite: [
    TileLayerOptions(
      tileProvider: CustomTileProvider(),
      urlTemplate: "https://api.stadtnavi.de/tiles/orthophoto/{z}/{x}/{y}.jpg",
    ),
    TileLayerOptions(
      tileProvider: CustomTileProvider(),
      backgroundColor: Colors.transparent,
      urlTemplate:
          "https://tiles.stadtnavi.eu/satellite-overlay/{z}/{x}/{y}@2x.png",
    ),
  ],
  MapLayerIds.bike: [
    TileLayerOptions(
      tileProvider: CustomTileProvider(),
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

class CustomTileProvider extends TileProvider {
  Map<String, String> headers;
  CustomTileProvider({
    this.headers = const {"Referer": "https://herrenberg.stadtnavi.de/"},
  });
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    // inject pbf map layer
    PBFStopsLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    PBFParkingLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });

    return NetworkImage(getTileUrl(coords, options), headers: headers);
  }
}
