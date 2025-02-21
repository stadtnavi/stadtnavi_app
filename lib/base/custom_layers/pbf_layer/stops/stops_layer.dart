import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal/stop_marker_modal.dart';

class StopsLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  StopsLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);
  Marker buildMarker({
    required StopFeature element,
    required double markerSize,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      element.type.toLowerCase(),
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvgMenu;
    return Marker(
      key: Key("$id:${element.gtfsId}"),
      height: markerSize,
      width: markerSize ,
      point: element.position,
      alignment: Alignment.topCenter,
      child: Builder(builder: (context) {
        return MarkerTileContainer(
          menuBuilder: (_) => MarkerTileListItem(
            name: element.name ?? "",
            icon: svgIcon != null
                ? SvgPicture.string(
                    svgIcon,
                  )
                : const Icon(Icons.error),
          ),
          child: GestureDetector(
            onTap: () {
              final panelCubit = context.read<PanelCubit>();
              panelCubit.setPanel(
                CustomMarkerPanel(
                  panel: (
                    context,
                    _, {
                    isOnlyDestination,
                  }) =>
                      StopMarkerModal(
                    category: mapCategory,
                    stopFeature: element,
                  ),
                  position: element.position,
                  minSize: 130,
                ),
              );
            },
            child: SvgPicture.string(svgIcon ?? ''),
          ),
        );
      }),
    );
  }

  List<StopFeature> _getMarkers(int zoom) {
    final markersList = MapMarkersRepositoryContainer.stopFeature.values.toList();
    markersList.sort(
      (a, b) => a.position.latitude.compareTo(b.position.latitude),
    );
    return markersList.where((element) {
      return element.type.toLowerCase() == mapCategory.code;
    }) .where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        element.type.toLowerCase(),
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 13;
      return layerMinZoom < zoom;
    }).toList();
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
      scheme: 'https',
      host: ApiConfig().baseDomain,
      path: '/routing/v1/router/vectorTiles/stops/$z/$x/$y.pbf',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'Server Error on fetchPBF $uri with ${response.statusCode}',
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final StopFeature? pointFeature =
              StopFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null && pointFeature.gtfsId != null) {
            MapMarkersRepositoryContainer.stopFeature[pointFeature.gtfsId!] = pointFeature;
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
  bool isDefaultOn() => mapCategory.properties?.layerEnabledPerDefault??false;
}
