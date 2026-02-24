import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart' as tcm;

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';

part 'trufi_map_state.dart';

/// Concrete TrufiLayer for rendering route results on the MapLibre map.
class _RouteLayer extends tcm.TrufiLayer {
  _RouteLayer(tcm.TrufiMapController controller)
      : super(controller, id: 'stadtnavi_route', layerLevel: 10);
}

class TrufiMapController extends Cubit<TrufiMapState> {
  late final tcm.TrufiMapController mapLibreController;
  _RouteLayer? _routeLayer;

  TrufiMapController({
    required LatLng initialCenter,
    double initialZoom = 13.0,
  }) : super(const TrufiMapState()) {
    mapLibreController = tcm.TrufiMapController(
      initialCameraPosition: tcm.TrufiCameraPosition(
        target: initialCenter,
        zoom: initialZoom,
      ),
    );
  }

  _RouteLayer _getRouteLayer() {
    _routeLayer ??= _RouteLayer(mapLibreController);
    return _routeLayer!;
  }

  Map<PlanItinerary, List<PolylineWithMarkers>> itineraries = {};
  LatLngBounds? get selectedBounds => _selectedBounds;
  LatLngBounds? _selectedBounds;

  void cleanMap() {
    _selectedBounds = null;
    final layer = _routeLayer;
    if (layer != null) {
      layer.clearLines();
      layer.clearMarkers();
    }
    emit(const TrufiMapState());
  }

  final Completer<Null> readyCompleter = Completer<Null>();

  Future<Null> get onReady => readyCompleter.future;

  Future<void> moveToYourLocation({
    required BuildContext context,
    required LatLng location,
    required double zoom,
    TickerProvider? tickerProvider,
  }) async {
    move(
      center: location,
      zoom: zoom,
      tickerProvider: tickerProvider,
    );
    return;
  }

  void moveBounds({
    required List<LatLng> points,
    required TickerProvider tickerProvider,
  }) {
    _selectedBounds = LatLngBounds.fromPoints([]);
    for (final point in points) {
      _selectedBounds?.extend(point);
    }
    moveCurrentBounds(tickerProvider: tickerProvider);
  }

  void moveCurrentBounds({
    required TickerProvider tickerProvider,
  }) {
    _fitBounds(
      bounds: _selectedBounds,
      tickerProvider: tickerProvider,
    );
  }

  void selectedItinerary({
    required PlanEntity plan,
    required TrufiLocation from,
    required TrufiLocation to,
    required PlanItinerary selectedItinerary,
    required Function(PlanItinerary p1) onTap,
    required TickerProvider tickerProvider,
    bool showAllItineraries = true,
  }) {
    _selectedBounds = LatLngBounds(from.latLng, to.latLng);

    final layer = _getRouteLayer();
    final List<tcm.TrufiLine> lines = [];
    final List<tcm.TrufiMarker> markers = [];
    int lineIndex = 0;

    if (plan.itineraries != null) {
      for (final itinerary in plan.itineraries!) {
        final bool isSelected = itinerary == selectedItinerary;
        final bool showOnlySelected = selectedItinerary.isOnlyShowItinerary;
        if (!showOnlySelected || isSelected) {
          if (!isSelected && !showAllItineraries) continue;
          final List<PlanItineraryLeg> compressedLegs = itinerary.compressLegs;
          for (int i = 0; i < compressedLegs.length; i++) {
            final PlanItineraryLeg leg = compressedLegs[i];
            final List<LatLng> points = leg.accumulatedPoints.isNotEmpty
                ? leg.accumulatedPoints
                : decodePolyline(leg.points);
            if (points.isEmpty) continue;

            final Color color = isSelected
                ? leg.transportMode == TransportMode.bicycle &&
                        leg.fromPlace?.bikeRentalStation != null
                    ? getBikeRentalNetwork(
                            leg.fromPlace!.bikeRentalStation!.networks?[0])
                        .color
                    : leg.primaryColor
                : Colors.grey;

            lines.add(tcm.TrufiLine(
              id: 'route_${lineIndex++}',
              position: points,
              color: color,
              lineWidth: isSelected ? 6.0 : 3.0,
              activeDots: leg.transportMode == TransportMode.walk,
              layerLevel: isSelected ? 2 : 1,
            ));

            if (isSelected) {
              for (final point in points) {
                _selectedBounds!.extend(point);
              }
            }

            // Transfer marker between legs
            if (isSelected &&
                i < compressedLegs.length - 1 &&
                points.isNotEmpty) {
              final transferPoint = points.last;
              _selectedBounds!.extend(transferPoint);
              markers.add(tcm.TrufiMarker(
                id: 'transfer_$lineIndex',
                position: transferPoint,
                size: const Size(18, 18),
                allowOverlap: true,
                imageCacheKey: 'transfer_marker',
                widget: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                ),
              ));
            }
          }
        }
      }
    }

    // From marker
    markers.add(tcm.TrufiMarker(
      id: 'from_marker',
      position: from.latLng,
      size: const Size(24, 24),
      allowOverlap: true,
      layerLevel: 10,
      imageCacheKey: 'from_marker',
      widget: const tcm.FromMarker(height: 24),
    ));

    // To marker
    markers.add(tcm.TrufiMarker(
      id: 'to_marker',
      position: to.latLng,
      size: const Size(30, 40),
      alignment: Alignment.topCenter,
      allowOverlap: true,
      layerLevel: 10,
      imageCacheKey: 'to_marker',
      widget: const tcm.ToMarker(height: 40),
    ));

    layer.setLines(lines);
    layer.setMarkers(markers);

    emit(const TrufiMapState());
    moveCurrentBounds(tickerProvider: tickerProvider);
  }

  void move({
    required LatLng center,
    required double zoom,
    TickerProvider? tickerProvider,
  }) {
    mapLibreController.updateCamera(target: center, zoom: zoom);
  }

  void _fitBounds({
    required LatLngBounds? bounds,
    TickerProvider? tickerProvider,
  }) {
    if (bounds == null) return;
    final currentCam = mapLibreController.cameraPositionNotifier.value;
    final newCam = tcm.TrufiCameraFit.fitBoundsOnCamera(
      camera: currentCam,
      bounds: tcm.LatLngBounds(bounds.southWest, bounds.northEast),
      padding: const EdgeInsets.all(50),
    );
    mapLibreController.setCameraPosition(newCam);
  }

  @override
  Future<void> close() {
    _routeLayer?.dispose();
    mapLibreController.dispose();
    return super.close();
  }
}
