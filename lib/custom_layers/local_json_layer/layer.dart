import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/markers_from_assets.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_marker_modal.dart';
import 'custom_marker_model.dart';

class Layer extends CustomLayer {
  List<CustomMarker> customMarkers = [];
  final LayerIds layerId;
  Layer(this.layerId) : super(layerId.enumToString()) {
    load();
  }

  Future<void> load() async {
    final fileName = layerFileNames.entries
        .firstWhere((element) => element.key.enumToString() == id)
        .value;

    customMarkers = await markersFromAssets("assets/data/hb-layers/$fileName");

    refresh();
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
    switch (zoom) {
      case 13:
        markerSize = 5;
        break;
      case 14:
        markerSize = 10;
        break;
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
    return MarkerLayerOptions(
      markers: markerSize != null
          ? customMarkers
              .map((element) => Marker(
                    height: markerSize,
                    width: markerSize,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        final panelCubit = context.read<PanelCubit>();
                        panelCubit.setPanel(
                          CustomMarkerPanel(
                            panel: (context, onFetchPlan) => CustomMarkerModal(
                              element: element,
                              onFetchPlan: onFetchPlan,
                            ),
                            positon: element.position,
                            minSize: 50,
                          ),
                        );
                      },
                      child: SvgPicture.string(element.image),
                    ),
                  ))
              .toList()
          : [],
    );
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en"
        ? layerId.enumToStringEN()
        : layerId.enumToStringDE();
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(layerIcons[layerId]);
  }
}
