import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'carsharing_feature_model.dart';
import 'carsharing_marker_modal.dart';

class CarSharingLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  CarSharingLayer(this.mapCategory, int weight)
      : super(mapCategory.code, weight);
  Marker buildMarker({
    required CarSharingFeature element,
    required double markerSize,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    Color circleColor;
    final vehiclesAvailable = element.vehiclesAvailable ?? 0;
    if (vehiclesAvailable == 0) {
      circleColor = Colors.red;
    } else if (vehiclesAvailable < 5) {
      circleColor = Colors.orange;
    } else {
      circleColor = Colors.green;
    }
    return Marker(
      key: Key("$id:${element.id}"),
      height: markerSize + 5,
      width: markerSize + 5,
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
              panelCubit.setPanel(
                CustomMarkerPanel(
                  panel: (
                    context,
                    onFetchPlan, {
                    isOnlyDestination,
                  }) =>
                      CarSharingMarkerModal(
                    element: element,
                    onFetchPlan: onFetchPlan,
                    targetMapLayerCategory: targetMapLayerCategory,
                  ),
                  position: element.position,
                  minSize: 50,
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(
                    right: markerSize / 5,
                    top: markerSize / 5,
                  ),
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
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.5),
                    // width: markerSize/ 1.5,
                    // height: markerSize/ 1.5,
                    decoration: BoxDecoration(
                      color: circleColor,
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$vehiclesAvailable',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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

  List<CarSharingFeature> _cachedParkingMarkers = [];
  int _lastParkingZoom = -1;
  int _lastParkingItemsLength = -1;

  List<CarSharingFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.carSharingFeature.items.length;

    if (zoom == _lastParkingZoom && itemsLength == _lastParkingItemsLength) {
      return _cachedParkingMarkers;
    }

    _lastParkingZoom = zoom;
    _lastParkingItemsLength = itemsLength;
// car -> "BICYCLE,CAR"
// cargo_bicycle -> "BICYCLE,CARGO_BICYCLE"
// bicycle -> "BICYCLE";"BICYCLE,SCOOTER"
    _cachedParkingMarkers =
        MapMarkersRepositoryContainer.carSharingFeature.items.where((element) {
      if (element.formFactors == null) return false;

      switch (mapCategory.code) {
        case "car":
          return element.formFactors == "BICYCLE,CAR";
        case "cargo_bicycle":
          return element.formFactors == "BICYCLE,CARGO_BICYCLE";
        case "bicycle":
          return element.formFactors == "BICYCLE" ||
              element.formFactors == "BICYCLE,SCOOTER";
        default:
          return false;
      }
    }).where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedParkingMarkers;
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
      path:
          "/otp/routers/default/vectorTiles/realtimeRentalStations/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();
        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final CarSharingFeature? pointFeature =
              CarSharingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.carSharingFeature.add(pointFeature);
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
