import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/icons_transport_modes.dart';
import 'package:stadtnavi_core/consts.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal/stop_marker_modal.dart';
import 'stops_enum.dart';
import 'stops_icon.dart';

extension StopsLayerIdsIdsToString on StopsLayerIds {
  String enumToStringEN() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: 'Bus stops',
      StopsLayerIds.rail: 'Train stations',
      StopsLayerIds.carpool: 'Carpool stops',
      StopsLayerIds.subway: 'Metro stations',
    };
    return enumStrings[this] ?? 'Bus stops';
  }

  String enumToStringDE() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: 'Bushaltestellen',
      StopsLayerIds.rail: 'Bahnhöfe',
      StopsLayerIds.carpool: 'Mitfahrpunkte',
      StopsLayerIds.subway: 'U-Bahnhöfe',
    };
    return enumStrings[this] ?? 'Bushaltestellen';
  }
}

class StopsLayer extends CustomLayer {
  final Map<String, StopFeature> _pbfMarkers = {};

  Map<String, StopFeature> get data => _pbfMarkers;

  final StopsLayerIds layerId;

  StopsLayer(this.layerId, String weight)
      : super(layerId.enumToString(), weight);

  void addMarker(StopFeature pointFeature) {
    if (_pbfMarkers[pointFeature.gtfsId] == null) {
      _pbfMarkers[pointFeature.gtfsId!] = pointFeature;
      refresh();
    }
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
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
        markerSize = (zoom != null && zoom > 18) ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return markerSize != null
        ? markersList
            .map((element) => Marker(
                  key: Key("$id:${element.gtfsId}"),
                  height: markerSize! + 5,
                  width: markerSize + 5,
                  point: element.position,
                  alignment: Alignment.topCenter,
                  child: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        final panelCubit = context.read<PanelCubit>();
                        panelCubit.setPanel(
                          CustomMarkerPanel(
                            panel: (
                              context,
                              _, {
                              isOnlyDestination,
                            }) =>
                                StopMarkerModal(
                              stopFeature: element,
                            ),
                            positon: element.position,
                            minSize: 130,
                          ),
                        );
                      },
                      child: SvgPicture.string(stopsIcons[element.type] ?? ''),
                    );
                  }),
                ))
            .toList()
        : [];
  }

  @override
  Widget? buildLayerOptionsBackground(int? zoom) {
    return null;
  }

  @override
  Widget buildLayerOptions(int? zoom) {
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
        markerSize = (zoom != null && zoom > 18) ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return MarkerLayer(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize! + 5,
                    width: markerSize + 5,
                    point: element.position,
                    alignment: Alignment.topCenter,
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          final panelCubit = context.read<PanelCubit>();
                          panelCubit.setPanel(
                            CustomMarkerPanel(
                              panel: (
                                context,
                                _, {
                                isOnlyDestination,
                              }) =>
                                  StopMarkerModal(
                                stopFeature: element,
                              ),
                              positon: element.position,
                              minSize: 130,
                            ),
                          );
                        },
                        child:
                            SvgPicture.string(stopsIcons[element.type] ?? ''),
                      );
                    }),
                  ))
              .toList()
          : zoom != null && zoom > 11
              ? markersList
                  .map(
                    (element) => Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: stopsIconsColor[element.type] ??
                              Colors.transparent,
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

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: 'https',
      host: ApiConfig().baseDomain,
      path: '/routing/v1/router/vectorTiles/stops/$z/$x/$y.pbf',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'Server Error on fetchPBF $uri with ${response.statusCode}',
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final StopFeature? pointFeature =
              StopFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            final pbfLayer = StaticTileLayers.stopsLayers[pointFeature.type];
            pbfLayer?.addMarker(pointFeature);
          }
        } else {
          throw Exception('Should never happened, Feature is not a point');
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == 'en'
        ? layerId.enumToStringEN()
        : layerId.enumToStringDE();
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(stopsIcons[layerId] ?? bus());
  }
}
