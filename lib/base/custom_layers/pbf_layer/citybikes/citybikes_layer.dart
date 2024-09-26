import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/consts.dart';

import 'citybike_feature_model.dart';
import 'citybike_marker_modal.dart';
import 'citybikes_enum.dart';
import 'citybikes_icon.dart';

class CityBikesLayer extends CustomLayer {
  final Map<String, CityBikeFeature> _pbfMarkers = {};

  Map<String, CityBikeFeature> get data => _pbfMarkers;

  CityBikesLayer(String layerId, String weight) : super(layerId, weight);
  void addMarker(CityBikeFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  void forceAddMarker(CityBikeFeature pointFeature) {
    _pbfMarkers[pointFeature.id] = pointFeature;
    refresh();
  }

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
        ? markersList
            .map(
              (element) => Marker(
                key: Key("$id:${element.id}"),
                height: markerSize! + 5,
                width: markerSize + 5,
                point: element.position,
                alignment: Alignment.topCenter,
                child: Builder(
                  builder: (context) {
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
                                element.id == "cargobike-herrenberg"
                                    ? CargoBikeMarkerModal(
                                        element: element,
                                        onFetchPlan: onFetchPlan,
                                      )
                                    : CitybikeMarkerModal(
                                        element: element,
                                        onFetchPlan: onFetchPlan,
                                      ),
                            positon: element.position,
                            minSize: 50,
                          ),
                        );
                      },
                      child: SharingMarkerUpdater(
                        element: element,
                        addMarker: forceAddMarker,
                        child: Stack(
                          children: [
                            Container(
                              height: markerSize,
                              width: markerSize,
                              margin: EdgeInsets.only(top: markerSize! / 5),
                              child: element.type?.imageStop,
                            ),
                            if (element.extraInfo?.bikesAvailable != null &&
                                element.extraInfo!.bikesAvailable! >= 0 &&
                                element.type != CityBikeLayerIds.carSharing)
                              Positioned(
                                right: markerSize / 5,
                                child: Container(
                                  height: markerSize / 1.7,
                                  width: markerSize / 1.7,
                                  decoration: BoxDecoration(
                                    color: element.id ==
                                                "cargobike-herrenberg" ||
                                            element.extraInfo!
                                                    .bikesAvailable! ==
                                                0
                                        ? Colors.red
                                        : element.extraInfo!.bikesAvailable! > 4
                                            ? const Color(0xff448A54)
                                            : Colors.orange,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${element.extraInfo!.bikesAvailable}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: markerSize / 2.5,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList()
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
          ? markersList
              .map((element) => Marker(
                    height: markerSize! + 5,
                    width: markerSize + 5,
                    point: element.position,
                    alignment: Alignment.topCenter,
                    child: SharingMarkerUpdater(
                      element: element,
                      addMarker: forceAddMarker,
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
                                    element.id == "cargobike-herrenberg"
                                        ? CargoBikeMarkerModal(
                                            element: element,
                                            onFetchPlan: onFetchPlan,
                                          )
                                        : CitybikeMarkerModal(
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
                                height: markerSize,
                                width: markerSize,
                                margin: EdgeInsets.only(top: markerSize! / 5),
                                child: element.type?.imageStop,
                              ),
                              if (element.extraInfo?.bikesAvailable != null &&
                                  element.extraInfo!.bikesAvailable! >= 0 &&
                                  element.type != CityBikeLayerIds.carSharing)
                                Positioned(
                                  right: markerSize / 5,
                                  child: Container(
                                    height: markerSize / 1.7,
                                    width: markerSize / 1.7,
                                    decoration: BoxDecoration(
                                      color: element.id ==
                                                  "cargobike-herrenberg" ||
                                              element.extraInfo!
                                                      .bikesAvailable! ==
                                                  0
                                          ? Colors.red
                                          : element.extraInfo!.bikesAvailable! >
                                                  4
                                              ? const Color(0xff448A54)
                                              : Colors.orange,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${element.extraInfo!.bikesAvailable}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: markerSize / 2.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );
                      }),
                    ),
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
                          color: element.type?.imageStopColor,
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

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/routing/v1/router/vectorTiles/citybikes/$z/$x/$y.pbf",
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
          final CityBikeFeature? pointFeature =
              CityBikeFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            StaticTileLayers.citybikeLayer.addMarker(pointFeature);
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
    return localeName == "en"
        ? "Car, Bike & Cargo bike sharing"
        : "Carsharing & Fahrrad- / Lastenradverleih";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      iconMenuCitybike,
    );
  }
}

class SharingMarkerUpdater extends StatefulWidget {
  final Widget child;
  final CityBikeFeature element;
  final void Function(CityBikeFeature pointFeature) addMarker;
  const SharingMarkerUpdater({
    Key? key,
    required this.child,
    required this.element,
    required this.addMarker,
  }) : super(key: key);

  @override
  _SharingMarkerUpdaterState createState() => _SharingMarkerUpdaterState();
}

class _SharingMarkerUpdaterState extends State<SharingMarkerUpdater> {
  final int interval = 30;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> loadData() async {
    if (!mounted) return;
    await LayersRepository.fetchCityBikesData(widget.element.id).then((value) {
      widget.addMarker(widget.element.copyWithExtraInfo(value));
    }).catchError((error) {});
    await Future.delayed(Duration(seconds: interval));
    if (mounted) loadData();
  }
}
