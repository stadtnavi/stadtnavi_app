import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, MapTypeButton;

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/map_legend.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/map_type_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/your_location_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart'
    as cubit;

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/cancellable_network.dart';

typedef LayerOptionsBuilder = List<TrufiLayer> Function(BuildContext context);
typedef MoveInMap = void Function(LatLng latlng, {double? zoom});

class StadtnaviMap extends StatefulWidget {
  final cubit.TrufiMapController trufiMapController;
  final LayerOptionsBuilder layerOptionsBuilder;
  final Widget? floatingActionButtons;
  final void Function(LatLng)? onTap;
  final void Function(LatLng)? onLongPress;
  final void Function(TrufiCameraPosition)? onPositionChanged;
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
  int mapZoom = 0;
  final _pbfFetcher = PbfTileFetcher();

  // Current map style
  String _currentStyle =
      'https://tiles-eu.stadtnavi.eu/styles/streets/style.json';

  @override
  Widget build(BuildContext context) {
    final mapConfig = context.read<MapConfigurationCubit>().state;
    final customLayersCubit = context.watch<CustomLayersCubit>();
    final panelCubit = context.watch<PanelCubit>();

    // Build custom layers as TrufiLayers
    final customTrufiLayers = customLayersCubit.buildTrufiLayers(mapZoom);

    // Build additional layers from the builder
    final additionalLayers = widget.layerOptionsBuilder(context);

    // Build selected marker layer
    final selectedMarkerLayer = panelCubit.state.selectedMarker != null
        ? [
            TrufiLayer(
              id: 'selected_marker',
              markers: [panelCubit.state.selectedMarker!],
              layerLevel: 999,
            ),
          ]
        : <TrufiLayer>[];

    // Build current location marker
    final locationLayers = <TrufiLayer>[];
    if (widget.enableCurrentLocation) {
      final currentLocation = GPSLocationProvider().myLocation;
      if (currentLocation != null) {
        locationLayers.add(
          TrufiLayer(
            id: 'my_location',
            markers: [
              TrufiMarker(
                id: 'my_location',
                position: currentLocation,
                size: const Size(20, 20),
                imageCacheKey: 'my_location_dot',
                allowOverlap: true,
                layerLevel: 998,
                widget: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
            layerLevel: 998,
          ),
        );
      }
    }

    final allLayers = [
      ...additionalLayers,
      ...customTrufiLayers,
      ...locationLayers,
      ...selectedMarkerLayer,
    ];

    return Stack(
      children: [
        TrufiMap(
          styleString: _currentStyle,
          initialCamera: TrufiCameraPosition(
            target: mapConfig.center,
            zoom: mapConfig.onlineZoom,
          ),
          controller: widget.trufiMapController.mapController,
          onCameraChanged: (cam) {
            final int zoom = cam.zoom.round();
            if (mapZoom != zoom) {
              setState(() => mapZoom = zoom);
            }
            widget.onPositionChanged?.call(cam);
            _pbfFetcher.onCameraChanged(cam, context);
            if (!widget.trufiMapController.readyCompleter.isCompleted) {
              widget.trufiMapController.readyCompleter.complete();
            }
          },
          onMapClick: (latLng) {
            // Try to pick a marker first
            final picked = widget.trufiMapController.mapController
                .pickNearestMarkerAt(latLng, hitboxPx: 30);
            if (picked != null && picked.buildPanel != null) {
              final panelCubit = context.read<PanelCubit>();
              panelCubit.setPanel(
                CustomMarkerPanel(
                  panel: (ctx, onFetchPlan, {isOnlyDestination}) =>
                      picked.buildPanel!(ctx),
                  position: picked.position,
                  minSize: 130,
                ),
                selectedMarker: picked,
              );
            } else {
              widget.onTap?.call(latLng);
            }
          },
          onMapLongClick: widget.onLongPress,
          layers: allLayers,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: Colors.white.withValues(alpha: 0.7),
            child: const Text(
              '© OpenStreetMap, OpenMapTiles',
              style: TextStyle(fontSize: 10),
            ),
          ),
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
