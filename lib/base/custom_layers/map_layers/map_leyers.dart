import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/consts.dart';

enum MapLayerIds {
  streets,
  satellite,
  bike,
  terrain,
}

extension LayerIdsToString on MapLayerIds {
  String enumToString() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Streets",
      MapLayerIds.satellite: "Satellite",
      MapLayerIds.bike: "Bike",
      MapLayerIds.terrain: "Terrain",
    };

    return enumStrings[this]!;
  }

  String enumToStringDE() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Straßen",
      MapLayerIds.satellite: "Satellit",
      MapLayerIds.bike: "Fahrrad",
      MapLayerIds.terrain: "Fahrrad",
    };

    return enumStrings[this]!;
  }

  String enumToStringEN() {
    final Map<MapLayerIds, String> enumStrings = {
      MapLayerIds.streets: "Streets",
      MapLayerIds.satellite: "Satellite",
      MapLayerIds.bike: "Bike",
      MapLayerIds.terrain: "Bike",
    };

    return enumStrings[this]!;
  }
}

List<Widget> mapLayerOptions(MapLayerIds id, BuildContext context) {
  switch (id) {
    case MapLayerIds.streets:
      return [
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate: "https://tiles.stadtnavi.eu/streets/{z}/{x}/{y}@2x.png",
        ),
      ];
    case MapLayerIds.satellite:
      return [
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate:
              "https://tiles.stadtnavi.eu/orthophoto/{z}/{x}/{y}.jpg",
        ),
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          backgroundColor: Colors.transparent,
          urlTemplate:
              "https://tiles.stadtnavi.eu/satellite-overlay/{z}/{x}/{y}@2x.png",
        ),
      ];
    case MapLayerIds.bike:
      return [
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate: "https://tiles.stadtnavi.eu/bicycle/{z}/{x}/{y}@2x.png",
          subdomains: const ["a", "b", "c"],
        ),
      ];
    case MapLayerIds.terrain:
      return [
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate:
              "https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png",
          subdomains: const ["a", "b", "c"],
        ),
      ];
    default:
      return [];
  }
}

Map<MapLayerIds, String> layerImage = {
  MapLayerIds.streets: "assets/images/maptype-streets.png",
  MapLayerIds.satellite: "assets/images/maptype-satellite.png",
  MapLayerIds.bike: "assets/images/maptype-bicycle.png",
  MapLayerIds.terrain: "assets/images/maptype-terrain.png",
};

class MapLayer extends MapTileProvider {
  final MapLayerIds mapLayerId;
  final String? mapKey;

  MapLayer(
    this.mapLayerId, {
    this.mapKey,
  }) : super();

  @override
  List<Widget> buildTileLayerOptions(BuildContext context) {
    return mapLayerOptions(mapLayerId, context);
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
  BuildContext context;
  CustomTileProvider(
      {this.headers = const {"Referer": "https://herrenberg.stadtnavi.de/"},
      required this.context});
  @override
  ImageProvider getImage(Coords<num> coords, TileLayer options) {
    if (coords.z.toInt() > 12) {
      _fetchPBF(coords);
    }
    return CachedNetworkImageProvider(getTileUrl(coords, options),
        headers: headers);
  }

  Future<void> _fetchPBF(Coords<num> coords) async {
    // final layersStatus = context.read<CustomLayersCubit>().state.layersSatus;
    // if (layersStatus["Sharing"] ?? false) {
    log("Tile coords: ${coords.z} ${coords.x} ${coords.y}");
    await CityBikesLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }
    // if (StopsLayerIds.values
    //     .any((element) => layersStatus[element.enumToString()] ?? false)) {
    await StopsLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }
    // if (layersStatus["Parking"] ?? false) {
    await ParkingLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }
    // if (layersStatus["Bike Parking Space"] ?? false) {
    await BikeParkLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }

    // if (layersStatus["Roadworks"] ?? false) {
    await CifsLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }

    // if (layersStatus["Road Weather"] ?? false) {
    await WeatherLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }
    // if (layersStatus["Charging"] ?? false) {
    await ChargingLayer.fetchPBF(
      coords.z.toInt(),
      coords.x.toInt(),
      coords.y.toInt(),
    ).catchError((error) {
      log("$error");
    });
    // }
  }
}
