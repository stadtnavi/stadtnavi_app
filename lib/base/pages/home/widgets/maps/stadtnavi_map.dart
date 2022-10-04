import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/map_type_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/your_location_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/custom_polyline_layer.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';

typedef LayerOptionsBuilder = List<Widget> Function(BuildContext context);

class StadtnaviMap extends StatefulWidget {
  final TrufiMapController trufiMapController;
  final LayerOptionsBuilder layerOptionsBuilder;
  final Widget? floatingActionButtons;
  final TapCallback? onTap;
  final LongPressCallback? onLongPress;
  final PositionCallback? onPositionChanged;
  final bool showMapTypeButton;
  final String? showLayerById;
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
  }) : super(key: key);

  @override
  State<StadtnaviMap> createState() => _StadtnaviMapState();
}

class _StadtnaviMapState extends State<StadtnaviMap> {
  int mapZoom = 0;
  @override
  Widget build(BuildContext context) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final customLayersCubit = context.watch<CustomLayersCubit>();
    final currentMapType = context.watch<MapTileProviderCubit>().state;
    return Stack(
      children: [
        StreamBuilder<LatLng?>(
            initialData: null,
            stream: GPSLocationProvider().streamLocation,
            builder: (context, snapshot) {
              final currentLocation = snapshot.data;
              return FlutterMap(
                mapController: widget.trufiMapController.mapController,
                options: MapOptions(
                  interactiveFlags: InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                  minZoom: mapConfiguratiom.onlineMinZoom,
                  maxZoom: mapConfiguratiom.onlineMaxZoom,
                  zoom: mapConfiguratiom.onlineZoom,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  center: mapConfiguratiom.center,
                  onMapReady: () {
                    if (!widget.trufiMapController.readyCompleter.isCompleted) {
                      widget.trufiMapController.readyCompleter.complete();
                    }
                  },
                  onPositionChanged: (
                    MapPosition position,
                    bool hasGesture,
                  ) {
                    if (widget.onPositionChanged != null) {
                      Future.delayed(Duration.zero, () {
                        widget.onPositionChanged!(position, hasGesture);
                      });
                    }
                    // fix render issue
                    Future.delayed(Duration.zero, () {
                      final int zoom = position.zoom?.round() ?? 0;
                      if (mapZoom != zoom) {
                        setState(() => mapZoom = zoom);
                      }
                    });
                  },
                ),
                children: [
                  ...currentMapType.currentMapTileProvider
                      .buildTileLayerOptions(),
                  mapConfiguratiom.markersConfiguration
                      .buildYourLocationMarkerLayerOptions(currentLocation),
                  ...customLayersCubit.activeCustomLayers(
                    mapZoom,
                    showLayerById: widget.showLayerById,
                  ),
                  ...widget.layerOptionsBuilder(context),
                ],
              );
            }),
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
      ],
    );
  }
}
