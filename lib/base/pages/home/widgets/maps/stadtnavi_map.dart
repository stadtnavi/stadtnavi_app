import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart' as tcm;

import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/map_type_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/your_location_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/map_legend.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';

typedef LayerOptionsBuilder = List<Widget> Function(BuildContext context);
typedef MoveInMap = void Function(LatLng latlng, {double? zoom});

class StadtnaviMap extends StatefulWidget {
  final TrufiMapController trufiMapController;
  final LayerOptionsBuilder layerOptionsBuilder;
  final Widget? floatingActionButtons;
  final void Function(LatLng latlng)? onTap;
  final void Function(LatLng latlng)? onLongPress;
  final VoidCallback? onPositionChanged;
  final bool showMapTypeButton;
  final String? showLayerById;
  final bool enableCurrentLocation;
  const StadtnaviMap({
    Key? key,
    required this.trufiMapController,
    required this.layerOptionsBuilder,
    this.floatingActionButtons,
    this.onTap,
    this.onLongPress,
    this.onPositionChanged,
    this.showMapTypeButton = true,
    this.showLayerById,
    this.enableCurrentLocation = true,
  }) : super(key: key);

  @override
  State<StadtnaviMap> createState() => _StadtnaviMapState();
}

class _StadtnaviMapState extends State<StadtnaviMap> {
  static const _engine = tcm.MapLibreEngine(
    styleString: 'https://tiles-eu.stadtnavi.eu/styles/streets/style.json',
    engineId: 'stadtnavi_streets',
    displayName: 'Streets',
  );

  @override
  void initState() {
    super.initState();
    final controller = widget.trufiMapController.mapLibreController;

    // Complete readyCompleter when the map reports first camera position
    void onCameraReady() {
      if (!widget.trufiMapController.readyCompleter.isCompleted) {
        widget.trufiMapController.readyCompleter.complete();
      }
      controller.cameraPositionNotifier.removeListener(onCameraReady);
    }

    controller.cameraPositionNotifier.addListener(onCameraReady);

    // Fire onPositionChanged when camera changes
    if (widget.onPositionChanged != null) {
      controller.cameraPositionNotifier.addListener(widget.onPositionChanged!);
    }
  }

  @override
  void dispose() {
    if (widget.onPositionChanged != null) {
      widget.trufiMapController.mapLibreController.cameraPositionNotifier
          .removeListener(widget.onPositionChanged!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return Stack(
      children: [
        _engine.buildMap(
          controller: widget.trufiMapController.mapLibreController,
          onMapClick: widget.onTap,
          onMapLongClick: widget.onLongPress,
        ),
        if (widget.showMapTypeButton)
          const Positioned(
            top: 16.0,
            right: 16.0,
            child: MapTypeButton(),
          ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (widget.floatingActionButtons != null)
                widget.floatingActionButtons!,
              const Padding(padding: EdgeInsets.all(4.0)),
              if (widget.enableCurrentLocation)
                YourLocationButton(
                  trufiMapController: widget.trufiMapController,
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: mapConfiguratiom.mapAttributionBuilder!(context),
        ),
        const Positioned(
          top: 59.5,
          right: 15.0,
          child: MapLegend(),
        ),
      ],
    );
  }
}
