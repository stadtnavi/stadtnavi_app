import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parking_zone_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parking_zones_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parking_zones_model.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class ParkingZonesLayer extends CustomLayer {
  final List<ParkingZonePoligonModel> _parkingZonePoligons = [];
  final List<ParkingZoneMarkerModel> _parkingZoneMarkers = [];
  bool _isFetching = false;

  ParkingZonesLayer(String id, String weight) : super(id, weight) {
    load();
  }

  @override
  LayerOptions buildLayerOptions(int? zoom) {
    if (_parkingZonePoligons.isEmpty) {
      load();
    }
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = 35;
        break;
      case 16:
        markerSize = 35;
        break;
      case 17:
        markerSize = 35;
        break;
      case 18:
        markerSize = 40;
        break;
      default:
        markerSize = zoom != null && zoom > 12 ? 30 : null;
    }
    return PolygonLayerOptions(
      polygonCulling: true,
      polygons: markerSize != null
          ? _parkingZonePoligons
              .map(
                (element) => Polygon(
                  points: element.coordinates,
                  color: element.backgroundcolor,
                  borderStrokeWidth: 1.5,
                  borderColor: element.borderColor,
                ),
              )
              .toList()
          : [],
    );
  }

  @override
  LayerOptions? buildLayerOptionsPriority(int? zoom) {
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = 35;
        break;
      case 16:
        markerSize = 35;
        break;
      case 17:
        markerSize = 35;
        break;
      case 18:
        markerSize = 40;
        break;
      default:
        markerSize = zoom != null && zoom > 12 ? 30 : null;
    }
    return MarkerLayerOptions(
      markers: markerSize != null
          ? _parkingZoneMarkers
              .map((element) => Marker(
                    height: markerSize! * .8,
                    width: markerSize * .8,
                    point: element.coordinates,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        final panelCubit = context.read<PanelCubit>();
                        panelCubit.setPanel(
                          CustomMarkerPanel(
                            panel: (context, onFetchPlan) => ParkingZoneModal(
                              element: element,
                            ),
                            positon: element.coordinates,
                            minSize: 100,
                          ),
                        );
                      },
                      child: FittedBox(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: element.icon,
                        ),
                      ),
                    ),
                  ))
              .toList()
          : [],
    );
  }

  Future<void> load() async {
    if (_parkingZoneMarkers.isNotEmpty && _parkingZonePoligons.isNotEmpty) {
      return;
    }
    if (_isFetching) {
      return;
    }
    _isFetching = true;
    final uri = Uri(
      scheme: "https",
      host: 'node21-iot.apps.okd.swlb.de',
      path: "/parkzonen.json",
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
          "Server Error ParkZone $uri with ${response.statusCode}",
        );
      }
      final body = jsonDecode(response.body);
      final List features = body["features"] as List;
      for (Map<String, dynamic> x in features) {
        if (x['geometry']?['type'] == 'Polygon') {
          _parkingZonePoligons.add(ParkingZonePoligonModel.fromJson(x));
        } else if (x['geometry']?['type'] == 'Point') {
          _parkingZoneMarkers.add(ParkingZoneMarkerModel.fromJson(x));
        }
      }
      _isFetching = false;
    } catch (e) {
      _isFetching = false;
      throw Exception(
        "Parse error ParkZone: $e",
      );
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en" ? "Parking zones" : "Parkplätze";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(parkingZones);
  }
}
