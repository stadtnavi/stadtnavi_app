import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/widgets/maps/buttons/crop_button.dart';

class TrufiMapTracking extends StatefulWidget {
  final TrufiMapController trufiMapController;
  // final List<PolylineWithMarkers> itinerary;
  const TrufiMapTracking({
    Key? key,
    required this.trufiMapController,
  }) : super(key: key);

  @override
  State<TrufiMapTracking> createState() => _TrufiMapTrackingState();
}

class _TrufiMapTrackingState extends State<TrufiMapTracking>
    with TickerProviderStateMixin {
  final _cropButtonKey = GlobalKey<CropButtonState>();
  Marker? tempMarker;

  @override
  Widget build(BuildContext context) {
    final mapRouteState = context.read<MapRouteCubit>().state;
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return Stack(
      children: [
        BlocBuilder<TrufiMapController, TrufiMapState>(
          bloc: widget.trufiMapController,
          builder: (context1, state) {
            return StadtnaviMap(
              trufiMapController: widget.trufiMapController,
              layerOptionsBuilder: (context) => [
                MarkerLayer(markers: [
                  if (mapRouteState.fromPlace != null)
                    mapConfiguratiom.markersConfiguration
                        .buildFromMarker(mapRouteState.fromPlace!.latLng),
                  if (mapRouteState.toPlace != null)
                    mapConfiguratiom.markersConfiguration
                        .buildToMarker(mapRouteState.toPlace!.latLng),
                  if (tempMarker != null) tempMarker!,
                ]),
              ],
            );
          },
        ),
      ],
    );
  }

  void _handleOnCropPressed() {
    widget.trufiMapController.moveCurrentBounds(tickerProvider: this);
  }

  void _handleOnMapPositionChanged(
    MapCamera mapCamera,
    bool hasGesture,
  ) {
    if (widget.trufiMapController.selectedBounds != null) {
      _cropButtonKey.currentState?.setVisible(
        visible: !mapCamera.visibleBounds
            .containsBounds(widget.trufiMapController.selectedBounds!),
      );
    }
  }

  void _handleOnMapTap(BuildContext context, LatLng point) {
    final PlanItinerary? tappedItinerary = itineraryForPoint(
        widget.trufiMapController.itineraries,
        widget.trufiMapController.state.unselectedPolylinesLayer!.polylines,
        point);
    if (tappedItinerary != null) {
      context.read<MapModesCubit>().selectItinerary(tappedItinerary);
    }
  }

  void onMapPress(BuildContext context, LatLng location) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    setState(() {
      tempMarker =
          mapConfiguratiom.markersConfiguration.buildToMarker(location);
    });
    widget.trufiMapController.move(
      center: location,
      zoom: mapConfiguratiom.chooseLocationZoom,
      tickerProvider: this,
    );
  }
}
