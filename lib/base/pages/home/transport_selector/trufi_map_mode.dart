import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/widgets/maps/buttons/crop_button.dart';

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
                if (widget.trufiMapController.state.unselectedPolylinesLayer !=
                    null) {
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

  void _handleOnMapTap(BuildContext context, LatLng point) {
    final PlanItinerary? tappedItinerary = itineraryForPoint(
        widget.trufiMapController.itineraries,
        widget.trufiMapController.state.unselectedPolylinesLayer?.polylines ??
            [],
        point);
    if (tappedItinerary != null) {
      context.read<MapModesCubit>().selectItinerary(tappedItinerary);
    }
  }

  void onMapPress(BuildContext context, LatLng location) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    widget.trufiMapController.move(
      center: location,
      zoom: mapConfiguratiom.chooseLocationZoom,
      tickerProvider: this,
    );
  }
}
