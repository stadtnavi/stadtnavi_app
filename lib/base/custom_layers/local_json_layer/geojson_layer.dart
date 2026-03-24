import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch, SortedList;
import 'geojson_marker_modal.dart';
import 'geojson_marker_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeojsonLayer extends CustomLayer {
  SortedList<GeojsonMarker> customMarkers = SortedList(
    compare: (a, b) => a.position.latitude.compareTo(b.position.latitude),
    getId: (pointFeature) => pointFeature.id,
  );
  List<MultiLineStringModel> polylines = [];
  final MapLayerCategory mapCategory;
  final String? url;
  final String? nameEN;
  final String? nameDE;
  bool _isFetching = false;
  GeojsonLayer(
    this.mapCategory,
    int weight, {
    this.url,
    this.nameEN,
    this.nameDE,
  }) : super(mapCategory.code, weight) {
    load().catchError((error) {
      log("$error");
    });
  }
  Future<void> load() async {
    if (customMarkers.items.isNotEmpty) {
      return;
    }
    try {
      if (_isFetching) {
        return;
      }
      _isFetching = true;
      await _markersFromUrl(url!);
      refresh();
      _isFetching = false;
    } catch (e) {
      _isFetching = false;
      throw Exception(
        "Parse error Layer: $e in url:$url",
      );
    }
  }

  Future<void> _markersFromUrl(String path) async {

    final uri = Uri.parse(path);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error ParkZone $uri with ${response.statusCode}",
      );
    }
    final body =
        jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true));
    final List features = body["features"] as List;
    for (final feature in features) {
      if (feature['geometry']['type'] == "MultiLineString") {
        polylines.add(MultiLineStringModel.fromJson(feature));
      } else {
        final element=GeojsonMarker.fromJson(feature);
        if(element!=null)customMarkers.add(element);
      }
    }
  }

  @override
  List<TrufiLine> buildTrufiLines(int zoom) {
    return polylines
        .map(
          (path) => TrufiLine(
            id: 'geojson_line_${path.hashCode}',
            position: path.coordinates,
            color: Color(int.parse(path.color.replaceFirst('#', '0xFF'))),
            lineWidth: path.weight,
          ),
        )
        .toList();
  }

  TrufiMarker _buildTrufiMarker({
    required GeojsonMarker element,
    required double markerSize,
    bool isSelected = false,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon = element.svgIcon ?? targetMapLayerCategory?.properties?.iconSvg;
    final lastMarkerSize = markerSize + (isSelected ? 6 : 0);
    return TrufiMarker(
      id: "$id:${element.id}:${element.name}:${element.address}",
      position: element.position,
      size: Size(lastMarkerSize, lastMarkerSize),
      alignment: Alignment.center,
      imageCacheKey: isSelected
          ? 'geojson_selected_${mapCategory.code}_${element.id}'
          : 'geojson_${mapCategory.code}_${element.id}',
      buildPanel: (context) {
        return GeojsonMarkerModal(
          icon: svgIcon != null
              ? SvgPicture.string(svgIcon)
              : const Icon(Icons.error),
          element: element,
          onFetchPlan: () {},
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
        child: svgIcon != null
            ? SvgPicture.string(svgIcon)
            : const Icon(Icons.error),
      ),
    );
  }

  List<GeojsonMarker> _cachedGeojsonMarkers = [];
  int _lastGeojsonZoom = -1;
  int _lastGeojsonItemsLength = -1;

  List<GeojsonMarker> _getMarkers(int zoom) {
    final itemsLength = customMarkers.length;

    if (zoom == _lastGeojsonZoom && itemsLength == _lastGeojsonItemsLength) {
      return _cachedGeojsonMarkers;
    }

    _lastGeojsonZoom = zoom;
    _lastGeojsonItemsLength = itemsLength;

    _cachedGeojsonMarkers = customMarkers.items
        .where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();

    return _cachedGeojsonMarkers;
  }

  @override
  List<TrufiMarker> buildTrufiMarkers(int zoom) {
    return _getMarkers(zoom)
        .map((element) => _buildTrufiMarker(
            element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
        .toList();
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
      color: Colors.green,
    );
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
}
