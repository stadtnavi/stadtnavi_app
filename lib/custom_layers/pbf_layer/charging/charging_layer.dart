import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'charging_feature_model.dart';
import 'charging_icons.dart';
import 'charging_marker_modal.dart';

class ChargingLayer extends CustomLayer {
  final Map<String, ChargingFeature> _pbfMarkers = {};

  ChargingLayer(String id) : super(id);
  void addMarker(ChargingFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
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
    return MarkerLayerOptions(
      markers: markerSize != null
          ? markersList
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
                            panel: (context, onFetchPlan) =>
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
                              left: markerSize / 5,
                              top: markerSize / 5,
                            ),
                            child: SvgPicture.string(
                              chargingIcon,
                            ),
                          ),
                          if (element.capacityUnknown == 0)
                            if (element.available > 0)
                              Positioned(
                                child: Container(
                                  height: markerSize / 2,
                                  width: markerSize / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: markerSize / 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: markerSize / 2,
                                width: markerSize / 2,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: markerSize / 3,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                        ],
                      ),
                    ),
                  ))
              .toList()
          : zoom > 11
              ? markersList
                  .map(
                    (element) => Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      builder: (context) => Container(
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

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "ochp.next-site.de",
      path: "/tiles/$z/$x/$y.mvt",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = await VectorTile.fromByte(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ChargingFeature pointFeature =
              ChargingFeature.fromGeoJsonPoint(geojson);
          chargingLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en" ? "Charging stations" : "Ladestationen";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      chargingIcon,
    );
  }
}
