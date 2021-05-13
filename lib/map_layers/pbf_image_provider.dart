import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/raw/raw_vector_tile.dart';

class PBFTileProvider extends TileProvider {
  Map<String, String> headers;
  PBFTileProvider({
    this.headers = const {"Referer": "https://herrenberg.stadtnavi.de/"},
  });
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return PBFImageProvider(coords, options);
  }
}

class PBFImageProvider implements ImageProvider<PBFImageProvider> {
  final Coords<num> coords;
  final TileLayerOptions options;

  PBFImageProvider(this.coords, this.options) {
    _fetchPBF(coords.z.toInt(), coords.x.toInt(), coords.y.toInt())
        .catchError((error) {});
  }

  @override
  ImageStream createStream(ImageConfiguration configuration) {
    // TODO: implement createStream
    throw UnimplementedError();
  }

  @override
  Future<bool> evict(
      {ImageCache cache,
      ImageConfiguration configuration = ImageConfiguration.empty}) {
    // TODO: implement evict
    throw UnimplementedError();
  }

  @override
  ImageStreamCompleter load(PBFImageProvider key, decode) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<ImageCacheStatus> obtainCacheStatus(
      {ImageConfiguration configuration, handleError}) {
    // TODO: implement obtainCacheStatus
    throw UnimplementedError();
  }

  @override
  Future<PBFImageProvider> obtainKey(ImageConfiguration configuration) {
    // TODO: implement obtainKey
    throw UnimplementedError();
  }

  @override
  ImageStream resolve(ImageConfiguration configuration) {
    // TODO: implement resolve
    throw UnimplementedError();
  }

  @override
  void resolveStreamForKey(ImageConfiguration configuration, ImageStream stream,
      PBFImageProvider key, handleError) {
    // TODO: implement resolveStreamForKey
  }
}

Future<void> _fetchPBF(int z, int x, int y) async {
  final uri = Uri(
    scheme: "https",
    host: "api.stadtnavi.de",
    path: "/map/v1/stop-map/$z/$x/$y.pbf",
  );
  final response = await http.get(uri);
  final bodyByte = response.bodyBytes;
  final byte = bodyByte.buffer
      .asUint8List(bodyByte.offsetInBytes, bodyByte.lengthInBytes);
  final tile = VectorTile.fromBuffer(byte);
  log(uri.toString());
  for (final VectorTile_Layer element in tile.layers) {
    log("\n =====>  ${element.name}");
    if (element.name == "stops") {
      final List<StopData> stops = [];
      for (final VectorTile_Value value in element.values) {
        if (value.hasStringValue()) {
          try {
            final list = jsonDecode(value.stringValue) as List;

            for (final dynamic listElement in list) {
              final StopData stopData = StopData(
                headsign: listElement["headsign"].toString(),
                type: listElement["headsign"].toString(),
                shortName: listElement["headsign"].toString(),
              );
              stops.add(stopData);
            }
          } catch (e) {
            // log("error=> ${value.stringValue}");
          }
        } else {
          log("else string");
        }
      }

      log("stops: ${stops.length}, features: ${element.features.length}");
      log(stops.toString());
      for (final VectorTile_Feature feature in element.features) {
        log("type: ${feature.type.name} geometry: ${feature.geometry.toList()}");
      }
    }
  }
}

class StopData {
  final String headsign;
  final String type;
  final String shortName;

  StopData({
    @required this.headsign,
    @required this.type,
    @required this.shortName,
  });
  @override
  String toString() {
    return "{$headsign, $type, $shortName} ";
  }
}
