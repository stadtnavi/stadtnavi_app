import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/quad_tree.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

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

  List<Widget> mapLayerOptions(MapLayerIds id, BuildContext context) {
    final codes = context.read<CustomLayersCubit>().getActiveLayersCode();

    return [
      if (id == MapLayerIds.streets)
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate: "https://tiles.stadtnavi.eu/streets/{z}/{x}/{y}@2x.png",
        ),
      if (id == MapLayerIds.satellite) ...[
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate: "https://tiles.stadtnavi.eu/orthophoto/{z}/{x}/{y}.jpg",
        ),
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          // backgroundColor: Colors.transparent,
          urlTemplate:
              "https://tiles.stadtnavi.eu/satellite-overlay/{z}/{x}/{y}@2x.png",
        ),
      ],
      if (id == MapLayerIds.bike)
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate: "https://tiles.stadtnavi.eu/bicycle/{z}/{x}/{y}@2x.png",
          subdomains: const ["a", "b", "c"],
        ),
      if (id == MapLayerIds.terrain)
        TileLayer(
          tileProvider: CustomTileProvider(context: context),
          urlTemplate:
              "https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png",
          subdomains: const ["a", "b", "c"],
        ),
      if (codes.contains("cycle_network"))
        TileLayer(
          wmsOptions: WMSTileLayerOptions(
            baseUrl: 'https://api.mobidata-bw.de/geoserver/MobiData-BW/wms?',
            layers: ['MobiData-BW:radvis_cycle_network'],
            format: 'image/png',
            transparent: true,
            version: "1.1.1",
          ),
          tileProvider: CustomTileProvider(context: context),
        ),
    ];
  }
}

class CustomTileProvider extends TileProvider {
  final Map<String, String> customHeaders;

  final BuildContext context;
  CustomTileProvider({
    this.customHeaders = const {"Referer": "https://herrenberg.stadtnavi.de/"},
    required this.context,
  });
  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    if (coords.z.toInt() > CustomLayer.minRenderMarkers) {
      _fetchPBF(coords);
    }
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      headers: customHeaders,
    );
  }

  Future<void> _fetchPBF(TileCoordinates coords) async {
    final types = context.read<CustomLayersCubit>().getActiveLayersType();
    final mapLayersFiltered = [
      if (types.contains(CityBikesLayer))
        CityBikesLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(StopsLayer))
        StopsLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(ParkingLayer))
        ParkingLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(MapPoiLayer))
        MapPoiLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(BikeParkLayer))
        BikeParkLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(RoadworksLayer))
        RoadworksLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(WeatherLayer))
        WeatherLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(ChargingLayer))
        ChargingLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        )
    ];
    await Future.wait(mapLayersFiltered).catchError((error) {
      log("$error");
    });
  }
}
