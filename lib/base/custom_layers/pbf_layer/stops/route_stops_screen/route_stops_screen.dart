import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/route_stops_screen/bottom_stops_detail.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/pattern.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/stoptime.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/buttons/crop_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/utils/trufi_map_utils.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';

class RoutesStopScreen extends StatefulWidget {
  final Stoptime stopTime;
  const RoutesStopScreen({
    Key? key,
    required this.stopTime,
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

  final LatLngBounds? _selectedBounds = null;
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(getTransportMode(
                    mode: widget.stopTime.trip?.route?.mode?.name ?? '')
                .getTranslate(localization)),
            Text(' - ${widget.stopTime.trip?.route?.shortName ?? ''}'),
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
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            color: patternOtp?.route?.color != null
                                ? Color(int.tryParse(
                                    "0xFF${patternOtp!.route!.color}")!)
                                : patternOtp?.route?.mode?.color ?? Colors.grey,
                            strokeWidth: 6.0,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          ...stopsLocations.map((e) => buildTransferMarker(e))
                        ],
                      ),
                      MarkerLayer(markers: [
                        if (stopsLocations.isNotEmpty)
                          mapConfiguratiom.markersConfiguration
                              .buildFromMarker(stopsLocations[0]),
                        if (stopsLocations.length > 1)
                          mapConfiguratiom.markersConfiguration.buildToMarker(
                              stopsLocations[stopsLocations.length - 1]),
                      ]),
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
              panel: BottomStopsDetails(
                routeOtp: patternOtp!.route!,
                stops: patternOtp?.stops ?? [],
                moveTo: (point) {
                  _trufiMapController.move(
                    center: point,
                    zoom: 16,
                    tickerProvider: this,
                  );
                },
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
    await LayersRepository.fetchStopsRoute(
            widget.stopTime.trip?.pattern?.code ?? "")
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
                _selectedBounds?.extend(point);
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

  void _handleOnMapPositionChanged(
    MapCamera mapCamera,
    bool hasGesture,
  ) {
    if (_trufiMapController.selectedBounds != null) {
      _cropButtonKey.currentState?.setVisible(
        visible: !mapCamera.visibleBounds
            .containsBounds(_trufiMapController.selectedBounds!),
      );
    }
  }
}
