import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

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

    return enumStrings[this]!;
  }

  String enumToStringDE() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Straßen",
      MapLayerIds.satellite: "Satellit",
      MapLayerIds.bike: "Fahrrad",
    };

    return enumStrings[this]!;
  }

  String enumToStringEN() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Streets",
      MapLayerIds.satellite: "Satellite",
      MapLayerIds.bike: "Bike",
    };

    return enumStrings[this]!;
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
  final String? mapKey;

  MapLayer(
    this.mapLayerId, {
    this.mapKey,
  }) : super();

  @override
  List<LayerOptions> buildTileLayerOptions() {
    return mapLayerOptions[mapLayerId]!;
  }

  @override
  String get id => mapLayerId.enumToString();

  @override
  WidgetBuilder get imageBuilder => (context) => Image.asset(
        layerImage[mapLayerId]!,
        fit: BoxFit.cover,
      );

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en"
        ? mapLayerId.enumToStringEN()
        : mapLayerId.enumToStringDE();
  }
}

class CustomTileProvider extends TileProvider {
  Map<String, String> headers;
  CustomTileProvider({
    this.headers = const {"Referer": "https://herrenberg.stadtnavi.de/"},
  });
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    if (coords.z.toInt() > 12) {
      _fetchPBF(coords);
    }
    return CachedNetworkImageProvider(getTileUrl(coords, options),
        headers: headers);
  }

  Future<void> _fetchPBF(Coords<num> coords) async {
    await StopsLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await ParkingLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await CityBikesLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await BikeParkLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await CifsLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await WeatherLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    await ChargingLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
  }
}
