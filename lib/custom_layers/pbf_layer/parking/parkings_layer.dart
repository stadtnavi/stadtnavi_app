import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'parking_feature_model.dart';
import 'parking_icons.dart';

class ParkingLayer extends CustomLayer {
  final Map<String, ParkingFeature> _pbfMarkers = {};

  ParkingLayer(String id) : super(id);
  void addMarker(ParkingFeature pointFeature) {
    if (_pbfMarkers[pointFeature.name] == null) {
      _pbfMarkers[pointFeature.name] = pointFeature;
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
                    height: markerSize,
                    width: markerSize,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
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
                                    if (element.id != null)
                                      Text(
                                        "id: ${element.id}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    if (element.address != null)
                                    Text(
                                      "address: ${element.address}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.name != null)
                                    Text(
                                      "name: ${element.name}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.feeHours != null)
                                    Text(
                                      "feeHours: ${element.feeHours}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.openingHours != null)
                                    Text(
                                      "openingHours: ${element.openingHours}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.free != null)
                                    Text(
                                      "free: ${element.free}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.forecast != null)
                                    Text(
                                      "forecast: ${element.forecast}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.state != null)
                                    Text(
                                      "state: ${element.state}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.coords != null)
                                    Text(
                                      "coords: ${element.coords}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.total != null)
                                    Text(
                                      "total: ${element.total}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.url != null)
                                    Text(
                                      "url: ${element.url}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.notes != null)
                                    Text(
                                      "notes: ${element.notes}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                    if (element.type != null)
                                    Text(
                                      "type: ${element.type}",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyText1.color,
                                      ),
                                    ),
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
                      child: SvgPicture.string(
                        parkingMarkerIcons[element.type] ?? "",
                      ),
                    ),
                  ))
              .toList()
          : [],
    );
  }
// https://api.dev.stadtnavi.eu/map/v1/hb-parking-map/14/8595/5654.pbf
  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.dev.stadtnavi.eu",
      path: "/map/v1/hb-parking-map/$z/$x/$y.pbf",
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
          final ParkingFeature pointFeature =
              ParkingFeature.fromGeoJsonPoint(geojson);
          // final pbfLayer = pbfParkingLayers[pointFeature.type];
          parkingLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
