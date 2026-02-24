import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/models/map_layer_category.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

/// Base class for PBF vector-tile point layers.
///
/// Provides common caching, zoom filtering, marker/cluster building,
/// tile fetching, name/icon/isDefaultOn implementations.
///
/// Subclasses only need to implement:
/// - [repository] — which [SortedList] holds the features
/// - [pbfPath] — API path segment (e.g. "/otp/routers/default/vectorTiles/parking")
/// - [parseFeature] — factory from decoded GeoJsonPoint
/// - [buildFeatureMarker] — visual rendering of one marker
abstract class PbfPointLayer<T> extends CustomLayer {
  final MapLayerCategory mapCategory;

  PbfPointLayer(this.mapCategory, int weight)
      : super(mapCategory.code, weight);

  // ---- Subclass must implement ----

  /// The repository (SortedList) that holds features of this type.
  SortedList<T> get repository;

  /// The API path segment for PBF tiles (without /{z}/{x}/{y}.pbf).
  String get pbfPath;

  /// Parse a decoded GeoJsonPoint into a feature, or null to skip.
  T? parseFeature(GeoJsonPoint? geoJson);

  /// Build a Flutter Map [Marker] for one feature.
  Marker buildFeatureMarker(
    T element,
    double markerSize, {
    bool isSelected = false,
  });

  // ---- Optional overrides ----

  /// Extra per-feature filter (e.g. StopsLayer filters by transport type).
  /// Return true to include the feature.
  bool filterFeature(T element, int zoom) => true;

  /// Default minimum zoom when the layer category doesn't specify one.
  int get defaultMinZoom => 15;

  // ---- Common implementation ----

  List<T> _cachedMarkers = [];
  int _lastZoom = -1;
  int _lastItemsLength = -1;

  List<T> getMarkers(int zoom) {
    final itemsLength = repository.items.length;

    if (zoom == _lastZoom && itemsLength == _lastItemsLength) {
      return _cachedMarkers;
    }

    _lastZoom = zoom;
    _lastItemsLength = itemsLength;

    _cachedMarkers = repository.items.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? defaultMinZoom;
      return layerMinZoom < zoom && filterFeature(element, zoom);
    }).toList();

    return _cachedMarkers;
  }

  @override
  List<Marker>? buildClusterMarkers(int zoom) {
    return getMarkers(zoom)
        .map((e) => buildFeatureMarker(e, CustomLayer.getMarkerSize(zoom)))
        .toList();
  }

  @override
  Widget buildMarkerLayer(int zoom) {
    return MarkerLayer(
      markers: getMarkers(zoom)
          .map((e) => buildFeatureMarker(e, CustomLayer.getMarkerSize(zoom)))
          .toList(),
    );
  }

  /// Fetch PBF tile data and populate the [repository].
  ///
  /// Uses the standard OTP vectorTiles pattern.
  /// Override for layers with non-standard URLs.
  Future<void> fetchTileData(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "$pbfPath/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final T? pointFeature = parseFeature(geojson);
          if (pointFeature != null) {
            repository.add(pointFeature);
          }
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en" ? mapCategory.en : mapCategory.de;
  }

  @override
  Widget icon(BuildContext context) {
    final iconStr = mapCategory.properties?.iconSvgMenu ??
        mapCategory.categories.first.properties?.iconSvgMenu;
    if (iconStr != null) return SvgPicture.string(iconStr);
    return const Icon(Icons.error, color: Colors.blue);
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
}
