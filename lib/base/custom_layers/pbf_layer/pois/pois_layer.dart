import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'poi_feature_model.dart';
import 'poi_marker_modal.dart';

class MapPoiLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  MapPoiLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);

  Marker buildMarker({
    required PoiFeature element,
    required double markerSize,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      element.category3,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    return Marker(
      key: Key("$id:${element.osmId}"),
      height: markerSize,
      width: markerSize,
      point: element.position,
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        final languageCode = Localizations.localeOf(context).languageCode;
        final isEnglishCode = languageCode == 'en';
        return MarkerTileContainer(
          menuBuilder: (_) {
            return MarkerTileListItem(
              // element: element,
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
              );
            },
            child: svgIcon != null
                ? SvgPicture.string(svgIcon)
                : const Icon(Icons.error),
          ),
        );
      }),
    );
  }

  List<PoiFeature> _cachedMarkers = [];
  int _lastZoom = -1;
  int _lastItemsLength = -1;

  List<PoiFeature> _getMarkers(int zoom) {
    final itemsLength = MapMarkersRepositoryContainer.poiFeatures.items.length;

    if (zoom == _lastZoom && itemsLength == _lastItemsLength) {
      return _cachedMarkers;
    }

    _lastZoom = zoom;
    _lastItemsLength = itemsLength;

    _cachedMarkers = MapMarkersRepositoryContainer.poiFeatures.items
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

    return _cachedMarkers;
  }

  @override
  List<Marker>? buildClusterMarkers(int zoom) {
    return _getMarkers(zoom)
        .map((element) => buildMarker(
            element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
        .toList();
  }

  @override
  Widget buildMarkerLayer(int zoom) {
    return MarkerLayer(
      markers: _getMarkers(zoom)
          .map((element) => buildMarker(
              element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
          .toList(),
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
            // final pbfLayer =
            //     StaticTileLayers.poisLayers[pointFeature.category2];
            // pbfLayer?.addMarker(pointFeature);
          }
        } else {
          throw Exception(
              "It should never have happened. A feature is not a point");
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
      color: Colors.green,
    );
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
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
