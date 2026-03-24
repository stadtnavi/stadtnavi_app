import 'dart:async';
import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch;
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/markers/marker_configuration.dart'
    as stadtnavi_markers;
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/load_location.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/crop_button.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class TrufiMapRoute extends StatefulWidget {
  final TrufiMapController trufiMapController;
  final AsyncExecutor asyncExecutor;
  final WidgetBuilder? extraFloatingMapButtons;
  final WidgetBuilder? overlapWidget;
  const TrufiMapRoute({
    Key? key,
    required this.trufiMapController,
    required this.asyncExecutor,
    this.extraFloatingMapButtons,
    this.overlapWidget,
  }) : super(key: key);

  @override
  State<TrufiMapRoute> createState() => _TrufiMapModeState();
}

class _TrufiMapModeState extends State<TrufiMapRoute>
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
                onMapPress(context, point);
              },
              onLongPress: (point) => onLongMapPress(context, point),
              onPositionChanged: _handleOnMapPositionChanged,
              floatingActionButtons: Column(
                children: [
                  CropButton(
                      key: _cropButtonKey, onPressed: _handleOnCropPressed),
                  if (widget.extraFloatingMapButtons != null)
                    widget.extraFloatingMapButtons!(context)
                ],
              ),
            );
          },
        ),
        if (widget.overlapWidget != null) widget.overlapWidget!(context)
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

  void onLongMapPress(BuildContext context, LatLng location) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final markers = mapConfiguratiom.markersConfiguration
        as stadtnavi_markers.MarkerConfiguration;
    final panelCubit = context.read<PanelCubit>();
    panelCubit.cleanPanel();
    setState(() {
      tempMarker = markers.buildToTrufiMarker(location);
    });
    widget.trufiMapController.move(
      center: location,
      zoom: mapConfiguratiom.chooseLocationZoom,
    );
    _showBottomMarkerModal(
      context: context,
      location: location,
    ).then((value) {
      setState(() {
        tempMarker = null;
      });
    });
  }

  void onMapPress(BuildContext context, LatLng location) {
    final panelCubit = context.read<PanelCubit>();
    panelCubit.cleanPanel();
  }

  Future<void> _showBottomMarkerModal({
    required BuildContext context,
    required LatLng location,
  }) async {
    return showTrufiModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (buildContext) => LoadLocation(
        location: location,
        onFetchPlan: () => _callFetchPlan(context),
      ),
    );
  }

  Future<void> _callFetchPlan(BuildContext context) async {
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapModesCubit = context.read<MapModesCubit>();
    final settingFetchState = context.read<SettingFetchCubit>().state;
    final mapRouteState = mapRouteCubit.state;
    if (mapRouteState.toPlace == null || mapRouteState.fromPlace == null) {
      return;
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    widget.asyncExecutor.run(
      context: context,
      onExecute: () async {
        await mapModesCubit.reset();
        mapModesCubit
            .fetchModesPlans(
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          advancedOptions: settingFetchState,
          localeName: languageCode,
        )
            .then(
          (voids) {
            if (!mapRouteCubit.state.isPlacesDefined) {
              mapModesCubit.reset();
            }
          },
        );
        await mapRouteCubit.fetchPlan(
          advancedOptions: settingFetchState,
          localeName: languageCode,
        );
      },
      onFinish: (_) {
        mapModesCubit
            .updateIsFetchingModes(mapModesCubit.state.modesTransport == null);
      },
    );
  }
}
