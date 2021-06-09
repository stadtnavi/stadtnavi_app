import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:stadtnavi_app/custom_layers/widget/marker_modal.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal/stop_marker_modal.dart';
import 'stops_enum.dart';
import 'stops_icon.dart';

extension StopsLayerIdsIdsToString on StopsLayerIds {
  String enumToStringEN() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: "Bus stops",
      StopsLayerIds.rail: "Train stations",
      StopsLayerIds.carpool: "Carpool stops",
      StopsLayerIds.subway: "Metro stations",
    };
    return enumStrings[this];
  }

  String enumToStringDE() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: "Bushaltestellen",
      StopsLayerIds.rail: "Bahnhöfe",
      StopsLayerIds.carpool: "Mitfahrpunkte",
      StopsLayerIds.subway: "U-Bahnhöfe",
    };
    return enumStrings[this];
  }
}

class StopsLayer extends CustomLayer {
  final Map<String, StopFeature> _pbfMarkers = {};
  final StopsLayerIds layerId;
  StopsLayer(this.layerId) : super(layerId.enumToString());
  void addMarker(StopFeature pointFeature) {
    if (_pbfMarkers[pointFeature.gtfsId] == null) {
      _pbfMarkers[pointFeature.gtfsId] = pointFeature;
      refresh();
    }
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
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return MarkerLayerOptions(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize + 5,
                    width: markerSize + 5,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        showMarkerModal(
                          context: context,
                          builder: (BuildContext context) => StopMarkerModal(
                            stopFeature: element,
                          ),
                        );
                      },
                      child: SvgPicture.string(stopsIcons[element.type] ?? ""),
                    ),
                  ))
              .toList()
          : [],
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.dev.stadtnavi.eu",
      path: "/routing/v1/router/vectorTiles/stops/$z/$x/$y.pbf",
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
          final StopFeature pointFeature =
              StopFeature.fromGeoJsonPoint(geojson);
          final pbfLayer = stopsLayers[pointFeature.type];
          pbfLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
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
    return SvgPicture.string(stopsIcons[layerId]);
  }
}
