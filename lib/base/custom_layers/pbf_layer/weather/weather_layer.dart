import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/data/markers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/models/map_layer_category.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pbf_point_layer.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:vector_tile/vector_tile.dart';

import 'weather_feature_model.dart';
import 'weather_marker_modal.dart';

class WeatherLayer extends PbfPointLayer<WeatherFeature> {
  WeatherLayer(super.mapCategory, super.weight);

  @override
  SortedList<WeatherFeature> get repository =>
      MapMarkersRepositoryContainer.weatherFeature;

  @override
  String get pbfPath => "/map/v1/weather-stations";

  @override
  WeatherFeature? parseFeature(GeoJsonPoint? geoJson) =>
      WeatherFeature.fromGeoJsonPoint(geoJson);

  @override
  Marker buildFeatureMarker(
    WeatherFeature element,
    double markerSize, {
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return Marker(
      key: Key("$id:${element.address}"),
      height: lastMarkerSize,
      width: lastMarkerSize,
      point: element.position,
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        return MarkerTileContainer(
          menuBuilder: (_) => MarkerTileListItem(
            name: element.address,
            icon: svgIcon != null
                ? SvgPicture.string(svgIcon)
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
                  panel: (context, onFetchPlan, {isOnlyDestination}) =>
                      ParkingMarkerModal(
                    parkingFeature: element,
                    onFetchPlan: onFetchPlan,
                    icon: svgIcon != null
                        ? SvgPicture.string(svgIcon)
                        : const Icon(Icons.error),
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
              child: SvgPicture.string(svgIcon ?? ''),
            ),
          ),
        );
      }),
    );
  }

  // Static fetchPBF kept for cancellable_network.dart compatibility.
  // Will be replaced by PbfLayerRegistry in Phase 3.
  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/map/v1/weather-stations/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();
        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final WeatherFeature? pointFeature =
              WeatherFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.weatherFeature.add(pointFeature);
          }
        }
      }
    }
  }
}
