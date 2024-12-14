import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';
import 'dart:math' as math;

class NextStepContainer {
  final LatLng point;
  final Widget widget;

  NextStepContainer({required this.point, required this.widget});
}

class PolylineExtended extends Polyline {
  final PlanItineraryLeg leg;
  PolylineExtended({
    required super.points,
    super.strokeWidth = 1.0,
    super.pattern = const StrokePattern.solid(),
    super.color = const Color(0xFF00FF00),
    super.borderStrokeWidth = 0.0,
    super.borderColor = const Color(0xFFFFFF00),
    super.gradientColors,
    super.colorsStop,
    super.strokeCap = StrokeCap.round,
    super.strokeJoin = StrokeJoin.round,
    super.useStrokeWidthInMeter = false,
    super.hitValue,
    required this.leg,
  });
}

class PolylineWithMarkersExtended {
  PolylineWithMarkersExtended(this.polyline, this.markers);

  final PolylineExtended polyline;
  final List<Marker> markers;
}

class ModeTrackerScreen extends StatefulWidget {
  final String title;
  final PlanItinerary itinerary;
  const ModeTrackerScreen({
    Key? key,
    required this.title,
    required this.itinerary,
  }) : super(key: key);

  @override
  _ModeTransportScreen createState() => _ModeTransportScreen();
}

