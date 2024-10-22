import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bicycle_network/bicycle_network_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bicycle_network/bicycle_network_icons.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:flutter_svg/svg.dart';

class BicycleNetworkLayer extends CustomLayer {
  List<BicycleNetworkModel> _bicycleNetworks = [];
  List<BicycleNetworkJoin> _listlist = [];
  bool _isFetching = false;

  BicycleNetworkLayer(String id, String weight) : super(id, weight) {
    load();
  }

  Future<void> load() async {
    if (_listlist.isNotEmpty) {
      return;
    }
    if (_isFetching) {
      return;
    }
    _isFetching = true;
    final uri = Uri(
      scheme: "https",
      host: 'stadtnavi.swlb.de',
      path: "/assets/geojson/lb-layers/radnetz.json",
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
          "Server Error ParkZone $uri with ${response.statusCode}",
        );
      }
      final body =
          jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true));
      final List features = body["features"] as List;
      _bicycleNetworks = List<BicycleNetworkModel>.from(features
          .map((x) => BicycleNetworkModel.fromJson(x as Map<String, dynamic>)));

      _listlist = combine2(_bicycleNetworks);
      refresh();
      _isFetching = false;
    } catch (e) {
      _isFetching = false;
      throw Exception(
        "Parse error ParkZone: $e",
      );
    }
  }

  List<BicycleNetworkJoin> combine2(List<BicycleNetworkModel> list) {
    final lists = list.toSet().toList();
    final List<BicycleNetworkJoin> out = [];
    for (BicycleNetworkModel element in lists) {
      List<List<LatLng>> points = [];
      for (BicycleNetworkModel element2 in list) {
        if (element == element2) {
          points.add(element2.coordinates);
        }
      }
      out.add(
        BicycleNetworkJoin(
            coordinates: points,
            color: element.color,
            weight: element.weight,
            dashArray: element.dashArray),
      );
    }
    return out;
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
    return [];
  }

  @override
  Widget? buildLayerOptionsBackground(int? zoom) {
    if (_listlist.isEmpty) {
      load();
    }
    // double? markerSize;
    // switch (zoom) {
    //   case 15:
    //     markerSize = 0.5;
    //     break;
    //   case 16:
    //     markerSize = 1;
    //     break;
    //   case 17:
    //     markerSize = 1.5;
    //     break;
    //   case 18:
    //     markerSize = 2;
    //     break;
    //   default:
    //     markerSize = zoom != null && zoom > 12 ? -0.5 : null;
    // }
    return null;
    // TODO review PolylineLayer
    // return CustomPolylineLayer(
    //   polylineCulling: true,
    //   polylineOpts: markerSize != null
    //       ? _listlist
    //           .map((e) => CustomPolyline(
    //                 points: e.coordinates,
    //                 strokeWidth: e.weight + markerSize!,
    //                 color: e.color,
    //                 borderColor: e.color,
    //                 isDotted: e.dashArray != null,
    //               ))
    //           .toList()
    //       : [],
    // );
  }

  @override
  Widget buildLayerOptions(int? zoom) {
    return PolygonLayer<Object>(
      polygons: [],
    );
  }

  @override
  Widget? buildLayerOptionsPriority(int zoom) {
    return null;
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en" ? "Bicycle network" : "Radnetz Ludwigsburg";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(bicycleNetwork);
  }
}
