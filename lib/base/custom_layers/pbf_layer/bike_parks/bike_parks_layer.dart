import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide MapConfigurationCubit, cachedFirstFetch;
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'bike_park_feature_model.dart';
import 'bike_park_icons.dart';
import 'citybike_marker_modal.dart';

class BikeParkLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  BikeParkLayer(this.mapCategory, int weight)
      : super(mapCategory.code, weight);

  TrufiMarker _buildTrufiMarker({
    required BikeParkFeature element,
    required double markerSize,
    bool isSelected = false,
  }) {
    final availabilityState = element.getAvailabilityState();
    final svgIcon = bikeParkMarkerIcons[element.type];
    final lastMarkerSize = markerSize + 4 + (isSelected ? 6 : 0);
    return TrufiMarker(
      id: "$id:${element.id}",
      position: element.position,
      size: Size(lastMarkerSize, lastMarkerSize),
      alignment: Alignment.center,
      imageCacheKey: isSelected
          ? 'bikepark_selected_${element.type}_${element.state}'
          : 'bikepark_${element.type}_${element.state}',
      buildPanel: (context) {
        return CitybikeMarkerModal(
          element: element,
          onFetchPlan: () {},
        );
      },
      widget: Stack(
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
                      color: Colors.green,
                      width: 2,
                    ),
                  )
                : null,
            child: SvgPicture.string(svgIcon ?? ''),
          ),
          if (element.state == 'CLOSED')
            if (availabilityState != null)
              availabilityState.getImage(size: markerSize / 2),
        ],
      ),
    );
  }

  List<BikeParkFeature> _cachedBikeParkMarkers = [];
  int _lastBikeParkZoom = -1;
  int _lastBikeParkItemsLength = -1;

  List<BikeParkFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.bikeParkFeature.items.length;

    if (zoom == _lastBikeParkZoom &&
        itemsLength == _lastBikeParkItemsLength) {
      return _cachedBikeParkMarkers;
    }

    _lastBikeParkZoom = zoom;
    _lastBikeParkItemsLength = itemsLength;

    _cachedBikeParkMarkers =
        MapMarkersRepositoryContainer.bikeParkFeature.items.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedBikeParkMarkers;
  }

  @override
  List<TrufiMarker> buildTrufiMarkers(int zoom) {
    return _getMarkers(zoom)
        .map((element) => _buildTrufiMarker(
            element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
        .toList();
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
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
          final BikeParkFeature? pointFeature =
              BikeParkFeature.fromGeoJsonPoint(geojson);

          if (pointFeature != null) {
            MapMarkersRepositoryContainer.bikeParkFeature.add(pointFeature);
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
