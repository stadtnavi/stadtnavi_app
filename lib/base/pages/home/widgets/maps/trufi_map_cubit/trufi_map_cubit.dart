import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController;
import 'package:trufi_core_maps/trufi_core_maps.dart' as maps
    show TrufiMapController;

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';

part 'trufi_map_state.dart';

class TrufiMapController extends Cubit<TrufiMapState> {
  final maps.TrufiMapController mapController = maps.TrufiMapController();

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
    move(center: location, zoom: zoom);
    return;
  }

  void moveBounds({
    required List<LatLng> points,
    TickerProvider? tickerProvider,
  }) {
    if (points.isEmpty) return;
    double minLat = double.infinity, maxLat = -double.infinity;
    double minLng = double.infinity, maxLng = -double.infinity;
    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    _selectedBounds =
        LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
    moveCurrentBounds(tickerProvider: tickerProvider);
  }

  void moveCurrentBounds({
    TickerProvider? tickerProvider,
  }) {
    _fitBounds(bounds: _selectedBounds);
  }

  void selectedItinerary({
    required PlanEntity plan,
    required TrufiLocation from,
    required TrufiLocation to,
    required PlanItinerary selectedItinerary,
    required Function(PlanItinerary p1) onTap,
    TickerProvider? tickerProvider,
    bool showAllItineraries = true,
  }) {
    _selectedBounds = LatLngBounds(from.latLng, to.latLng);
    final builtItineraries = _buildItineraries(
      plan: plan,
      selectedItinerary: selectedItinerary,
      onTap: onTap,
    );
    final unselectedMarkers = <TrufiMarker>[];
    final unselectedLines = <TrufiLine>[];
    final selectedMarkers = <TrufiMarker>[];
    final selectedLines = <TrufiLine>[];
    final allPoints = <LatLng>[from.latLng, to.latLng];

    builtItineraries.forEach((itinerary, polylinesWithMarker) {
      final bool isSelected = itinerary == selectedItinerary;
      if (isSelected || showAllItineraries) {
        for (final polylineWithMarker in polylinesWithMarker) {
          for (final marker in polylineWithMarker.markers) {
            if (isSelected) {
              selectedMarkers.add(marker);
              allPoints.add(marker.position);
            } else {
              unselectedMarkers.add(marker);
            }
          }
          if (isSelected) {
            selectedLines.add(polylineWithMarker.line);
            allPoints.addAll(polylineWithMarker.line.position);
          } else {
            unselectedLines.add(polylineWithMarker.line);
          }
        }
      }
    });

    if (allPoints.isNotEmpty) {
      double minLat = double.infinity, maxLat = -double.infinity;
      double minLng = double.infinity, maxLng = -double.infinity;
      for (final p in allPoints) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }
      _selectedBounds =
          LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
    }

    emit(
      state.copyWith(
        unselectedMarkers: unselectedMarkers,
        unselectedLines: unselectedLines,
        selectedMarkers: selectedMarkers,
        selectedLines: selectedLines,
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
        final List<TrufiMarker> markers = [];
        final List<PolylineWithMarkers> polylinesWithMarkers = [];
        final bool isSelected = itinerary == selectedItinerary;
        final bool showOnlySelected = selectedItinerary.isOnlyShowItinerary;
        if (!showOnlySelected || isSelected) {
          final List<PlanItineraryLeg> compressedLegs = itinerary.compressLegs;
          for (int i = 0; i < compressedLegs.length; i++) {
            final PlanItineraryLeg leg = compressedLegs[i];
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

            final line = TrufiLine(
              id: 'itinerary_${itinerary.hashCode}_leg_$i',
              position: points,
              color: color,
              lineWidth: isSelected ? 6.0 : 3.0,
              activeDots: leg.transportMode == TransportMode.walk,
            );

            if (isSelected &&
                i < compressedLegs.length - 1 &&
                points.isNotEmpty) {
              markers.add(
                buildTransferTrufiMarker(points[points.length - 1]),
              );
            }
            polylinesWithMarkers.add(PolylineWithMarkers(line, markers));
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
  }) {
    mapController.moveCamera(
      TrufiCameraPosition(target: center, zoom: zoom),
    );
  }

  void _fitBounds({required LatLngBounds? bounds}) {
    if (bounds == null) return;
    mapController.fitBounds(
      bounds,
      padding: EdgeInsets.all(50),
    );
  }
}
