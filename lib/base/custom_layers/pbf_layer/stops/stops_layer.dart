import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide MapConfigurationCubit, cachedFirstFetch;
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal/stop_marker_modal.dart';

class StopsLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  StopsLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);

  TrufiMarker _buildTrufiMarker({
    required StopFeature element,
    required double markerSize,
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      element.type.toLowerCase(),
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvgMenu;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return TrufiMarker(
      id: "$id:${element.gtfsId}",
      position: element.position,
      size: Size(lastMarkerSize, lastMarkerSize),
      alignment: Alignment.topCenter,
      imageCacheKey: isSelected
          ? 'stop_selected_${element.type}'
          : 'stop_${element.type}',
      buildPanel: (context) {
        return StopMarkerModal(
          category: mapCategory,
          stopFeature: element,
        );
      },
      widget: Container(
        padding: isSelected ? const EdgeInsets.all(1) : null,
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              )
            : null,
        child: SvgPicture.string(svgIcon ?? ''),
      ),
    );
  }

  List<StopFeature> _cachedStopMarkers = [];
  int _lastStopZoom = -1;
  int _lastStopItemsLength = -1;

  List<StopFeature> _getFeatures(int zoom) {
    final itemsLength = MapMarkersRepositoryContainer.stopFeature.items.length;

    if (zoom == _lastStopZoom && itemsLength == _lastStopItemsLength) {
      return _cachedStopMarkers;
    }

    _lastStopZoom = zoom;
    _lastStopItemsLength = itemsLength;

    _cachedStopMarkers = MapMarkersRepositoryContainer.stopFeature.items
        .where((element) => element.type.toLowerCase() == mapCategory.code)
        .where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        element.type.toLowerCase(),
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 13;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedStopMarkers;
  }

  @override
  List<TrufiMarker> buildTrufiMarkers(int zoom) {
    return _getFeatures(zoom)
        .map((element) => _buildTrufiMarker(
            element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
        .toList();
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: 'https',
      host: ApiConfig().baseDomain,
      path: '/otp/routers/default/vectorTiles/stops/$z/$x/$y.pbf',
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final StopFeature? pointFeature =
              StopFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.stopFeature.add(pointFeature);
          }
        } else {
          throw Exception('Should never happened, Feature is not a point');
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
    final icon = mapCategory.properties?.iconSvgMenu ??
        mapCategory.categories.first.properties?.iconSvgMenu;

    if (icon != null) return SvgPicture.string(icon);
    return const Icon(
      Icons.error,
      color: Colors.orange,
    );
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
}
