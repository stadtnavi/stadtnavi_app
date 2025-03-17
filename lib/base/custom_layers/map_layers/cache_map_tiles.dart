import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/carsharing_layer.dart';

import 'dart:ui' as ui;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/scooter/scooter_layer.dart';
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
    return CachedTileImageProvider(url);
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
}

final Map<Uri, bool> _cache = {};

Future<Uint8List> cachedFirstFetch(Uri uri) async {
  if (_cache.containsKey(uri)) {
    // print("cachedFirstFetch ${uri.path}");
    throw Exception(
      "already fetched",
    );
  }

  _cache[uri] = true;
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    _cache[uri] = false;
    throw Exception(
      "Server Error on fetchPBF $uri with ${response.statusCode}",
    );
  }

  return response.bodyBytes;
}

class CachedTileImageProvider extends ImageProvider<CachedTileImageProvider> {
  final String url;
  static final BaseCacheManager _cacheManager = CustomCacheManager.instance;

  const CachedTileImageProvider(this.url);

  @override
  Future<CachedTileImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedTileImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CachedTileImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(ImageDecoderCallback decode) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    Uint8List bytes;

    if (fileInfo != null) {
      // print("Loaded from disk cache: $url");
      bytes = await fileInfo.file.readAsBytes();
    } else {
      // print("Downloading: $url");
      final response = await http.get(Uri.parse(url), headers: {
        "Referer": "https://herrenberg.stadtnavi.de/",
      });

      if (response.statusCode != 200) {
        throw Exception("Failed to load image: $url");
      }

      bytes = response.bodyBytes;
      await _cacheManager.putFile(url, bytes);
    }

    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) =>
      other is CachedTileImageProvider && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

class CustomCacheManager extends CacheManager {
  static const String key = "customTileCache";

  static final CustomCacheManager instance = CustomCacheManager._internal();

  factory CustomCacheManager() {
    return instance;
  }

  CustomCacheManager._internal()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 20), // Cache expiration time
            maxNrOfCacheObjects: 500, // Max cache size (adjust as needed)
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
        );
}
