import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

class CachedTileProvider extends TileProvider {
  final BaseCacheManager cacheManager = DefaultCacheManager();
  final BuildContext context;
  CachedTileProvider({
    required this.context,
  });

  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    if (coords.z.toInt() > CustomLayer.minRenderMarkers) {
      _fetchPBF(coords);
    }
    final url = getTileUrl(coords, options);
    return _CachedTileImageProvider(url, cacheManager);
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

Future<Uint8List> cachedFirstFetch(Uri uri) async {
  final cacheManager = DefaultCacheManager();

  FileInfo? cachedFile = await cacheManager.getFileFromCache(uri.toString());

  Uint8List bodyByte;

  if (cachedFile != null) {
    // print("cachedFirstFetch");
    bodyByte = await cachedFile.file.readAsBytes();
  } else {
    // print("no cachedFirstFetch");
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    bodyByte = response.bodyBytes;
    final fileExtension = uri.path.split('.').last;
    await cacheManager.putFile(
      uri.toString(),
      bodyByte,
      fileExtension: fileExtension,
      maxAge: const Duration(
        days: 7,
      ),
    );
  }
  return bodyByte;
}

class _CachedTileImageProvider extends ImageProvider<_CachedTileImageProvider> {
  final String url;
  final BaseCacheManager cacheManager;

  const _CachedTileImageProvider(this.url, this.cacheManager);

  @override
  Future<_CachedTileImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_CachedTileImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _CachedTileImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
    );
  }

  Future<Codec> _loadAsync(ImageDecoderCallback decode) async {
    final cachedFile = await cacheManager.getFileFromCache(url);

    Uint8List bytes;

    if (cachedFile != null && cachedFile.file.existsSync()) {
      // print("cached");
      bytes = await cachedFile.file.readAsBytes();
    } else {
      // print("new fetch");
      final downloadedFile = await cacheManager.downloadFile(
        url,
        authHeaders: {"Referer": "https://herrenberg.stadtnavi.de/"},
      );
      bytes = await downloadedFile.file.readAsBytes();
    }

    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) =>
      other is _CachedTileImageProvider && other.url == url;

  @override
  int get hashCode => url.hashCode;
}
