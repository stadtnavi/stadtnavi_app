import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';
import 'package:trufi_core/base/widgets/maps/utils/trufi_map_animations.dart';

part 'trufi_map_state.dart';

class TrufiMapController extends Cubit<TrufiMapState> {
  final MapController mapController = MapController();

  TrufiMapController() : super(const TrufiMapState());

  Map<PlanItinerary, List<PolylineWithMarkers>> itineraries = {};
  LatLngBounds? get selectedBounds => _selectedBounds;
  LatLngBounds? _selectedBounds;

  void cleanMap() {
    _selectedBounds = null;
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
    // _selectedBounds.extend(from.latLng);
    // _selectedBounds.extend(to.latLng);
    final itineraries = _buildItineraries(
      plan: plan,
      selectedItinerary: selectedItinerary,
      onTap: onTap,
    );
    final _unselectedMarkers = <Marker>[];
    final _unselectedPolylines = <Polyline>[];
    final _selectedMarkers = <Marker>[];
    final _selectedPolylines = <Polyline>[];
    final _allPolylines = <Polyline>[];
    itineraries.forEach((itinerary, polylinesWithMarker) {
      final bool isSelected = itinerary == selectedItinerary;
      if (isSelected || showAllItineraries) {
        for (final polylineWithMarker in polylinesWithMarker) {
          for (final marker in polylineWithMarker.markers) {
            if (isSelected) {
              _selectedMarkers.add(marker);
              _selectedBounds!.extend(marker.point);
            } else {
              _unselectedMarkers.add(marker);
            }
          }
          if (isSelected) {
            _selectedPolylines.add(polylineWithMarker.polyline);
            for (final point in polylineWithMarker.polyline.points) {
              _selectedBounds!.extend(point);
            }
          } else {
            _unselectedPolylines.add(polylineWithMarker.polyline);
          }
          _allPolylines.add(polylineWithMarker.polyline);
        }
      }
    });
    emit(
      state.copyWith(
        unselectedMarkersLayer: MarkerLayer(markers: _unselectedMarkers),
        unselectedPolylinesLayer:
            PolylineLayer(polylines: _unselectedPolylines),
        selectedMarkersLayer: MarkerLayer(markers: _selectedMarkers),
        selectedPolylinesLayer: PolylineLayer(polylines: _selectedPolylines),
      ),
    );
    moveCurrentBounds(tickerProvider: tickerProvider);
  }

  Map<PlanItinerary, List<PolylineWithMarkers>> _buildItineraries({
    required PlanEntity plan,
    required PlanItinerary selectedItinerary,
    required Function(PlanItinerary p1) onTap,
  }) {
    itineraries = {};
    if (plan.itineraries != null) {
      for (final itinerary in plan.itineraries!) {
        final List<Marker> markers = [];
        final List<PolylineWithMarkers> polylinesWithMarkers = [];
        final bool isSelected = itinerary == selectedItinerary;
        final bool showOnlySelected = selectedItinerary.isOnlyShowItinerary;
        if (!showOnlySelected || isSelected) {
          final List<PlanItineraryLeg> compressedLegs = itinerary.compressLegs;
          for (int i = 0; i < compressedLegs.length; i++) {
            final PlanItineraryLeg leg = compressedLegs[i];
            // Polyline
            final List<LatLng> points = leg.accumulatedPoints.isNotEmpty
                ? leg.accumulatedPoints
                : decodePolyline(leg.points);
            final Color color = isSelected
                ? leg.transportMode == TransportMode.bicycle &&
                        leg.fromPlace?.bikeRentalStation != null
                    ? getBikeRentalNetwork(
                            leg.fromPlace!.bikeRentalStation!.networks?[0])
                        .color
                    : leg.primaryColor
                : Colors.grey;

            final Polyline polyline = Polyline(
              points: points,
              color: color,
              strokeWidth: isSelected ? 6.0 : 3.0,
              pattern: leg.transportMode == TransportMode.walk
                  ? StrokePattern.dotted()
                  : StrokePattern.solid(),
            );

            // Transfer marker
            if (isSelected &&
                i < compressedLegs.length - 1 &&
                polyline.points.isNotEmpty) {
              markers.add(
                buildTransferMarker(
                  polyline.points[polyline.points.length - 1],
                ),
              );
            }
            polylinesWithMarkers.add(PolylineWithMarkers(polyline, markers));
          }
        }
        itineraries.addAll({itinerary: polylinesWithMarkers});
      }
    }
    return itineraries;
  }

  void move({
    required LatLng center,
    required double zoom,
    TickerProvider? tickerProvider,
  }) {
    if (tickerProvider == null) {
      mapController.move(center, zoom);
    } else {
      TrufiMapAnimations.move(
        center: center,
        zoom: zoom,
        vsync: tickerProvider,
        mapController: mapController,
      );
    }
  }

  void _fitBounds({
    required LatLngBounds? bounds,
    TickerProvider? tickerProvider,
  }) {
    if (bounds == null) return;
    if (tickerProvider == null) {
      mapController.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(50),
      ));
    } else {
      TrufiMapAnimations.fitBounds(
        bounds: bounds,
        vsync: tickerProvider,
        mapController: mapController,
      );
    }
  }
}
