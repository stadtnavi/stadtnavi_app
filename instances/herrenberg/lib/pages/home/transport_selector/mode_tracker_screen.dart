// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'package:stadtnavi_core/base/models/plan_entity.dart';
// import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
// import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
// import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
// import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
// import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
// import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
// import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/transit_leg.dart';
// import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
// import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
// import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';
// import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';

// import 'package:trufi_core/base/models/enums/transport_mode.dart';
// import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';
// import 'dart:math' as math;

// import 'package:wakelock_plus/wakelock_plus.dart';

// class NextStepContainer {
//   final LatLng point;
//   final Widget widget;

//   NextStepContainer({required this.point, required this.widget});
// }

// class ModeTrackerScreen extends StatefulWidget {
//   final String title;
//   final String warning;
//   final PlanItinerary itinerary;
//   const ModeTrackerScreen({
//     Key? key,
//     required this.title,
//     required this.warning,
//     required this.itinerary,
//   }) : super(key: key);

//   @override
//   _ModeTransportScreen createState() => _ModeTransportScreen();
// }

// class _ModeTransportScreen extends State<ModeTrackerScreen>
//     with TickerProviderStateMixin {
//   final TrufiMapController trufiMapController = TrufiMapController();
//   PolylineLayer<Object>? originalRoute;
//   PolylineLayer<Object>? currentRoute;
//   bool _popupShown = false;
//   late StreamSubscription<CompassEvent>? _compassSubscription;
//   late StreamSubscription<LatLng?>? _locationSubscription;
//   LatLng? lastPosition;
//   List<NextStepContainer> nextSteps = [];
//   double? currentHeading;
//   @override
//   void initState() {
//     super.initState();
//     WakelockPlus.enable();
//     _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
//       setState(() {
//         currentHeading = event.heading;
//       });
//     });
//     _locationSubscription = GPSLocationProvider().streamLocation.listen(
//       (location) {
//         if (location != null) {
//           navigationHeaderProcess(location);
//           final newPos = navigationProcess(location);
//           if (newPos != null) {
//             trufiMapController.move(center: newPos, zoom: 20);
//           }
//           setState(() {
//             currentRoute = PolylineLayer(polylines: currentRoute!.polylines);
//             lastPosition = newPos;
//           });
//         }
//       },
//       onError: (error) {},
//       onDone: () {},
//     );
//     WidgetsBinding.instance.addPostFrameCallback((duration) {
//       final mapRouteState = context.read<MapRouteCubit>().state;
//       final mapModesCubit = context.read<MapModesCubit>();
//       final mapModesState = mapModesCubit.state;
//       repaintMap(mapRouteState, mapModesCubit, mapModesState);

//       loadOriginalRoute();
//     });
//   }

//   @override
//   void dispose() {
//     _compassSubscription?.cancel();
//     _locationSubscription?.cancel();
//     WakelockPlus.disable();
//     super.dispose();
//   }

//   double _calculateDistance(LatLng pos1, LatLng pos2) {
//     const double R = 6371000;
//     double lat1 = pos1.latitude * (3.141592653589793 / 180.0);
//     double lon1 = pos1.longitude * (3.141592653589793 / 180.0);
//     double lat2 = pos2.latitude * (3.141592653589793 / 180.0);
//     double lon2 = pos2.longitude * (3.141592653589793 / 180.0);

//     double dLat = lat2 - lat1;
//     double dLon = lon2 - lon1;

//     double a = (sin(dLat / 2) * sin(dLat / 2)) +
//         (cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2));
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = R * c;

//     return distance;
//   }

//   LatLng? navigationProcess(LatLng currentPosition) {
//     if (currentRoute == null || currentRoute!.polylines.isEmpty) return null;

//     int closestPolylineIndex = -1;
//     int closestPointIndex = -1;
//     double closestDistance = double.infinity;

//     for (int polylineIndex = 0;
//         polylineIndex < currentRoute!.polylines.length;
//         polylineIndex++) {
//       final polyline = currentRoute!.polylines[polylineIndex];
//       for (int pointIndex = 0;
//           pointIndex < polyline.points.length;
//           pointIndex++) {
//         final point = polyline.points[pointIndex];
//         double distance = _calculateDistance(currentPosition, point);
//         if (distance < closestDistance) {
//           closestDistance = distance;
//           closestPolylineIndex = polylineIndex;
//           closestPointIndex = pointIndex;
//         }
//       }
//     }
//     if (closestDistance > 200 &&
//         !_popupShown &&
//         (closestPolylineIndex > 0 || closestPointIndex > 0)) {
//       _popupShown = true;
//     }

//     if (closestPolylineIndex == -1 || closestPointIndex == -1) return null;

