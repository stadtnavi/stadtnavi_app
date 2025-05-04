import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
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
  Widget? buildAreaLayer(int? zoom) {
    return PolylineLayer(
      polylines: polylines
          .map(
            (path) => Polyline(
              points: path.coordinates,
              color: Color(int.parse(path.color.replaceFirst('#', '0xFF'))),
              strokeWidth: path.weight,
            ),
          )
          .toList(),
    );
  }

  Marker buildMarker({
    required GeojsonMarker element,
    required double markerSize,
  }) {
    final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      mapCategory,
      mapCategory.code,
    );
    final svgIcon =element.svgIcon?? targetMapLayerCategory?.properties?.iconSvg;
    return Marker(
      key: Key("$id:${element.id}:${element.name}:${element.address}"),
      height: markerSize,
      width: markerSize,
      point: element.position,
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        final languageCode = Localizations.localeOf(context).languageCode;
        final isEnglishCode = languageCode == 'en';
        return MarkerTileContainer(
          menuBuilder: (_) {
            return MarkerTileListItem(
              // element: element,
              icon: svgIcon != null
                  ? SvgPicture.string(
                      svgIcon,
                    )
                  : const Icon(Icons.error),
              name: element.name ??
                  (isEnglishCode
                      ? targetMapLayerCategory?.en
                      : targetMapLayerCategory?.de) ??
                  "",
            );
          },
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
                      GeojsonMarkerModal(
                    icon: svgIcon != null
                        ? SvgPicture.string(
                            svgIcon,
                          )
                        : const Icon(Icons.error),
                    element: element,
                    onFetchPlan: onFetchPlan,
                  ),
                  position: element.position,
                  minSize: 50,
                ),
              );
            },
            child: svgIcon != null
                ? SvgPicture.string(svgIcon)
                : const Icon(Icons.error),
          ),
        );
      }),
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
