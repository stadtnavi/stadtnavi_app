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
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'charging_feature_model.dart';
import 'charging_marker_modal.dart';

class ChargingLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  ChargingLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);
  Marker buildMarker({
    required ChargingFeature element,
    required double markerSize,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    return Marker(
      key: Key("$id:${element.id}"),
      height: markerSize + 5,
      width: markerSize + 5,
      point: element.position,
      alignment: Alignment.topCenter,
      child: Builder(builder: (context) {
        final languageCode = Localizations.localeOf(context).languageCode;
        final isEnglishCode = languageCode == 'en';
        final availabilityStatus = element.getAvailabilityStatus();
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
                      ChargingMarkerModal(
                    element: element,
                    onFetchPlan: onFetchPlan,
                  ),
                  position: element.position,
                  minSize: 50,
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: markerSize / 5,
                    top: markerSize / 5,
                  ),
                  child: svgIcon != null
                      ? SvgPicture.string(
                          svgIcon,
                        )
                      : const Icon(Icons.error),
                ),
                if (availabilityStatus != null)
                  SizedBox(
                    height: markerSize / 1.8,
                    width: markerSize / 1.8,
                    child: availabilityStatus.getImage(),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<ChargingFeature> _cachedChargingMarkers = [];
  int _lastChargingZoom = -1;
  int _lastChargingItemsLength = -1;

  List<ChargingFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.chargingFeature.items.length;

    if (zoom == _lastChargingZoom && itemsLength == _lastChargingItemsLength) {
      return _cachedChargingMarkers;
    }

    _lastChargingZoom = zoom;
    _lastChargingItemsLength = itemsLength;

    _cachedChargingMarkers =
        MapMarkersRepositoryContainer.chargingFeature.items.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedChargingMarkers;
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
      host: ApiConfig().baseDomain,
      path: "/tiles/charging-stations/$z/$x/$y.mvt",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ChargingFeature? pointFeature =
              ChargingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.chargingFeature.add(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
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
