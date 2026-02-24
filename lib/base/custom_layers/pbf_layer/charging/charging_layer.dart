import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/data/markers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/data/sorted_list.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pbf_point_layer.dart';

import 'charging_feature_model.dart';
import 'charging_marker_modal.dart';

class ChargingLayer extends PbfPointLayer<ChargingFeature> {
  ChargingLayer(super.mapCategory, super.weight);

  @override
  SortedList<ChargingFeature> get repository =>
      MapMarkersRepositoryContainer.chargingFeature;

  /// Not used directly — ChargingLayer uses a custom URL in fetchPBF.
  @override
  String get pbfPath => "";

  @override
  ChargingFeature? parseFeature(GeoJsonPoint? geoJson) =>
      ChargingFeature.fromGeoJsonPoint(geoJson);

  @override
  Marker buildFeatureMarker(
    ChargingFeature element,
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
      alignment: Alignment.topCenter,
      child: Builder(
        builder: (context) {
          final languageCode = Localizations.localeOf(context).languageCode;
          final isEnglishCode = languageCode == 'en';
          final availabilityStatus = element.getAvailabilityStatus();
          return MarkerTileContainer(
            menuBuilder: (_) {
              return MarkerTileListItem(
                icon:
                    svgIcon != null
                        ? SvgPicture.string(svgIcon)
                        : const Icon(Icons.error),
                name:
                    element.name ??
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
                    panel:
                        (context, onFetchPlan, {isOnlyDestination}) =>
                            ChargingMarkerModal(
                              element: element,
                              onFetchPlan: onFetchPlan,
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
                    padding: isSelected ? EdgeInsets.all(1) : null,
                    decoration:
                        isSelected
                            ? BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            )
                            : null,
                    child:
                        svgIcon != null
                            ? SvgPicture.string(svgIcon)
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
        },
      ),
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "services.stadtnavi.eu",
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
}
