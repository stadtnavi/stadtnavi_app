import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/weather/weather_icons.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

class WeatherLayer extends CustomLayer {
  final Map<String, WeatherFeature> _pbfMarkers = {};

  WeatherLayer(String id) : super(id);
  void addMarker(WeatherFeature pointFeature) {
    if (_pbfMarkers[pointFeature.address] == null) {
      _pbfMarkers[pointFeature.address] = pointFeature;
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
                                element.address,
                                style: TextStyle(color: theme.primaryColor),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //                                      final  String airTemperatureC;
                                    //  final  String roadTemperatureC;
                                    //  final  String precipitationType;
                                    //  final  String roadCondition;
                                    //  final  String updatedAt;
                                    if (element.airTemperatureC != null)
                                      Text(
                                        "airTemperatureC: ${element.airTemperatureC}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    if (element.roadTemperatureC != null)
                                      Text(
                                        "roadTemperatureC: ${element.roadTemperatureC}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    if (element.precipitationType != null)
                                      Text(
                                        "precipitationType: ${element.precipitationType}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    if (element.roadCondition != null)
                                      Text(
                                        "roadCondition: ${element.roadCondition}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    if (element.updatedAt != null)
                                      Text(
                                        "updatedAt: ${element.updatedAt}",
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
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
                        roadWeatherIcons,
                      ),
                    ),
                  ))
              .toList()
          : [],
    );
  }

//https://api.dev.stadtnavi.eu/map/v1/weather-stations/15/17193/11311.pbf
  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.dev.stadtnavi.eu",
      path: "/map/v1/weather-stations/$z/$x/$y.pbf",
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
          final WeatherFeature pointFeature =
              WeatherFeature.fromGeoJsonPoint(geojson);
          // final pbfLayer = pbfParkingLayers[pointFeature.type];
          weatherLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }
}
