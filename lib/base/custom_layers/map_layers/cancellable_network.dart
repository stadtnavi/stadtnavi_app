import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit;

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/carsharing_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/scooter/scooter_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';

/// Fetches PBF vector tiles for custom layers when the camera changes.
/// Replaces the old CancellableNetworkTileProvider that extended flutter_map's TileProvider.
class PbfTileFetcher {
  int? _lastZ;
  int? _lastX;
  int? _lastY;

  /// Called when the map camera changes. Fetches PBF tiles for active layers.
  Future<void> onCameraChanged(
    TrufiCameraPosition camera,
    BuildContext context,
  ) async {
    final zoom = camera.zoom.floor();
    if (zoom <= CustomLayer.minRenderMarkers) return;

    final bounds = camera.visibleRegion;
    if (bounds == null) return;

    // Calculate center tile
    final centerTile = TileUtils.latLonToTileXY(
      camera.target.latitude,
      camera.target.longitude,
      zoom,
    );

    final x = centerTile.x;
    final y = centerTile.y;

    // Skip if same tile
    if (_lastZ == zoom && _lastX == x && _lastY == y) return;
    _lastZ = zoom;
    _lastX = x;
    _lastY = y;

    // Get visible tile range
    final range = TileUtils.tileRangeForBounds(
      southWest: bounds.southWest,
      northEast: bounds.northEast,
      z: zoom,
    );

    final types = context.read<CustomLayersCubit>().getActiveLayersType();

    for (var tx = range.minX; tx <= range.maxX; tx++) {
      for (var ty = range.minY; ty <= range.maxY; ty++) {
        _fetchPBFForTile(zoom, tx, ty, types);
      }
    }
  }

  Future<void> _fetchPBFForTile(
      int z, int x, int y, List<Type> types) async {
    final mapLayersFiltered = [
      if (types.contains(CityBikesLayer))
        CityBikesLayer.fetchPBF(z, x, y),
      if (types.contains(StopsLayer))
        StopsLayer.fetchPBF(z, x, y),
      if (types.contains(ParkingLayer))
        ParkingLayer.fetchPBF(z, x, y),
      if (types.contains(MapPoiLayer))
        MapPoiLayer.fetchPBF(z, x, y),
      if (types.contains(BikeParkLayer))
        BikeParkLayer.fetchPBF(z, x, y),
      if (types.contains(RoadworksLayer))
        RoadworksLayer.fetchPBF(z, x, y),
      if (types.contains(WeatherLayer))
        WeatherLayer.fetchPBF(z, x, y),
      if (types.contains(ChargingLayer))
        ChargingLayer.fetchPBF(z, x, y),
      if (types.contains(CarSharingLayer))
        CarSharingLayer.fetchPBF(z, x, y),
      if (types.contains(ScooterLayer))
        ScooterLayer.fetchPBF(z, x, y),
    ];
    await Future.wait(mapLayersFiltered).catchError((error) {
      log("PBF fetch error: $error");
      return [];
    });
  }
}
