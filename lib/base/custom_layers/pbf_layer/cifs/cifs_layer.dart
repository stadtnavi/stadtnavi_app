import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/bike_parks_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'cifs_feature_model.dart';
import 'cifs_icons.dart';
import 'cifs_marker_modal.dart';

class CifsLayer extends CustomLayer {
  final Map<String, CifsFeature> _pbfMarkers = {};

  CifsLayer(String id, String weight) : super(id, weight) {
    // loop 30 seg
  }
  void addMarker(CifsFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
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
    double? polylineSize;
    double? markerSize;
    switch (zoom) {
      case 13:
        polylineSize = 3;
        break;
      case 14:
        polylineSize = 4;
        break;
      case 15:
        polylineSize = 5;
        break;
      case 16:
        polylineSize = 6;
        break;
      case 17:
        polylineSize = 7;
        break;
      case 18:
        polylineSize = 8;
        break;
      default:
        polylineSize = (zoom != null && zoom > 18) ? 8 : null;
    }
    switch (zoom) {
      case 13:
        markerSize = 15;
        break;
      case 14:
        markerSize = 20;
        break;
      case 15:
        markerSize = 23;
        break;
      case 16:
        markerSize = 25;
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
    return Stack(
      children: [
        if (polylineSize != null)
          PolylineLayer(
            polylines: markersList
                .map((e) => Polyline(
                      points: e.polyline.reversed.toList(),
                      color: Colors.red.withOpacity(.8),
                      pattern: const StrokePattern.dotted(),
                      strokeWidth: polylineSize!,
                    ))
                .toList(),
          ),
        MarkerLayer(
          markers: [
            if (markerSize != null)
              ...markersList
                  .map((element) => Marker(
                        height: markerSize!,
                        width: markerSize,
                        point: element.startPoint,
                        alignment: Alignment.center,
                        child: _CifsFeatureMarker(
                          element: element,
                          point: element.startPoint,
                        ),
                      ))
                  .toList(),
            if (markerSize != null)
              ...markersList
                  .map((element) => Marker(
                        height: markerSize!,
                        width: markerSize,
                        point: element.endPoint,
                        alignment: Alignment.center,
                        child: _CifsFeatureMarker(
                          element: element,
                          point: element.endPoint,
                        ),
                      ))
                  .toList(),
          ],
        ),
      ],
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
      path: "/map/v1/cifs/$z/$x/$y.pbf",
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

        if (feature.geometryType == GeometryType.LineString) {
          final geojson = feature.toGeoJson<GeoJsonLineString>(
            x: x,
            y: y,
            z: z,
          );
          final CifsFeature? pointFeature =
              CifsFeature.fromGeoJsonLine(geojson);
          if (pointFeature != null) {
            StaticTileLayers.cifsLayer.addMarker(pointFeature);
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
    return localeName == "en" ? "Roadworks" : "Baustellen";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      cifsIcons[CifsTypeIds.construction]!,
    );
  }
}

class _CifsFeatureMarker extends StatelessWidget {
  final CifsFeature element;
  final LatLng point;
  const _CifsFeatureMarker({
    Key? key,
    required this.element,
    required this.point,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                CifsMarkerModal(
              element: element,
              onFetchPlan: onFetchPlan,
              position: point,
            ),
            positon: point,
            minSize: 50,
          ),
        );
      },
      child: element.type == CifsTypeIds.roadClosed &&
              element.locationDirection == 'BOTH_DIRECTIONS'
          ? cifsIcons[element.type] != null
              ? SvgPicture.string(
                  cifsIcons[element.type] ?? '',
                )
              : const Icon(Icons.error)
          : SvgPicture.string(
              cifsIcons[CifsTypeIds.construction]!,
            ),
    );
  }
}