class _ModeTransportScreen extends State<ModeTrackerScreen>
    with TickerProviderStateMixin {
  final TrufiMapController trufiMapController = TrufiMapController();
  MarkerLayer? routeMarker;
  PolylineLayer<Object>? routePolyline;
  List<LatLng>? originalTrackRoute;
  List<LatLng>? trackRoute;
  late StreamSubscription<CompassEvent>? _compassSubscription;
  late StreamSubscription<LatLng?>? _locationSubscription;
  List<NextStepContainer> nextSteps = [];
  double? currentHeading;
  @override
  void initState() {
    super.initState();
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        currentHeading = event.heading;
      });
    });
    _locationSubscription = GPSLocationProvider().streamLocation.listen(
          (location) {
            if (location != null) {
              navigationProcess(location);
            }
            if (trackRoute != null && trackRoute!.isNotEmpty) {
              trufiMapController.move(center: trackRoute!.first!, zoom: 20);
            }
          },
          onError: (error) {},
          onDone: () {
            // El stream se cerró
          },
        );
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final mapRouteState = context.read<MapRouteCubit>().state;
      final mapModesCubit = context.read<MapModesCubit>();
      final mapModesState = mapModesCubit.state;
      repaintMap(mapRouteState, mapModesCubit, mapModesState);

      loadOriginalRoute();
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double R = 6371000; // Radio de la Tierra en metros
    double lat1 = pos1.latitude * (3.141592653589793 / 180.0);
    double lon1 = pos1.longitude * (3.141592653589793 / 180.0);
    double lat2 = pos2.latitude * (3.141592653589793 / 180.0);
    double lon2 = pos2.longitude * (3.141592653589793 / 180.0);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;

    return distance;
  }

  void navigationProcess(LatLng currentPosition) {
    if (trackRoute == null || trackRoute!.isEmpty) return;

    int closestIndex = 0;
    double closestDistance =
        _calculateDistance(currentPosition, trackRoute!.first);

    for (int i = 1; i < trackRoute!.length; i++) {
      double distance = _calculateDistance(currentPosition, trackRoute![i]);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    if (closestIndex > 0) {
      trackRoute!.removeRange(0, closestIndex);
    }

    if (mounted) {
      setState(() {});
    }
  }
  // void navigationProcess(LatLng _currentPosition) {
  //   if (trackRoute == null) return;
  //   List<mtk.LatLng> myLatLngList = [];
  //   for (var data in trackRoute!) {
  //     myLatLngList.add(mtk.LatLng(data.latitude, data.longitude));
  //   }
  //   mtk.LatLng myPosition =
  //       mtk.LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
  //   int x = mtk.PolygonUtil.locationIndexOnPath(
  //     myPosition,
  //     myLatLngList,
  //     true,
  //     tolerance: 12,
  //   );
  //   if (x == -1) {
  //   } else {
  //     myLatLngList.removeRange(0, x);
  //     trackRoute!.clear();
  //     trackRoute!
  //         .addAll(myLatLngList.map((e) => LatLng(e.latitude, e.longitude)));
  //   }
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  void loadOriginalRoute() {
    final marker = toMarkerLayer(
      _buildItineraries(
        itinerary: widget.itinerary,
      ),
    );
    final polyline = toPolylineLayer(
      _buildItineraries(
        itinerary: widget.itinerary,
      ),
    );
    final route = widget.itinerary.compressLegs
        .map((leg) => leg.accumulatedPoints.isNotEmpty
            ? leg.accumulatedPoints
            : decodePolyline(leg.points))
        .expand((points) => points)
        .toList();

    setState(() {
      routeMarker = marker;
      routePolyline = polyline;
      originalTrackRoute = route;
      trackRoute = route;
    });
  }

  double getBearingAngle(LatLng start, LatLng end) {
    double lat1 = start.latitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double lon1 = start.longitude * math.pi / 180;
    double lon2 = end.longitude * math.pi / 180;

    double dLon = lon2 - lon1;

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x);
    return bearing;
  }

  List<PolylineWithMarkersExtended> _buildItineraries({
    required PlanItinerary itinerary,
  }) {
    final List<Marker> markers = [];
    final List<NextStepContainer> nextStepsBuilder = [];
    final List<PolylineWithMarkersExtended> polylinesWithMarkers = [];
    final List<PlanItineraryLeg> compressedLegs = itinerary.compressLegs;
    for (int i = 0; i < compressedLegs.length; i++) {
      final PlanItineraryLeg leg = compressedLegs[i];
      // Polyline
      final List<LatLng> points = leg.accumulatedPoints.isNotEmpty
          ? leg.accumulatedPoints
          : decodePolyline(leg.points);
      final Color color = leg.transportMode == TransportMode.bicycle &&
              leg.fromPlace?.bikeRentalStation != null
          ? getBikeRentalNetwork(leg.fromPlace!.bikeRentalStation!.networks?[0])
              .color
          : leg.primaryColor;

      final PolylineExtended polyline = PolylineExtended(
        points: points,
        color: color,
        strokeWidth: 6.0,
        pattern: leg.transportMode == TransportMode.walk
            ? const StrokePattern.dotted()
            : const StrokePattern.solid(),
        leg: leg,
      );
      if (leg.steps != null && leg.steps!.isNotEmpty) {
        bool isFirst = true;
        for (final step in leg.steps!) {
          LatLng point = LatLng(step.lat!, step.lon!);
          nextStepsBuilder.add(NextStepContainer(
              point: point,
              widget: StepNavigationDetails(
                step: step,
                isFirst: isFirst,
              )));
          isFirst = false;
          markers.add(
            buildTransferMarker(
              point,
            ),
          );
        }
      } else {
        if (leg.fromPlace != null) {
          PlaceEntity fromPlace = leg.fromPlace!;
          nextStepsBuilder.add(
            NextStepContainer(
              point: LatLng(fromPlace.lat, fromPlace.lon),
              widget: Text(fromPlace.name),
            ),
          );
        }
        if (leg.toPlace != null) {
          PlaceEntity toPlace = leg.toPlace!;
          nextStepsBuilder.add(
            NextStepContainer(
              point: LatLng(toPlace.lat, toPlace.lon),
              widget: Text(toPlace.name),
            ),
          );
        }
      }

      polylinesWithMarkers.add(PolylineWithMarkersExtended(polyline, markers));
    }
    setState(() {
      nextSteps = nextStepsBuilder;
    });
    return polylinesWithMarkers;
  }

  MarkerLayer toMarkerLayer(
      List<PolylineWithMarkersExtended> polylinesWithMarker) {
    final selectedMarkers = <Marker>[];
    for (final polylineWithMarker in polylinesWithMarker) {
      selectedMarkers.addAll(polylineWithMarker.markers);
    }
    return MarkerLayer(markers: selectedMarkers);
  }

  PolylineLayer<Object> toPolylineLayer(
      List<PolylineWithMarkersExtended> polylinesWithMarker) {
    final selectedPolylines = <Polyline>[];
    for (final polylineWithMarker in polylinesWithMarker) {
      selectedPolylines.add(polylineWithMarker.polyline);
    }
    return PolylineLayer(polylines: selectedPolylines);
  }

  @override
  Widget build(BuildContext context) {
    final mapRouteState = context.read<MapRouteCubit>().state;
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return BaseTrufiPage(
      child: Scaffold(
        appBar: AppBar(title: const Text("")),
        body: Stack(
          children: [
            BlocListener<MapModesCubit, MapModesState>(
              listener: (buildContext, state) {
                trufiMapController.onReady.then((_) {
                  repaintMap(mapRouteState, mapModesCubit, state);
                });
              },
              child: CustomScrollableContainer(
                openedPosition: 200,
                body: StadtnaviMap(
                  enableCurrentLocation: false,
                  trufiMapController: trufiMapController,
                  layerOptionsBuilder: (context) => [
                    if (routeMarker != null) routeMarker!,
                    if (routePolyline != null) routePolyline!,
                    MarkerLayer(markers: [
                      if (mapRouteState.fromPlace != null)
                        mapConfiguratiom.markersConfiguration
                            .buildFromMarker(mapRouteState.fromPlace!.latLng),
                      if (mapRouteState.toPlace != null)
                        mapConfiguratiom.markersConfiguration
                            .buildToMarker(mapRouteState.toPlace!.latLng),
                      // if (tempMarker != null) tempMarker!,
                      if (trackRoute != null && trackRoute!.length > 1)
                        Marker(
                          width: 50.0,
                          height: 50.0,
                          point: trackRoute!.first,
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: (currentHeading! * math.pi / 180),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white.withOpacity(.8),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: const Center(
                                child: Icon(
                                  Icons.navigation,
                                  color: Color(0xFF9BBF28),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ]),
                  ],
                ),
                panel: ListView(
                  children: nextSteps.map((value) => value.widget).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void repaintMap(MapRouteState mapRouteState, MapModesCubit mapModesCubit,
      MapModesState mapModesState) {
    if (mapModesState.plan != null && mapModesState.selectedItinerary != null) {
      trufiMapController.selectedItinerary(
          plan: mapModesState.plan!,
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          selectedItinerary: mapModesState.selectedItinerary!,
          tickerProvider: this,
          showAllItineraries: mapModesState.showAllItineraries,
          onTap: (p1) {
            mapModesCubit.selectItinerary(p1);
          });
    } else {
      trufiMapController.cleanMap();
    }
  }
}