//     if (closestPolylineIndex > 0) {
//       currentRoute!.polylines.removeRange(0, closestPolylineIndex);
//       closestPolylineIndex = 0;
//     }
//     Polyline closestPolyline = currentRoute!.polylines[closestPolylineIndex];

//     closestPolyline.points.removeRange(0, closestPointIndex);
//     currentRoute!.polylines.removeWhere((polyline) => polyline.points.isEmpty);

//     if (currentRoute == null || currentRoute!.polylines.isEmpty) return null;
//     return currentRoute!.polylines.first.points.first;
//   }

//   void navigationHeaderProcess(LatLng currentPosition) {
//     if (nextSteps.isEmpty) return;

//     int closestIndex = 0;
//     double closestDistance =
//         _calculateDistance(currentPosition, nextSteps.first.point);

//     for (int i = 1; i < nextSteps.length; i++) {
//       double distance =
//           _calculateDistance(currentPosition, nextSteps[i].point);
//       if (distance < closestDistance) {
//         closestDistance = distance;
//         closestIndex = i;
//       }
//     }

//     if (closestIndex > 0) {
//       nextSteps.removeRange(0, closestIndex);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void loadOriginalRoute() {
//     final originalPolyline = toPolylineLayer(
//       _buildItineraries(
//         itinerary: widget.itinerary,
//         overrideColor: Colors.grey,
//       ),
//     );
//     final currentPolyline = toPolylineLayer(
//       _buildItineraries(
//         itinerary: widget.itinerary,
//         overrideColor: null,
//       ),
//     );
//     final route = widget.itinerary.compressLegs
//         .map((leg) => leg.accumulatedPoints.isNotEmpty
//             ? leg.accumulatedPoints
//             : decodePolyline(leg.points))
//         .expand((points) => points)
//         .toList();

//     setState(() {
//       originalRoute = originalPolyline;
//       currentRoute = currentPolyline;
//       // originalTrackRoute = route;
//       // trackRoute = route;
//     });
//   }

//   double getBearingAngle(LatLng start, LatLng end) {
//     double lat1 = start.latitude * math.pi / 180;
//     double lat2 = end.latitude * math.pi / 180;
//     double lon1 = start.longitude * math.pi / 180;
//     double lon2 = end.longitude * math.pi / 180;

//     double dLon = lon2 - lon1;

//     double y = math.sin(dLon) * math.cos(lat2);
//     double x = math.cos(lat1) * math.sin(lat2) -
//         math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

//     double bearing = math.atan2(y, x);
//     return bearing;
//   }

//   List<PolylineWithMarkers> _buildItineraries({
//     required PlanItinerary itinerary,
//     required Color? overrideColor,
//   }) {
//     // final List<Marker> markers = [];
//     final List<NextStepContainer> nextStepsBuilder = [];
//     final List<PolylineWithMarkers> polylinesWithMarkers = [];
//     final List<PlanItineraryLeg> compressedLegs = itinerary.compressLegs;
//     for (int i = 0; i < compressedLegs.length; i++) {
//       final PlanItineraryLeg leg = compressedLegs[i];
//       // Polyline
//       final List<LatLng> points = leg.accumulatedPoints.isNotEmpty
//           ? leg.accumulatedPoints
//           : decodePolyline(leg.points);
//       final Color color = leg.transportMode == TransportMode.bicycle &&
//               leg.fromPlace?.bikeRentalStation != null
//           ? getBikeRentalNetwork(leg.fromPlace!.bikeRentalStation!.networks?[0])
//               .color
//           : leg.primaryColor;

//       final Polyline polyline = Polyline(
//         points: points.toList(),
//         color: overrideColor ?? color,
//         strokeWidth: 6.0,
//         pattern: leg.transportMode == TransportMode.walk
//             ? const StrokePattern.dotted()
//             : const StrokePattern.solid(),
//       );
//       if (leg.steps != null && leg.steps!.isNotEmpty) {
//         bool isFirst = true;
//         for (final step in leg.steps!) {
//           LatLng point = LatLng(step.lat!, step.lon!);
//           nextStepsBuilder.add(
//             NextStepContainer(
//               point: point,
//               widget: StepNavigationDetails(
//                 step: step,
//                 isFirst: isFirst,
//                 showNavigationIcon: false,
//               ),
//             ),
//           );
//           isFirst = false;
//           // markers.add(
//           //   buildTransferMarker(
//           //     point,
//           //   ),
//           // );
//         }
//       } else {
//         if (leg.fromPlace != null) {
//           PlaceEntity fromPlace = leg.fromPlace!;
//           nextStepsBuilder.add(
//             NextStepContainer(
//               point: LatLng(fromPlace.lat, fromPlace.lon),
//               widget: TransitLeg(
//                 itinerary: itinerary,
//                 leg: leg,
//                 moveInMap: (_) {},
//                 detailsColor: Colors.white,
//               ),
//             ),
//           );
//         }
//         if (leg.toPlace != null) {
//           PlaceEntity toPlace = leg.toPlace!;
//           nextStepsBuilder.add(
//             NextStepContainer(
//               point: LatLng(toPlace.lat, toPlace.lon),
//               widget: TransitLeg(
//                 itinerary: itinerary,
//                 leg: leg,
//                 moveInMap: (_) {},
//                 detailsColor: Colors.white,
//               ),
//             ),
//           );
//         }
//       }

