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
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'parking_feature_model.dart';
import 'parking_icons.dart';

class ParkingLayer extends CustomLayer {
  final Map<String, ParkingFeature> _pbfMarkers = {};

  Map<String, ParkingFeature> get data => _pbfMarkers;

  ParkingLayer(String id, String weight) : super(id, weight);

  void addMarker(ParkingFeature pointFeature) {
    if (pointFeature.id != null && _pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id!] = pointFeature;
      refresh();
    }
  }

  // void forceAddMarker(ParkingFeature pointFeature) {
  //   if (pointFeature.id != null) {
  //     _pbfMarkers[pointFeature.id!] = pointFeature;
  //     refresh();
  //   }
  // }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
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
    return markerSize != null
        ? markersList.map((element) {
            final availabilityParking = element.markerState();
            return Marker(
              key: Key("$id:${element.id}"),
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
                            ParkingStateUpdater(
                          parkingFeature: element,
                          onFetchPlan: onFetchPlan,
                          isOnlyDestination: isOnlyDestination ?? false,
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
                          parkingMarkerIcons[element.type] ?? "",
                        ),
                      ),
                      if (availabilityParking != null)
                        availabilityParking.getImage(size: markerSize / 2),
                    ],
                  ),
                );
              }),
            );
          }).toList()
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
          ? markersList.map((element) {
              final availabilityParking = element.markerState();
              return Marker(
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
                              ParkingStateUpdater(
                            parkingFeature: element,
                            onFetchPlan: onFetchPlan,
                            isOnlyDestination: isOnlyDestination ?? false,
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
                            parkingMarkerIcons[element.type] ?? "",
                          ),
                        ),
                        if (availabilityParking != null)
                          availabilityParking.getImage(size: markerSize / 2),
                      ],
                    ),
                  );
                }),
              );
            }).toList()
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
                          color: const Color(0xff005ab4),
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

  static int valZ = 0;
  static int valX = 0;
  static int valY = 0;
  static Future<void> fetchPBF(int z, int x, int y) async {
    valZ = z;
    valX = x;
    valY = y;
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/routing/v1/router/vectorTiles/parking/$z/$x/$y.pbf",
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
          final ParkingFeature? pointFeature =
              ParkingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null && pointFeature.id != null) {
            StaticTileLayers.parkingLayer.addMarker(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
    await Future.delayed(const Duration(seconds: 25)).then((value) {
      if (valX == x && valY == y && valZ == z) {
        fetchPBF(z, x, y);
      }
    });
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en" ? "Parking spaces" : "Parkplätze";
  }

  @override
  Widget icon(BuildContext context) {
    return parkingMarkerIcons[ParkingsLayerIds.parkingSpot] != null
        ? SvgPicture.string(
            parkingMarkerIcons[ParkingsLayerIds.parkingSpot]!,
          )
        : const Icon(Icons.error);
  }
}
