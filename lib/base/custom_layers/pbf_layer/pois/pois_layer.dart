import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/data/markers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pbf_point_layer.dart';
import 'poi_feature_model.dart';
import 'poi_marker_modal.dart';

class MapPoiLayer extends PbfPointLayer<PoiFeature> {
  MapPoiLayer(super.mapCategory, super.weight);

  @override
  SortedList<PoiFeature> get repository =>
      MapMarkersRepositoryContainer.poiFeatures;

  /// Not used directly — MapPoiLayer uses a custom URL in fetchPBF.
  @override
  String get pbfPath => "";

  @override
  PoiFeature? parseFeature(GeoJsonPoint? geoJson) =>
      PoiFeature.fromGeoJsonPoint(geoJson);

  @override
  List<PoiFeature> getMarkers(int zoom) {
    final itemsLength = repository.items.length;

    if (zoom == _lastZoom && itemsLength == _lastItemsLength) {
      return _cachedPoiMarkers;
    }

    _lastZoom = zoom;
    _lastItemsLength = itemsLength;

    _cachedPoiMarkers = repository.items
        .where((element) => mapCategory.code == element.category2)
        .where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        element.category3,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedPoiMarkers;
  }

  List<PoiFeature> _cachedPoiMarkers = [];
  int _lastZoom = -1;
  int _lastItemsLength = -1;

  @override
  Marker buildFeatureMarker(
    PoiFeature element,
    double markerSize, {
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      element.category3,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return Marker(
      key: Key("$id:${element.osmId}"),
      height: lastMarkerSize,
      width: lastMarkerSize,
      point: element.position,
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        final languageCode = Localizations.localeOf(context).languageCode;
        final isEnglishCode = languageCode == 'en';
        return MarkerTileContainer(
          menuBuilder: (_) {
            return MarkerTileListItem(
              icon: svgIcon != null
                  ? SvgPicture.string(
                      svgIcon,
                    )
                  : const Icon(Icons.error),
              name: element.name ??
                  (isEnglishCode
                      ? targetMapLayerCategory?.en
                      : targetMapLayerCategory?.de) ??
                  "",
            );
          },
          child: GestureDetector(
            onTap: () {
              final panelCubit = context.read<PanelCubit>();
              final selectedMarker = buildFeatureMarker(
                element,
                markerSize,
                isSelected: true,
              );
              panelCubit.setPanel(
                CustomMarkerPanel(
                  panel: (
                    context,
                    onFetchPlan, {
                    isOnlyDestination,
                  }) =>
                      PoiMarkerModal(
                    element: element,
                    onFetchPlan: onFetchPlan,
                    targetMapLayerCategory: targetMapLayerCategory,
                  ),
                  position: element.position,
                  minSize: 50,
                ),
                selectedMarker: selectedMarker,
              );
            },
            child: Container(
              padding: isSelected ? const EdgeInsets.all(1) : null,
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    )
                  : null,
              child: svgIcon != null
                  ? SvgPicture.string(svgIcon)
                  : const Icon(Icons.error),
            ),
          ),
        );
      }),
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "features.stadtnavi.eu",
      path: "/public.pois/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);

          final PoiFeature? pointFeature = PoiFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.poiFeatures.add(pointFeature);
          }
        } else {
          throw Exception(
              "It should never have happened. A feature is not a point");
        }
      }
    }
  }
}

Color fromStringToColor(String? colorString) {
  if (colorString == null) return Colors.black;
  try {
    String hexColor = colorString.replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    if (hexColor.length != 8) return Colors.black;
    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    return Colors.black;
  }
}
