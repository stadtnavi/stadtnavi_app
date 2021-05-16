
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';

class PointFeature {
  final String code;
  final List<String> gtfsId;
  final String name;
  final String parentStation;
  final String patterns;
  final String platform;
  final PBFLayerIds type;

  final LatLng position;
  PointFeature({
    @required this.code,
    @required this.gtfsId,
    @required this.name,
    @required this.parentStation,
    @required this.patterns,
    @required this.platform,
    @required this.type,
    @required this.position,
  });
}
