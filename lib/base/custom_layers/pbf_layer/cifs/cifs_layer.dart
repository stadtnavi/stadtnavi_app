import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/bike_parks_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'cifs_feature_model.dart';
import 'cifs_icons.dart';
import 'cifs_marker_modal.dart';

class RoadworksLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  RoadworksLayer(this.mapCategory, int weight)
      : super(mapCategory.code, weight);

  List<RoadworksFeature> _cachedRoadworksMarkers = [];
  int _lastRoadworksZoom = -1;
  int _lastRoadworksItemsLength = -1;

  List<RoadworksFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.roadworksFeature.items.length;

    if (zoom == _lastRoadworksZoom &&
        itemsLength == _lastRoadworksItemsLength) {
      return _cachedRoadworksMarkers;
    }

    _lastRoadworksZoom = zoom;
    _lastRoadworksItemsLength = itemsLength;

    _cachedRoadworksMarkers =
        MapMarkersRepositoryContainer.roadworksFeature.items.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedRoadworksMarkers;
  }

  @override
  Widget buildMarkerLayer(int zoom) {
    double? polylineSize;
    switch (zoom) {
      case 13:
        polylineSize = 3;
        break;
      case 14:
        polylineSize = 4;
        break;
      case 15:
        polylineSize = 5;
        break;
      case 16:
        polylineSize = 6;
        break;
      case 17:
        polylineSize = 7;
        break;
      case 18:
        polylineSize = 8;
        break;
      default:
        polylineSize = (zoom > 18) ? 8 : null;
    }
    final markersList = _getMarkers(zoom);

    final markerSize = CustomLayer.getMarkerSize(zoom);
    return Stack(
      children: [
        if (polylineSize != null)
          PolylineLayer(
            polylines: markersList
                .map((e) => Polyline(
                      points: e.polyline.reversed.toList(),
                      color: Colors.red.withOpacity(.8),
                      pattern: const StrokePattern.dotted(),
                      strokeWidth: polylineSize!,
                    ))
                .toList(),
          ),
        MarkerLayer(
          markers: [
            ...markersList
                .map((element) => Marker(
                      height: markerSize,
                      width: markerSize,
                      point: element.startPoint,
                      alignment: Alignment.center,
                      child: _RoadworksFeatureMarker(
                        element: element,
                        point: element.startPoint,
                      ),
                    ))
                .toList(),
            ...markersList
                .map((element) => Marker(
                      height: markerSize,
                      width: markerSize,
                      point: element.endPoint,
                      alignment: Alignment.center,
                      child: _RoadworksFeatureMarker(
                        element: element,
                        point: element.endPoint,
                      ),
                    ))
                .toList(),
          ],
        ),
      ],
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/map/v1/cifs/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.LineString) {
          final geojson = feature.toGeoJson<GeoJsonLineString>(
            x: x,
            y: y,
            z: z,
          );
          final RoadworksFeature? pointFeature =
              RoadworksFeature.fromGeoJsonLine(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.roadworksFeature.add(pointFeature);
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
      color: Colors.blue,
    );
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
}

class _RoadworksFeatureMarker extends StatelessWidget {
  final RoadworksFeature element;
  final LatLng point;
  const _RoadworksFeatureMarker({
    Key? key,
    required this.element,
    required this.point,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final panelCubit = context.read<PanelCubit>();
        panelCubit.setPanel(
          CustomMarkerPanel(
            panel: (
              context,
              onFetchPlan, {
              isOnlyDestination,
            }) =>
                CifsMarkerModal(
              element: element,
              onFetchPlan: onFetchPlan,
              position: point,
            ),
            position: point,
            minSize: 50,
          ),
        );
      },
      child: element.type == CifsTypeIds.roadClosed &&
              element.locationDirection == 'BOTH_DIRECTIONS'
          ? cifsIcons[element.type] != null
              ? SvgPicture.string(
                  cifsIcons[element.type] ?? '',
                )
              : const Icon(Icons.error)
          : SvgPicture.string(
              cifsIcons[CifsTypeIds.construction]!,
            ),
    );
  }
}
