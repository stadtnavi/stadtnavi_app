import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

class WeatherLayer extends CustomLayer {
  final Map<String, WeatherFeature> _pbfMarkers = {};

  WeatherLayer(String id, String weight) : super(id, weight);
  void addMarker(WeatherFeature pointFeature) {
    if (_pbfMarkers[pointFeature.address] == null) {
      _pbfMarkers[pointFeature.address] = pointFeature;
      refresh();
    }
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
    return [];
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
        markerSize = zoom != null && zoom > 18 ? 35 : null;
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
                    height: markerSize!,
                    width: markerSize,
                    point: element.position,
                    alignment: Alignment.center,
                    child: Builder(builder: (context) {
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
                                  ParkingMarkerModal(
                                parkingFeature: element,
                                onFetchPlan: onFetchPlan,
                              ),
                              positon: element.position,
                              minSize: 50,
                            ),
                          );
                        },
                        child: SvgPicture.string(
                          roadWeatherIcons,
                        ),
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
                          color: Colors.black,
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

  static bool isdisable = false;

  static Future<void> fetchPBF(int z, int x, int y) async {
    if (isdisable) return;
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/map/v1/weather-stations/$z/$x/$y.pbf",
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
          final WeatherFeature? pointFeature =
              WeatherFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            StaticTileLayers.weatherLayer.addMarker(pointFeature);
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
    return localeName == "en" ? "Road weather" : "Straßenwetter";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      roadWeatherIcons,
    );
  }
}
