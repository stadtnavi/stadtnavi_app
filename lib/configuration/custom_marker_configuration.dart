import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:trufi_core/base/widgets/maps/markers/base_marker/my_location_marker.dart';
import 'package:trufi_core/base/widgets/maps/markers/marker_configuration.dart';

class CustomMarkerConfiguration implements MarkerConfiguration {
  const CustomMarkerConfiguration();

  @override
  Widget get fromMarker =>
      const Icon(Icons.location_on, size: 18, color: Color(0xff4ea700));

  @override
  Widget get toMarker =>
      const Icon(Icons.location_on, size: 18, color: Color(0xffec5188));

  @override
  Widget get yourLocationMarker => const MyLocationMarker();

  @override
  Marker buildFromMarker(LatLng point) {
    return Marker(
      point: point,
      width: 28.0,
      height: 28.0,
      alignment: Alignment.center,
      child: _buildMarker(fromMarker),
    );
  }

  @override
  Marker buildToMarker(LatLng point) {
    return Marker(
      point: point,
      width: 28.0,
      height: 28.0,
      alignment: Alignment.topCenter,
      child: _buildMarker(toMarker),
    );
  }

  @override
  Marker buildYourLocationMarker(LatLng? point) {
    return (point != null)
        ? Marker(
            width: 50.0,
            height: 50.0,
            point: point,
            alignment: Alignment.center,
            child: const MyLocationMarker(),
          )
        : Marker(
            width: 0,
            height: 0,
            point: LatLng(0, 0),
            child: Container(),
          );
  }

  @override
  MarkerLayer buildFromMarkerLayerOptions(LatLng point) {
    return MarkerLayer(markers: [buildFromMarker(point)]);
  }

  @override
  MarkerLayer buildToMarkerLayerOptions(LatLng point) {
    return MarkerLayer(markers: [buildToMarker(point)]);
  }

  @override
  MarkerLayer buildYourLocationMarkerLayerOptions(LatLng? point) {
    return MarkerLayer(markers: [buildYourLocationMarker(point)]);
  }

  Widget _buildMarker(Widget marker) {
    return FittedBox(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(width: 10, height: 10, color: Colors.white),
          const Icon(Icons.location_on, size: 23, color: Colors.white),
          marker
        ],
      ),
    );
  }
}
