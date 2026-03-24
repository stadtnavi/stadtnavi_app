import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch;

import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/crop_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/markers/marker_configuration.dart'
    as stadtnavi_markers;
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';

class TrufiMapMode extends StatefulWidget {
  final TrufiMapController trufiMapController;
  const TrufiMapMode({
    Key? key,
    required this.trufiMapController,
  }) : super(key: key);

  @override
  State<TrufiMapMode> createState() => _TrufiMapModeState();
}

class _TrufiMapModeState extends State<TrufiMapMode>
    with TickerProviderStateMixin {
  final _cropButtonKey = GlobalKey<CropButtonState>();
  TrufiMarker? tempMarker;

  @override
  Widget build(BuildContext context) {
    final mapRouteState = context.read<MapRouteCubit>().state;
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final markers = mapConfiguratiom.markersConfiguration
        as stadtnavi_markers.MarkerConfiguration;
    return Stack(
      children: [
        BlocBuilder<TrufiMapController, TrufiMapState>(
          bloc: widget.trufiMapController,
          builder: (context1, state) {
            return StadtnaviMap(
              trufiMapController: widget.trufiMapController,
              layerOptionsBuilder: (context) => [
                if (state.unselectedLines.isNotEmpty)
                  TrufiLayer(
                    id: 'unselected_lines',
                    lines: state.unselectedLines,
                    layerLevel: 10,
                  ),
                if (state.unselectedMarkers.isNotEmpty)
                  TrufiLayer(
                    id: 'unselected_markers',
                    markers: state.unselectedMarkers,
                    layerLevel: 11,
                  ),
                if (state.selectedLines.isNotEmpty)
                  TrufiLayer(
                    id: 'selected_lines',
                    lines: state.selectedLines,
                    layerLevel: 12,
                  ),
                if (state.selectedMarkers.isNotEmpty)
                  TrufiLayer(
                    id: 'selected_markers',
                    markers: state.selectedMarkers,
                    layerLevel: 13,
                  ),
                TrufiLayer(
                  id: 'from_to_markers',
                  markers: [
                    if (mapRouteState.fromPlace != null)
                      markers
                          .buildFromTrufiMarker(mapRouteState.fromPlace!.latLng),
                    if (mapRouteState.toPlace != null)
                      markers
                          .buildToTrufiMarker(mapRouteState.toPlace!.latLng),
                    if (tempMarker != null) tempMarker!,
                  ],
                  layerLevel: 14,
                ),
              ],
              onTap: (point) {
                if (state.unselectedLines.isNotEmpty) {
                  _handleOnMapTap(context, point);
                } else {
                  onMapPress(context, point);
                }
              },
              onLongPress: (point) => onMapPress(context, point),
              onPositionChanged: _handleOnMapPositionChanged,
              floatingActionButtons: Column(
                children: [
                  CropButton(
                      key: _cropButtonKey, onPressed: _handleOnCropPressed),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleOnCropPressed() {
    widget.trufiMapController.moveCurrentBounds(tickerProvider: this);
  }

  void _handleOnMapPositionChanged(TrufiCameraPosition camera) {
    if (widget.trufiMapController.selectedBounds != null &&
        camera.visibleRegion != null) {
      final visible = camera.visibleRegion!;
      final selected = widget.trufiMapController.selectedBounds!;
      final containsBounds =
          visible.southWest.latitude <= selected.southWest.latitude &&
          visible.southWest.longitude <= selected.southWest.longitude &&
          visible.northEast.latitude >= selected.northEast.latitude &&
          visible.northEast.longitude >= selected.northEast.longitude;
      _cropButtonKey.currentState?.setVisible(
        visible: !containsBounds,
      );
    }
  }

  void _handleOnMapTap(BuildContext context, LatLng point) {
    final PlanItinerary? tappedItinerary = itineraryForPoint(
        widget.trufiMapController.itineraries,
        widget.trufiMapController.state.unselectedLines,
        point);
    if (tappedItinerary != null) {
      context.read<MapModesCubit>().selectItinerary(tappedItinerary);
    }
  }

  void onMapPress(BuildContext context, LatLng location) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final markers = mapConfiguratiom.markersConfiguration
        as stadtnavi_markers.MarkerConfiguration;
    setState(() {
      tempMarker = markers.buildToTrufiMarker(location);
    });
    widget.trufiMapController.move(
      center: location,
      zoom: mapConfiguratiom.chooseLocationZoom,
    );
  }
}
