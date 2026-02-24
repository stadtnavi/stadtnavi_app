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
import 'package:stadtnavi_core/consts.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal/stop_marker_modal.dart';

class StopsLayer extends PbfPointLayer<StopFeature> {
  StopsLayer(super.mapCategory, super.weight);

  @override
  SortedList<StopFeature> get repository =>
      MapMarkersRepositoryContainer.stopFeature;

  @override
  String get pbfPath => "/otp/routers/default/vectorTiles/stops";

  @override
  StopFeature? parseFeature(GeoJsonPoint? geoJson) =>
      StopFeature.fromGeoJsonPoint(geoJson);

  @override
  int get defaultMinZoom => 13;

  @override
  bool filterFeature(StopFeature element, int zoom) =>
      element.type.toLowerCase() == mapCategory.code;

  @override
  Marker buildFeatureMarker(
    StopFeature element,
    double markerSize, {
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      element.type.toLowerCase(),
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvgMenu;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return Marker(
      key: Key("$id:${element.gtfsId}"),
      height: lastMarkerSize,
      width: lastMarkerSize,
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
              final selectedMarker = buildFeatureMarker(
                element,
                markerSize,
                isSelected: true,
              );
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
              child: SvgPicture.string(svgIcon ?? ''),
            ),
          ),
        );
      }),
    );
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
}
