import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'charging_feature_model.dart';
import 'charging_icons.dart';
import 'charging_marker_modal.dart';

class ChargingLayer extends CustomLayer {
  final Map<String, ChargingFeature> _pbfMarkers = {};

  Map<String, ChargingFeature> get data => _pbfMarkers;

  ChargingLayer(String id, String weight) : super(id, weight);
  void addMarker(ChargingFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = 20;
        break;
      case 16:
        markerSize = 25;
        break;
      case 17:
        markerSize = 30;
        break;
      case 18:
        markerSize = 35;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 40 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return markerSize != null
        ? markersList
            .map(
              (element) => Marker(
                key: Key("$id:${element.id}"),
                height: markerSize!,
                width: markerSize,
                point: element.position,
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  final availabilityStatus = element.getAvailabilityStatus();
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
                              ChargingMarkerModal(
                            element: element,
                            onFetchPlan: onFetchPlan,
                          ),
                          positon: element.position,
                          minSize: 50,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: markerSize! / 5,
                            top: markerSize / 5,
                          ),
                          child: SvgPicture.string(
                            chargingIcon,
                          ),
                        ),
                        if (availabilityStatus != null)
                          SizedBox(
                            height: markerSize / 1.8,
                            width: markerSize / 1.8,
                            child: availabilityStatus.getImage(),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            )
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
        markerSize = 20;
        break;
      case 16:
        markerSize = 25;
        break;
      case 17:
        markerSize = 30;
        break;
      case 18:
        markerSize = 35;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 40 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return MarkerLayer(
      markers: markerSize != null
          ? markersList
              .map(
                (element) => Marker(
                  height: markerSize!,
                  width: markerSize,
                  point: element.position,
                  alignment: Alignment.center,
                  child: Builder(builder: (context) {
                    final availabilityStatus = element.getAvailabilityStatus();
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
                                ChargingMarkerModal(
                              element: element,
                              onFetchPlan: onFetchPlan,
                            ),
                            positon: element.position,
                            minSize: 50,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: markerSize! / 5,
                              top: markerSize / 5,
                            ),
                            child: SvgPicture.string(
                              chargingIcon,
                            ),
                          ),
                          if (availabilityStatus != null)
                            SizedBox(
                              height: markerSize / 1.8,
                              width: markerSize / 1.8,
                              child: availabilityStatus.getImage(),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              )
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
                          color: const Color(0xff00b096),
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
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/tiles/charging-stations/$z/$x/$y.mvt",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ChargingFeature? pointFeature =
              ChargingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            StaticTileLayers.chargingLayer.addMarker(pointFeature);
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
    return localeName == "en" ? "Charging stations" : "Ladestationen";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      chargingIcon,
    );
  }
}
