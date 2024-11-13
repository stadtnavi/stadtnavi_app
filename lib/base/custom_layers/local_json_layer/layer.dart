import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/markers_from_assets.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'custom_marker_modal.dart';
import 'custom_marker_model.dart';

class Layer extends CustomLayer {
  List<CustomMarker> customMarkers = [];
  final LayerIds layerId;
  final String? url;
  final String? nameEN;
  final String? nameDE;
  final bool isOnline;
  bool _isFetching = false;
  Layer(
    this.layerId,
    String weight, {
    this.url,
    this.nameEN,
    this.nameDE,
    this.isOnline = false,
  }) : super(layerId.enumString, weight) {
    load().catchError((error) {
      log("$error");
    });
  }

  Future<void> load() async {
    if (customMarkers.isNotEmpty) {
      return;
    }
    if (isOnline) {
      try {
        if (_isFetching) {
          return;
        }
        _isFetching = true;
        customMarkers = await markersFromUrl(url!);
        refresh();
        _isFetching = false;
      } catch (e) {
        _isFetching = false;
        throw Exception(
          "Parse error Layer: $e in url:$url",
        );
      }
    } else {
      final fileName = layerFileNames.entries
          .firstWhere((element) => element.key.enumString == id)
          .value;

      customMarkers =
          await markersFromAssets("assets/data/hb-layers/$fileName");

      refresh();
    }
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
    // No required
    return [];
  }

  @override
  Widget? buildLayerOptionsBackground(int? zoom) {
    return null;
  }

  @override
  Widget buildLayerOptions(int? zoom) {
    if (customMarkers.isEmpty) {
      load();
    }
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = 15;
        break;
      case 16:
        markerSize = 20;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    return MarkerLayer(
      markers: markerSize != null
          ? customMarkers
              .map((element) => Marker(
                    height: markerSize!,
                    width: markerSize,
                    point: element.position,
                    alignment: Alignment.center,
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          final panelCubit = context.read<PanelCubit>();
                          panelCubit.setPanel(
                            CustomMarkerPanel(
                              panel: (
                                context,
                                onFetchPlan, {
                                isOnlyDestination,
                              }) =>
                                  CustomMarkerModal(
                                element: element,
                                onFetchPlan: onFetchPlan,
                              ),
                              positon: element.position,
                              minSize: 50,
                            ),
                          );
                        },
                        child: SvgPicture.string(element.image),
                      );
                    }),
                  ))
              .toList()
          : zoom != null && zoom > 11
              ? customMarkers
                  .map(
                    (element) => Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: layerId.enumToColor(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
    );
  }

  @override
  Widget? buildLayerOptionsPriority(int zoom) {
    return null;
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en"
        ? nameEN ?? layerId.enumToStringEN()
        : nameDE ?? layerId.enumToStringDE();
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(layerIcons[layerId]!);
  }
}
