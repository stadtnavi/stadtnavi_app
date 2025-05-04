import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/marker_tile_container.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/map_legend.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/map_type_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/your_location_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

typedef LayerOptionsBuilder = List<Widget> Function(BuildContext context);
typedef MoveInMap = void Function(LatLng latlng, {double? zoom});

class StadtnaviMap extends StatefulWidget {
  final TrufiMapController trufiMapController;
  final LayerOptionsBuilder layerOptionsBuilder;
  final Widget? floatingActionButtons;
  final TapCallback? onTap;
  final LongPressCallback? onLongPress;
  final PositionCallback? onPositionChanged;
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
  @override
  Widget build(BuildContext context) {
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final customLayersCubit = context.watch<CustomLayersCubit>();
    final currentMapType = context.watch<MapTileProviderCubit>().state;
    final localizationST = StadtnaviBaseLocalization.of(context);
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
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.drag |
                        InteractiveFlag.flingAnimation |
                        InteractiveFlag.pinchMove |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom,
                  ),
                  minZoom: mapConfiguratiom.onlineMinZoom,
                  maxZoom: mapConfiguratiom.onlineMaxZoom,
                  initialZoom: mapConfiguratiom.onlineZoom,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  initialCenter: mapConfiguratiom.center,
                  onMapReady: () async {
                    if (!widget.trufiMapController.readyCompleter.isCompleted) {
                      widget.trufiMapController.readyCompleter.complete();
                    }
                    final originalCenter =
                        widget.trufiMapController.mapController.camera.center;
                    final originalZoom =
                        widget.trufiMapController.mapController.camera.zoom;

                    widget.trufiMapController.mapController
                        .move(originalCenter, originalZoom + 0.0001);

                    await Future.delayed(Duration(milliseconds: 50));

                    widget.trufiMapController.mapController
                        .move(originalCenter, originalZoom);
                  },
                  onPositionChanged: (
                    MapCamera position,
                    bool hasGesture,
                  ) {
                    if (widget.onPositionChanged != null) {
                      Future.delayed(Duration.zero, () {
                        widget.onPositionChanged!(position, hasGesture);
                      });
                    }
                    // fix render issue
                    Future.delayed(Duration.zero, () {
                      final int zoom = position.zoom.round();
                      if (mapZoom != zoom) {
                        setState(() => mapZoom = zoom);
                      }
                    });
                  },
                ),
                children: [
                  ...currentMapType.currentMapTileProvider
                      .buildTileLayerOptions(context),
                  ...customLayersCubit.activeCustomLayers(
                    mapZoom,
                    [
                      ...widget.layerOptionsBuilder(context),
                    ],
                    layersUnderMid: MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        builder: (context, markers) {
                          return Container();
                          // return Container(
                          //   color: Colors.transparent,
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       // borderRadius: BorderRadius.circular(20),
                          //       color: Colors.transparent,
                          //       border: Border.all(
                          //         color: Colors.black,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         markers.length.toString(),
                          //         style: const TextStyle(color: Colors.black),
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                        alignment: Alignment.center,
                        maxClusterRadius: CustomLayer.getClusterSize(mapZoom),
                        size: CustomLayer.getMarkerClusterSize(mapZoom),
                        centerMarkerOnClick: false,
                        zoomToBoundsOnClick: false,
                        // disableClusteringAtZoom: 15,
                        spiderfyCluster: false,
                        showPolygon: false,
                        markers: customLayersCubit.markers(mapZoom),
                        onClusterTap: (onClusterTap) {
                          showTrufiDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (buildcontext) {
                              return AlertDialog(
                                titlePadding:
                                    EdgeInsets.fromLTRB(16, 16, 16, 0),
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 16, 16, 8),
                                insetPadding: EdgeInsets.zero,
                                iconPadding: EdgeInsets.zero,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localizationST.selectStop(
                                          onClusterTap.markers.length),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 30,
                                      ),
                                      splashRadius: 25,
                                    ),
                                  ],
                                ),
                                content: Container(
                                  width: 300,
                                  height: 350,
                                  child: ListView.builder(
                                    itemCount: onClusterTap.markers.length,
                                    itemBuilder: (context, index) {
                                      final key =
                                          onClusterTap.markers[index].key;
                                      return key != null
                                          ? Column(
                                              children: [
                                                ShowOverlappingData(
                                                  keyData: key,
                                                  markerNode: onClusterTap
                                                      .markers[index],
                                                ),
                                                const Divider(
                                                  height: 5,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            )
                                          : Container();
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    showLayerById: widget.showLayerById,
                  ),
                  if (widget.enableCurrentLocation)
                    mapConfiguratiom.markersConfiguration
                        .buildYourLocationMarkerLayerOptions(currentLocation),
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
        // if()
        const Positioned(
          top: 59.5,
          right: 15.0,
          child: MapLegend(),
        ),
      ],
    );
  }
}