//       polylinesWithMarkers.add(PolylineWithMarkers(polyline, []));
//     }
//     setState(() {
//       nextSteps = nextStepsBuilder;
//     });
//     return polylinesWithMarkers;
//   }

//   MarkerLayer toMarkerLayer(List<PolylineWithMarkers> polylinesWithMarker) {
//     final selectedMarkers = <Marker>[];
//     for (final polylineWithMarker in polylinesWithMarker) {
//       selectedMarkers.addAll(polylineWithMarker.markers);
//     }
//     return MarkerLayer(markers: selectedMarkers);
//   }

//   PolylineLayer<Object> toPolylineLayer(
//       List<PolylineWithMarkers> polylinesWithMarker) {
//     final selectedPolylines = <Polyline>[];
//     for (final polylineWithMarker in polylinesWithMarker) {
//       selectedPolylines.add(polylineWithMarker.polyline);
//     }
//     return PolylineLayer(polylines: selectedPolylines);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mapRouteState = context.read<MapRouteCubit>().state;
//     final mapModesCubit = context.watch<MapModesCubit>();
//     final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
//     return BaseTrufiPage(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: Stack(
//           children: [
//             BlocListener<MapModesCubit, MapModesState>(
//               listener: (buildContext, state) {
//                 trufiMapController.onReady.then((_) {
//                   repaintMap(mapRouteState, mapModesCubit, state);
//                 });
//               },
//               child: CustomScrollableContainer(
//                 openedPosition: 200,
//                 body: StadtnaviMap(
//                   enableCurrentLocation: false,
//                   trufiMapController: trufiMapController,
//                   layerOptionsBuilder: (context) => [
//                     // if (routeMarker != null) routeMarker!,
//                     if (originalRoute != null) originalRoute!,
//                     if (currentRoute != null) currentRoute!,
//                     MarkerLayer(markers: [
//                       if (mapRouteState.fromPlace != null)
//                         mapConfiguratiom.markersConfiguration
//                             .buildFromMarker(mapRouteState.fromPlace!.latLng),
//                       if (mapRouteState.toPlace != null)
//                         mapConfiguratiom.markersConfiguration
//                             .buildToMarker(mapRouteState.toPlace!.latLng),
//                       if (lastPosition != null)
//                         Marker(
//                           width: 50.0,
//                           height: 50.0,
//                           point: lastPosition!,
//                           alignment: Alignment.center,
//                           child: Transform.rotate(
//                             angle: ((currentHeading ?? 0) * math.pi / 180),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(100),
//                                 color: Colors.white.withOpacity(.8),
//                               ),
//                               padding: const EdgeInsets.all(5),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.navigation,
//                                   color: Color(0xFF9BBF28),
//                                   size: 40,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ]),
//                   ],
//                 ),
//                 // panel: ListView(
//                 //   children: nextSteps.map((value) => value.widget).toList(),
//                 // ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (_popupShown)
//                     Container(
//                       margin: EdgeInsets.all(5),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             child: Icon(
//                               Icons.warning,
//                               color: Colors.red,
//                             ),
//                             margin: EdgeInsets.only(right: 10),
//                           ),
//                           Expanded(
//                             child: Text(widget.warning),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               _popupShown = false;
//                             },
//                             icon: Icon(Icons.close),
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (nextSteps.isNotEmpty)
//                     DefaultTextStyle(
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                       child: Container(
//                         margin: EdgeInsets.all(5),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Color(0xFF9BBF28),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: nextSteps.first.widget,
//                       ),
//                     ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void repaintMap(MapRouteState mapRouteState, MapModesCubit mapModesCubit,
//       MapModesState mapModesState) {
//     if (mapModesState.plan != null && mapModesState.selectedItinerary != null) {
//       trufiMapController.selectedItinerary(
//           plan: mapModesState.plan!,
//           from: mapRouteState.fromPlace!,
//           to: mapRouteState.toPlace!,
//           selectedItinerary: mapModesState.selectedItinerary!,
//           tickerProvider: this,
//           showAllItineraries: mapModesState.showAllItineraries,
//           onTap: (p1) {
//             mapModesCubit.selectItinerary(p1);
//           });
//     } else {
//       trufiMapController.cleanMap();
//     }
//   }
// }
