import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch,
         MyLocationMarker;

import 'package:trufi_core/base/widgets/maps/markers/base_marker/my_location_marker.dart';
import 'package:trufi_core/base/widgets/maps/markers/marker_configuration.dart'
    as trufi_markers;
import 'package:stadtnavi_core/base/pages/home/widgets/maps/markers/marker_configuration.dart'
    as stadtnavi_markers;

class CustomMarkerConfiguration extends trufi_markers.MarkerConfiguration
    implements stadtnavi_markers.MarkerConfiguration {
  CustomMarkerConfiguration();

  @override
  Widget get fromMarker =>
      const Icon(Icons.location_on, size: 18, color: Color(0xff4ea700));

  @override
  Widget get toMarker =>
      const Icon(Icons.location_on, size: 18, color: Color(0xffec5188));

  @override
  Widget get yourLocationMarker => const MyLocationMarker();

  // trufi_core legacy methods (return flutter_map Marker)
  @override
  Marker buildFromMarker(LatLng point) {
    return Marker(
      point: point, width: 28, height: 28, alignment: Alignment.center,
      child: _buildMarkerWidget(fromMarker),
    );
  }

  @override
  Marker buildToMarker(LatLng point) {
    return Marker(
      point: point, width: 28, height: 28, alignment: Alignment.topCenter,
      child: _buildMarkerWidget(toMarker),
    );
  }

  @override
  Marker buildYourLocationMarker(LatLng? point) {
    return (point != null)
        ? Marker(width: 50, height: 50, point: point,
            alignment: Alignment.center, child: const MyLocationMarker())
        : Marker(width: 0, height: 0, point: LatLng(0, 0), child: Container());
  }

  @override
  MarkerLayer buildFromMarkerLayerOptions(LatLng point) =>
      MarkerLayer(markers: [buildFromMarker(point)]);
  @override
  MarkerLayer buildToMarkerLayerOptions(LatLng point) =>
      MarkerLayer(markers: [buildToMarker(point)]);
  @override
  MarkerLayer buildYourLocationMarkerLayerOptions(LatLng? point) =>
      MarkerLayer(markers: [buildYourLocationMarker(point)]);

  // stadtnavi new methods (return TrufiMarker)
  @override
  TrufiMarker buildFromTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'from_marker', position: point,
      size: const Size(28, 28), alignment: Alignment.center,
      imageCacheKey: 'from_marker', allowOverlap: true,
      widget: _buildMarkerWidget(fromMarker),
    );
  }

  @override
  TrufiMarker buildToTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'to_marker', position: point,
      size: const Size(28, 28), alignment: Alignment.topCenter,
      imageCacheKey: 'to_marker', allowOverlap: true,
      widget: _buildMarkerWidget(toMarker),
    );
  }

  @override
  TrufiMarker buildYourLocationTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'your_location', position: point,
      size: const Size(50, 50), alignment: Alignment.center,
      imageCacheKey: 'your_location', allowOverlap: true,
      widget: const MyLocationMarker(),
    );
  }

  Widget _buildMarkerWidget(Widget marker) {
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
