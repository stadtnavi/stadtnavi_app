import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart' as maps;

/// Animations helper - MapLibre handles camera animations natively,
/// so this just delegates to the controller.
class TrufiMapAnimations {
  TrufiMapAnimations();

  void move({
    required LatLng center,
    required double zoom,
    required TickerProvider vsync,
    required maps.TrufiMapController mapController,
  }) {
    mapController.moveCamera(
      maps.TrufiCameraPosition(target: center, zoom: zoom),
    );
  }

  void fitBounds({
    required maps.LatLngBounds bounds,
    required TickerProvider vsync,
    required maps.TrufiMapController mapController,
  }) {
    mapController.fitBounds(
      bounds,
      padding: EdgeInsets.all(50),
    );
  }
}
