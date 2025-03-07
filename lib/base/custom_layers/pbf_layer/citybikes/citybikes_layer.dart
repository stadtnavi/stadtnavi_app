import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/map_layers/cache_map_tiles.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/city_bike_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  final MapLayerCategory mapCategory;
  // final Map<String, CityBikeFeature> _pbfMarkers = {};

  // Map<String, CityBikeFeature> get data => _pbfMarkers;

  CityBikesLayer(this.mapCategory, int weight)
      : super(mapCategory.code, weight);
  // void addMarker(CityBikeFeature pointFeature) {
  //   if (_pbfMarkers[pointFeature.id] == null) {
  //     _pbfMarkers[pointFeature.id] = pointFeature;
  //     refresh();
  //   }
  // }
  Marker buildMarker({
    required CityBikeFeature element,
    required double markerSize,
  }) {
    return Marker(
      key: Key("$id:${element.id}"),
      height: markerSize + 5,
      width: markerSize + 5,
      point: element.position,
      alignment: Alignment.topCenter,
      child: Builder(builder: (context) {
        return MarkerTileContainer(
          menuBuilder: (_) => CityBikeFeatureTile(
            element: element,
          ),
          child: GestureDetector(
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
                  position: element.position,
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
                          color: element.id == "cargobike-herrenberg" ||
                                  element.extraInfo!.bikesAvailable! == 0
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
          ),
        );
      }),
    );
  }

  void forceAddMarker(CityBikeFeature pointFeature) {
    MapMarkersRepositoryContainer.cityBikeFeature[pointFeature.id] =
        pointFeature;
    refresh();
  }

  List<CityBikeFeature> _getMarkers(int zoom) {
    final markersList =
        MapMarkersRepositoryContainer.cityBikeFeature.values.toList();
    markersList.sort(
      (a, b) => a.position.latitude.compareTo(b.position.latitude),
    );
    return markersList.where((element) {
      final targetMapLayerCategory =
          MapLayerCategory.findCategoryWithProperties(
        mapCategory,
        mapCategory.code,
      );
      final layerMinZoom =
          targetMapLayerCategory?.properties?.layerMinZoom ?? 15;
      return layerMinZoom < zoom;
    }).toList();
  }

  @override
  List<Marker>? buildClusterMarkers(int zoom) {
    return _getMarkers(zoom)
        .map((element) => buildMarker(
            element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
        .toList();
  }

  @override
  Widget buildMarkerLayer(int zoom) {
    return MarkerLayer(
      markers: _getMarkers(zoom)
          .map((element) => buildMarker(
              element: element, markerSize: CustomLayer.getMarkerSize(zoom)))
          .toList(),
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/routing/v1/router/vectorTiles/citybikes/$z/$x/$y.pbf",
    );
    Uint8List bodyByte = await cachedFirstFetch(uri);
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final CityBikeFeature? pointFeature =
              CityBikeFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null &&
              MapMarkersRepositoryContainer.cityBikeFeature[pointFeature.id] ==
                  null) {
            MapMarkersRepositoryContainer.cityBikeFeature[pointFeature.id] =
                pointFeature;
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
    return localeName == "en" ? mapCategory.en : mapCategory.de;
  }

  @override
  Widget icon(BuildContext context) {
    final icon = mapCategory.properties?.iconSvgMenu ??
        mapCategory.categories.first.properties?.iconSvgMenu;

    if (icon != null) return SvgPicture.string(icon);
    return const Icon(
      Icons.error,
      color: Colors.green,
    );
  }

  @override
  bool isDefaultOn() => mapCategory.isDefaultOn();
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
