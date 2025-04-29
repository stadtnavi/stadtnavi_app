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
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'parking_feature_model.dart';
import 'parking_icons.dart';

class ParkingLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  ParkingLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);
  Marker buildMarker({
    required ParkingFeature element,
    required double markerSize,
  }) {
    final availabilityParking = element.markerState();
    final svgIcon = parkingMarkerIcons[element.type];
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
                    onFetchPlan, {
                    isOnlyDestination,
                  }) =>
                      ParkingStateUpdater(
                    parkingFeature: element,
                    onFetchPlan: onFetchPlan,
                    isOnlyDestination: isOnlyDestination ?? false,
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
                if (availabilityParking != null)
                  availabilityParking.getImage(size: markerSize / 2),
              ],
            ),
            // child: SvgPicture.string(svgIcon ?? ''),
          ),
        );
      }),
    );
  }

  List<ParkingFeature> _cachedParkingMarkers = [];
  int _lastParkingZoom = -1;
  int _lastParkingItemsLength = -1;

  List<ParkingFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.parkingFeature.items.length;

    if (zoom == _lastParkingZoom && itemsLength == _lastParkingItemsLength) {
      return _cachedParkingMarkers;
    }

    _lastParkingZoom = zoom;
    _lastParkingItemsLength = itemsLength;

    _cachedParkingMarkers =
        MapMarkersRepositoryContainer.parkingFeature.items.where((element) {
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

  // static int valZ = 0;
  // static int valX = 0;
  // static int valY = 0;
  static Future<void> fetchPBF(int z, int x, int y) async {
    // valZ = z;
    // valX = x;
    // valY = y;
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/otp/routers/default/vectorTiles/parking/$z/$x/$y.pbf",
    );

    Uint8List bodyByte = await cachedFirstFetch(uri, z, x, y);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();
        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ParkingFeature? pointFeature =
              ParkingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            MapMarkersRepositoryContainer.parkingFeature.add(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
    // await Future.delayed(const Duration(seconds: 25)).then((value) {
    //   print("memory leak");
    //   if (valX == x && valY == y && valZ == z) {
    //     fetchPBF(z, x, y);
    //   }
    // });
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
