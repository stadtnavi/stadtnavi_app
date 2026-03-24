import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch;

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/route_stops_screen/bottom_stops_detail.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/route_stops_screen/route_disruptions_alerts_screen.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/pattern.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/crop_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/markers/marker_configuration.dart'
    as stadtnavi_markers;

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';

class RoutesStopScreen extends StatefulWidget {
  final String routeShortName;
  final String routeGtfsId;
  final String patternCode;
  final TransportMode? transportMode;
  const RoutesStopScreen({
    Key? key,
    required this.routeShortName,
    required this.routeGtfsId,
    required this.patternCode,
    required this.transportMode,
  }) : super(key: key);

  @override
  _RoutesStopScreenState createState() => _RoutesStopScreenState();
}

class _RoutesStopScreenState extends State<RoutesStopScreen>
    with TickerProviderStateMixin {
  final TrufiMapController _trufiMapController = TrufiMapController();
  final _cropButtonKey = GlobalKey<CropButtonState>();
  PatternOtp? patternOtp;
  List<LatLng> stopsLocations = [];
  List<LatLng> routePoints = [];

  bool loading = true;
  String? fetchError;

  bool needsCameraUpdate = true;
  int indexNextDay = -1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _fetchStopData().then(
        (value) => _trufiMapController.onReady.then(
          (value) => setState(() {
            needsCameraUpdate = true;
            _trufiMapController.moveBounds(
              points: routePoints,
              tickerProvider: this,
            );
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final markers = mapConfiguratiom.markersConfiguration
        as stadtnavi_markers.MarkerConfiguration;
    final languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(getTransportMode(mode: widget.transportMode?.name ?? '')
                .getTranslate(localization)),
            Text(' - ${widget.routeShortName}'),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (loading)
            LinearProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          else if (patternOtp != null) ...[
            CustomScrollableContainer(
              openedPosition: 200,
              bottomPadding: 100,
              body: Stack(
                children: [
                  StadtnaviMap(
                    trufiMapController: _trufiMapController,
                    layerOptionsBuilder: (context) => [
                      TrufiLayer(
                        id: 'route_polyline',
                        lines: [
                          TrufiLine(
                            id: 'route_line',
                            position: routePoints,
                            color: patternOtp?.route?.color != null
                                ? Color(int.tryParse(
                                    "0xFF${patternOtp!.route!.color}")!)
                                : patternOtp?.route?.mode?.color ?? Colors.grey,
                            lineWidth: 6.0,
                          ),
                        ],
                        layerLevel: 10,
                      ),
                      TrufiLayer(
                        id: 'transfer_markers',
                        markers: [
                          ...stopsLocations
                              .map((e) => buildTransferTrufiMarker(e))
                        ],
                        layerLevel: 11,
                      ),
                      TrufiLayer(
                        id: 'from_to_markers',
                        markers: [
                          if (stopsLocations.isNotEmpty)
                            markers.buildFromTrufiMarker(stopsLocations[0]),
                          if (stopsLocations.length > 1)
                            markers.buildToTrufiMarker(
                                stopsLocations[stopsLocations.length - 1]),
                        ],
                        layerLevel: 12,
                      ),
                    ],
                    onPositionChanged: _handleOnMapPositionChanged,
                    floatingActionButtons: Column(
                      children: [
                        CropButton(
                            key: _cropButtonKey,
                            onPressed: _handleOnCropPressed),
                      ],
                    ),
                  ),
                ],
              ),
              panel: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: languageCode == 'en' ? "Stops" : "Jetzt"),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              cautionNoExclNoStrokeIcon(),
                              const SizedBox(width: 4),
                              Text(languageCode == 'en'
                                  ? "Disruptions"
                                  : "Störungen")
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          BottomStopsDetails(
                            routeOtp: patternOtp!.route!,
                            stops: patternOtp?.stops ?? [],
                            moveTo: (point) {
                              _trufiMapController.move(
                                center: point,
                                zoom: 16,
                              );
                            },
                          ),
                          RouteDisruptionAlertsScreen(
                            routeId: widget.routeGtfsId,
                            patternId: widget.patternCode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            Text(
              fetchError ?? "",
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Future<void> _fetchStopData() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository.fetchStopsRoute(widget.patternCode)
        .then((value) async {
      if (mounted) {
        setState(() {
          patternOtp = value;
          routePoints = value.geometry
                  ?.map((e) => LatLng(e.lat ?? 0, e.lon ?? 0))
                  .toList() ??
              [];
          stopsLocations = value.stops?.map((e) {
                final point = LatLng(e.lat ?? 0, e.lon ?? 0);
                return point;
              }).toList() ??
              [];
          loading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }

  void _handleOnCropPressed() {
    _trufiMapController.moveCurrentBounds(tickerProvider: this);
  }

  void _handleOnMapPositionChanged(TrufiCameraPosition camera) {
    if (_trufiMapController.selectedBounds != null &&
        camera.visibleRegion != null) {
      final visible = camera.visibleRegion!;
      final selected = _trufiMapController.selectedBounds!;
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
}
