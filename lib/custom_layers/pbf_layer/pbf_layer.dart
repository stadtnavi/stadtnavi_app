import 'dart:convert';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/point_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'icon.dart';

class PBFLayer extends CustomLayer {
  final Map<String, PointFeature> _pbfMarkers = {};

  PBFLayer(PBFLayerIds layerId) : super(layerId.enumToString());
  void addMarker(PointFeature pointFeature) {
    if (pointFeature.type != null) {
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
                        final patterns =
                            jsonDecode(element.patterns ?? "[]") as List;
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
                                    Text(
                                      "GTFS Id: ${element.gtfsId}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ...patterns
                                        .map(
                                          (e) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Divider(),
                                              Text(
                                                "Headsign: ${e["headsign"]}",
                                                style: TextStyle(
                                                  color: theme.textTheme
                                                      .bodyText1.color,
                                                ),
                                              ),
                                              Text(
                                                "Short Name: ${e["shortName"]}",
                                                style: TextStyle(
                                                  color: theme.textTheme
                                                      .bodyText1.color,
                                                ),
                                              ),
                                              Text(
                                                "type: ${e["type"]}",
                                                style: TextStyle(
                                                  color: theme.textTheme
                                                      .bodyText1.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
          final PointFeature pointFeature = PointFeature(
            code: geojson.properties[2].values.first.stringValue,
            gtfsId: geojson.properties[0].values.first.stringValue,
            name: geojson.properties[1].values.first.stringValue,
            parentStation: geojson.properties[4].values.first.stringValue,
            patterns: geojson.properties[6].values.first.stringValue,
            platform: geojson.properties[3].values.first.stringValue,
            type: pbfLayerIdsstringToEnum(
              geojson.properties[5].values.first.stringValue,
            ),
            position: LatLng(
              geojson.geometry.coordinates[1],
              geojson.geometry.coordinates[0],
            ),
          );
          final pbfLayer = pbfLayers[pointFeature.type];
          pbfLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
