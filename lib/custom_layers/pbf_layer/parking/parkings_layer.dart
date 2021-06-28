import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_marker_modal.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parkings_enum.dart';
import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'parking_feature_model.dart';
import 'parking_icons.dart';

class ParkingLayer extends CustomLayer {
  final Map<String, ParkingFeature> _pbfMarkers = {};

  ParkingLayer(String id) : super(id);
  void addMarker(ParkingFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  void forceAddMarker(ParkingFeature pointFeature) {
    _pbfMarkers[pointFeature.id] = pointFeature;
    refresh();
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
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
    return MarkerLayerOptions(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize,
                    width: markerSize,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    builder: (context) => ParkingStateUpdater(
                      element: element,
                      addMarker: forceAddMarker,
                      child: GestureDetector(
                        onTap: () {
                          final panelCubit = context.read<PanelCubit>();
                          panelCubit.setPanel(
                            CustomMarkerPanel(
                              panel: (context, onFetchPlan) =>
                                  ParkingMarkerModal(
                                parkingFeature: element,
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
                              margin: EdgeInsets.only(
                                left: markerSize / 5,
                                top: markerSize / 5,
                              ),
                              child: SvgPicture.string(
                                parkingMarkerIcons[element.type] ?? "",
                              ),
                            ),
                            if (element.markerState() != null)
                              if (element.markerState())
                                Positioned(
                                  child: Container(
                                    height: markerSize / 2,
                                    width: markerSize / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        size: markerSize / 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: markerSize / 2,
                                  width: markerSize / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: markerSize / 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
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
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      builder: (context) => Container(
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

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.dev.stadtnavi.eu",
      path: "/routing/v1/router/vectorTiles/parking/$z/$x/$y.pbf",
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
          if (pointFeature != null && pointFeature.id != null) {
            parkingLayer?.addMarker(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en" ? "Parking spaces" : "Parkplätze";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
      parkingMarkerIcons[ParkingsLayerIds.parkingSpot],
    );
  }
}

class ParkingStateUpdater extends StatefulWidget {
  final Widget child;
  final ParkingFeature element;
  final void Function(ParkingFeature pointFeature) addMarker;
  const ParkingStateUpdater({
    Key key,
    @required this.child,
    @required this.element,
    @required this.addMarker,
  }) : super(key: key);

  @override
  _ParkingStateUpdaterState createState() => _ParkingStateUpdaterState();
}

class _ParkingStateUpdaterState extends State<ParkingStateUpdater> {
  final int interval = 30;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (widget.element.carPlacesCapacity != null &&
          widget.element.availabilityCarPlacesCapacity != null) {
        loadData();
      }
      if (widget.element.totalDisabled != null &&
          widget.element.freeDisabled != null) {
        loadDisabledData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> loadData() async {
    if (!mounted) return;
    await LayersRepository.fetchPark(widget.element.id).then((value) {
      final data = ParkingFeature(
        geoJsonPoint: widget.element.geoJsonPoint,
        id: widget.element.id,
        name: widget.element.name,
        note: widget.element.note,
        url: widget.element.url,
        state: widget.element.state,
        tags: widget.element.tags,
        openingHours: widget.element.openingHours,
        feeHours: widget.element.feeHours,
        bicyclePlaces: widget.element.bicyclePlaces,
        anyCarPlaces: widget.element.anyCarPlaces,
        carPlaces: widget.element.carPlaces,
        wheelchairAccessibleCarPlaces:
            widget.element.wheelchairAccessibleCarPlaces,
        realTimeData: widget.element.realTimeData,
        capacity: widget.element.capacity,
        bicyclePlacesCapacity: widget.element.bicyclePlacesCapacity,
        carPlacesCapacity: widget.element.carPlacesCapacity,
        availabilityCarPlacesCapacity: value.availability.carSpaces,
        totalDisabled: widget.element.totalDisabled,
        freeDisabled: widget.element.freeDisabled,
        type: widget.element.type,
        position: widget.element.position,
      );
      widget.addMarker(data);
    }).catchError((error) {});
    await Future.delayed(Duration(seconds: interval));
    if (mounted) loadData();
  }

  Future<void> loadDisabledData() async {
    if (!mounted) return;
    await LayersRepository.fetchPark(widget.element.id).then((value) {
      final data = ParkingFeature(
        geoJsonPoint: widget.element.geoJsonPoint,
        id: widget.element.id,
        name: widget.element.name,
        note: widget.element.note,
        url: widget.element.url,
        state: widget.element.state,
        tags: widget.element.tags,
        openingHours: widget.element.openingHours,
        feeHours: widget.element.feeHours,
        bicyclePlaces: widget.element.bicyclePlaces,
        anyCarPlaces: widget.element.anyCarPlaces,
        carPlaces: widget.element.carPlaces,
        wheelchairAccessibleCarPlaces:
            widget.element.wheelchairAccessibleCarPlaces,
        realTimeData: widget.element.realTimeData,
        capacity: widget.element.capacity,
        bicyclePlacesCapacity: widget.element.bicyclePlacesCapacity,
        carPlacesCapacity: widget.element.carPlacesCapacity,
        availabilityCarPlacesCapacity:
            widget.element.availabilityCarPlacesCapacity,
        totalDisabled: widget.element.totalDisabled,
        freeDisabled: value.availability.wheelchairAccessibleCarSpaces,
        type: widget.element.type,
        position: widget.element.position,
      );
      widget.addMarker(data);
    }).catchError((error) {});
    await Future.delayed(Duration(seconds: interval));
    if (mounted) loadDisabledData();
  }
}
