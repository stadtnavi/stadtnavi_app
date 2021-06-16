import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_app/configuration_service.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/bike_parks/bike_parks_enum.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:stadtnavi_app/custom_layers/widget/marker_modal.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'package:http/http.dart' as http;
import 'package:vector_tile/vector_tile.dart';

import 'bike_park_feature_model.dart';
import 'bike_park_icons.dart';
import 'citybike_marker_modal.dart';

class BikeParkLayer extends CustomLayer {
  final Map<String, BikeParkFeature> _pbfMarkers = {};

  BikeParkLayer(String id) : super(id);
  void addMarker(BikeParkFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
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
                        showBottomMarkerModal(
                          context: context,
                          builder: (BuildContext context) =>
                              CitybikeMarkerModal(
                            element: element,
                          ),
                        );
                      },
                      child: parkingMarkerIcons[element.type] != null
                          ? SvgPicture.string(
                              parkingMarkerIcons[element.type],
                            )
                          : const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                    ),
                  ))
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
          final BikeParkFeature pointFeature =
              BikeParkFeature.fromGeoJsonPoint(geojson);
          bikeParkLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en" ? "Bike parking spaces" : "Fahrradparkplätze";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(
                              parkingMarkerIcons[BikeParkLayerIds.notCovered],
                            );
  }
}
