
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/point_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'pbf_stops_icon.dart';


class PBFStopsLayer extends CustomLayer {
  final Map<String, PointFeature> _pbfMarkers = {};

  PBFStopsLayer(PBFStopsLayerIds layerId) : super(layerId.enumToString());
  void addMarker(PointFeature pointFeature, String gtfsId) {
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
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            final localization = TrufiLocalization.of(context);
                            final theme = Theme.of(dialogContext);
                            return AlertDialog(
                              title: Text(
                                element.name,
                                style: TextStyle(color: theme.primaryColor),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ...element.gtfsId
                                        .map((gtfsId) => Text(
                                              "GTFS Id: $gtfsId",
                                              style: TextStyle(
                                                color: theme
                                                    .textTheme.bodyText1.color,
                                              ),
                                            ))
                                        .toList()
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text(localization.commonOK),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SvgPicture.string(markerIcons[element.type] ?? ""),
                    ),
                  ))
              .toList()
          : [],
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.stadtnavi.de",
      path: "/map/v1/stop-map/$z/$x/$y.pbf",
    );
    final response = await http.get(uri);
    final bodyByte = response.bodyBytes;
    final tile = await VectorTile.fromByte(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final PointFeature pointFeature = PointFeature.fromGeoJsonPoint(geojson);
          final gtfsId = pointFeature.gtfsId.first;
          final pbfLayer = pbfStopsLayers[pointFeature.type];
          pbfLayer?.addMarker(pointFeature, gtfsId);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
