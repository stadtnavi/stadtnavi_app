import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
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


import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_provider.dart';

/// [TileProvider] that fetches tiles from the network, with the capability to
/// cancel unnecessary HTTP tile requests
///
/// {@template fmctp-desc}
///
/// Tiles that are removed/pruned before they are fully loaded do not need to
/// complete (down)loading, and therefore do not need to complete the HTTP
/// interaction. Cancelling these unnecessary tile requests early could:
///
/// - Reduce tile loading durations (particularly on the web)
/// - Reduce users' (cellular) data and cache space consumption
/// - Reduce costly tile requests to tile servers*
/// - Improve performance by reducing CPU and IO work
///
/// This provider uses '[dio](https://pub.dev/packages/dio)', which supports
/// aborting unnecessary HTTP requests in-flight, after they have already been
/// sent.
///
/// Although HTTP request abortion is supported on all platforms, it is
/// especially useful on the web - and therefore recommended for web apps. This
/// is because the web platform has a limited number of simulatous HTTP requests,
/// and so closing the requests allows new requests to be made for new tiles.
/// On other platforms, the other benefits may still occur, but may not be as
/// visible as on the web.
///
/// Once HTTP request abortion is
/// [added to Dart's 'native' 'http' package (which already has a PR opened)](https://github.com/dart-lang/http/issues/424),
/// `NetworkTileProvider` will be updated to take advantage of it, replacing and
/// deprecating this provider. This tile provider is currently a seperate package
/// and not the default due to the reliance on the additional Dio dependency.
///
/// ---
///
/// On the web, the 'User-Agent' header cannot be changed as specified in
/// [TileLayer.tileProvider]'s documentation, due to a Dart/browser limitation.
///
/// The [silenceExceptions] argument controls whether to ignore exceptions and
/// errors that occur whilst fetching tiles over the network, and just return a
/// transparent tile.
/// {@endtemplate}
base class CancellableNetworkTileProvider extends TileProvider {
  /// Create a [CancellableNetworkTileProvider] to fetch tiles from the network,
  /// with cancellation support
  ///
  /// {@macro fmctp-desc}
  /// 
  final BuildContext context;
  CancellableNetworkTileProvider( {required this.context,
    super.headers,
    Dio? dioClient,
    this.silenceExceptions = false,
  })  : _isInternallyCreatedClient = dioClient == null,
        _dioClient = dioClient ?? Dio();

  /// Whether to ignore exceptions and errors that occur whilst fetching tiles
  /// over the network, and just return a transparent tile
  final bool silenceExceptions;

  /// Long living client used to make all tile requests by [CancellableNetworkImageProvider]
  /// for the duration that this provider is alive
  ///
  /// Not automatically closed if created externally and passed as an argument
  /// during construction.
  final Dio _dioClient;

  /// Whether [_dioClient] was created on construction (and not passed in)
  final bool _isInternallyCreatedClient;

  /// Each [Completer] is completed once the corresponding tile has finished
  /// loading
  ///
  /// Used to avoid disposing of [_dioClient] whilst HTTP requests are still
  /// underway.
  ///
  /// Does not include tiles loaded from session cache.
  final _tilesInProgress = HashMap<TileCoordinates, Completer<void>>();

  @override
  bool get supportsCancelLoading => true;

  @override
  ImageProvider getImageWithCancelLoadingSupport(
    TileCoordinates coordinates,
    TileLayer options,
    Future<void> cancelLoading,
  ) {
    if (coordinates.z.toInt() > CustomLayer.minRenderMarkers) {
      _fetchPBF(coordinates);
    }
    return CancellableNetworkImageProvider(
        url: getTileUrl(coordinates, options),
        fallbackUrl: getTileFallbackUrl(coordinates, options),
        headers:  {
        "Referer": "https://herrenberg.stadtnavi.de/",
      },
        dioClient: _dioClient,
        cancelLoading: cancelLoading,
        silenceExceptions: silenceExceptions,
        startedLoading: () => _tilesInProgress[coordinates] = Completer(),
        finishedLoadingBytes: () {
          _tilesInProgress[coordinates]?.complete();
          _tilesInProgress.remove(coordinates);
        },
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
        ),
      if (types.contains(CarSharingLayer))
        CarSharingLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        ),
      if (types.contains(ScooterLayer))
        ScooterLayer.fetchPBF(
          coords.z.toInt(),
          coords.x.toInt(),
          coords.y.toInt(),
        )
    ];
    await Future.wait(mapLayersFiltered).catchError((error) {
      log("$error");
      return [];
    });
  }
  @override
  Future<void> dispose() async {
    if (_tilesInProgress.isNotEmpty) {
      await Future.wait(_tilesInProgress.values.map((c) => c.future));
    }
    if (_isInternallyCreatedClient) _dioClient.close();
    super.dispose();
  }
}
