import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/data/markers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pbf_point_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'scooter_feature_model.dart';
import 'scooter_marker_modal.dart';

class ScooterLayer extends PbfPointLayer<ScooterFeature> {
  ScooterLayer(super.mapCategory, super.weight);

  @override
  SortedList<ScooterFeature> get repository =>
      MapMarkersRepositoryContainer.scooterFeature;

  @override
  String get pbfPath => "/otp/routers/default/vectorTiles/rentalVehicles";

  @override
  ScooterFeature? parseFeature(GeoJsonPoint? geoJson) =>
      ScooterFeature.fromGeoJsonPoint(geoJson);

  @override
  Marker buildFeatureMarker(
    ScooterFeature element,
    double markerSize, {
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    final lastMarkerSize = markerSize + 5 + (isSelected ? 6 : 0);
    return Marker(
      key: Key("$id:${element.id}"),
      height: lastMarkerSize,
      width: lastMarkerSize,
      point: element.position,
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        return MarkerTileContainer(
          menuBuilder: (_) => MarkerTileListItem(
            name: element.name ?? "",
            icon: svgIcon != null
                ? SvgPicture.string(
                    ConfigDefault.value.cityBike
                            .operators?[element.network?.operator]?.iconCode ??
                        "",
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
                    onFetchPlan, {
                    isOnlyDestination,
                  }) =>
                      ScooterMarkerModal(
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
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: markerSize / 5,
                    top: markerSize / 5,
                  ),
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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SvgPicture.string(
                            svgIcon,
                            colorFilter: ColorFilter.mode(
                              hexToColor(
                                ConfigDefault
                                        .value
                                        .cityBike
                                        .operators?[element.network?.operator]
                                        ?.colors?['background'] ??
                                    "#FF000000",
                              ),
                              BlendMode.color,
                            ),
                          ),
                        )
                      : const Icon(Icons.error),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse('0x$hex'));
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/otp/routers/default/vectorTiles/rentalVehicles/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();
        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ScooterFeature? pointFeature =
              ScooterFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.scooterFeature.add(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
