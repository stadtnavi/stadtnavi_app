import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:stadtnavi_app/custom_layers/widget/marker_modal.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'stop_feature_model.dart';
import 'stop_marker_modal.dart';
import 'stops_enum.dart';
import 'stops_icon.dart';

class StopsLayer extends CustomLayer {
  final Map<String, StopFeature> _pbfMarkers = {};

  StopsLayer(StopsLayerIds layerId) : super(layerId.enumToString());
  void addMarker(StopFeature pointFeature, String gtfsId) {
    if (pointFeature.type != null) {
      final duplicatedPointFeature = _pbfMarkers.values.firstWhere(
        (element) =>
            element.position.latitude == pointFeature.position.latitude &&
            element.position.longitude == pointFeature.position.longitude,
        orElse: () => null,
      );
      if (duplicatedPointFeature != null) {
        if (!duplicatedPointFeature.gtfsId.contains(gtfsId)) {
          duplicatedPointFeature.gtfsId.add(gtfsId);
          refresh();
        }
      } else if (_pbfMarkers[gtfsId] == null) {
        _pbfMarkers[gtfsId] = pointFeature;
        refresh();
      }
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
          final gtfsId = pointFeature.gtfsId.first;
          final pbfLayer = stopsLayers[pointFeature.type];
          pbfLayer?.addMarker(pointFeature, gtfsId);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
