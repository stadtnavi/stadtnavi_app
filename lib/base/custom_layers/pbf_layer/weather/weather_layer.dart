import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cached_first_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide MapConfigurationCubit, cachedFirstFetch;
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

class WeatherLayer extends CustomLayer {
  final MapLayerCategory mapCategory;

  WeatherLayer(this.mapCategory, int weight) : super(mapCategory.code, weight);

  TrufiMarker _buildTrufiMarker({
    required WeatherFeature element,
    required double markerSize,
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return TrufiMarker(
      id: "$id:${element.address}",
      position: element.position,
      size: Size(lastMarkerSize, lastMarkerSize),
      alignment: Alignment.center,
      imageCacheKey: isSelected
          ? 'weather_selected_${mapCategory.code}_${element.address}'
          : 'weather_${mapCategory.code}_${element.address}',
      buildPanel: (context) {
        return ParkingMarkerModal(
          parkingFeature: element,
          onFetchPlan: () {},
          icon: svgIcon != null
              ? SvgPicture.string(svgIcon)
              : const Icon(Icons.error),
        );
      },
      widget: Container(
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
    );
  }

  List<WeatherFeature> _cachedWeatherMarkers = [];
  int _lastWeatherZoom = -1;
  int _lastWeatherItemsLength = -1;

  List<WeatherFeature> _getMarkers(int zoom) {
    final itemsLength =
        MapMarkersRepositoryContainer.weatherFeature.items.length;

    if (zoom == _lastWeatherZoom && itemsLength == _lastWeatherItemsLength) {
      return _cachedWeatherMarkers;
    }

    _lastWeatherZoom = zoom;
    _lastWeatherItemsLength = itemsLength;

    _cachedWeatherMarkers =
        MapMarkersRepositoryContainer.weatherFeature.items.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedWeatherMarkers;
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
