import 'dart:async';
import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/load_location.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/widgets/maps/buttons/crop_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<TrufiMapController, TrufiMapState>(
          bloc: widget.trufiMapController,
          builder: (context1, state) {
            return StadtnaviMap(
              trufiMapController: widget.trufiMapController,
              layerOptionsBuilder: (context) => [],
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

  void _handleOnMapPositionChanged() {
    if (widget.trufiMapController.selectedBounds != null) {
      final cam = widget
          .trufiMapController.mapLibreController.cameraPositionNotifier.value;
      if (cam.visibleRegion != null) {
        final vr = cam.visibleRegion!;
        final sb = widget.trufiMapController.selectedBounds!;
        final contains = vr.southWest.latitude <= sb.southWest.latitude &&
            vr.southWest.longitude <= sb.southWest.longitude &&
            vr.northEast.latitude >= sb.northEast.latitude &&
            vr.northEast.longitude >= sb.northEast.longitude;
        _cropButtonKey.currentState?.setVisible(visible: !contains);
      }
    }
  }

  void onLongMapPress(BuildContext context, LatLng location) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final panelCubit = context.read<PanelCubit>();
    panelCubit.cleanPanel();
    widget.trufiMapController.move(
      center: location,
      zoom: mapConfiguratiom.chooseLocationZoom,
      tickerProvider: this,
    );
    _showBottomMarkerModal(
      context: context,
      location: location,
    );
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
          localeName: languageCode,
          dateTime: settingFetchState.date,
          arriveBy: settingFetchState.arriveBy,
        )
            .then(
          (voids) {
            if (!mapRouteCubit.state.isPlacesDefined) {
              mapModesCubit.reset();
            }
          },
        );
        await mapRouteCubit.fetchPlan(
          localeName: languageCode,
          dateTime: settingFetchState.date,
          arriveBy: settingFetchState.arriveBy,
        );
      },
      onFinish: (_) {
        mapModesCubit
            .updateIsFetchingModes(mapModesCubit.state.modesTransport == null);
      },
    );
  }
}
