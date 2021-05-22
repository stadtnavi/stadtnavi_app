import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/route_stops_screen/bottom_stops_detail.dart';

import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/enums/mode.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/pattern.dart';

import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';
import 'package:trufi_core/widgets/map/buttons/crop_button.dart';
import 'package:trufi_core/widgets/map/buttons/your_location_button.dart';
import 'package:trufi_core/widgets/map/trufi_map.dart';
import 'package:trufi_core/widgets/map/trufi_map_controller.dart';
import 'package:trufi_core/widgets/map/utils/trufi_map_utils.dart';

class RoutesStopScreen extends StatefulWidget {
  final Stoptime stopTime;
  const RoutesStopScreen({
    Key key,
    @required this.stopTime,
  }) : super(key: key);

  @override
  _RoutesStopScreenState createState() => _RoutesStopScreenState();
}

class _RoutesStopScreenState extends State<RoutesStopScreen>
    with TickerProviderStateMixin {
  final TrufiMapController _trufiMapController = TrufiMapController();
  final _cropButtonKey = GlobalKey<CropButtonState>();
  PatternOtp patternOtp;
  List<LatLng> currentMap = [];

  bool loading = true;
  String fetchError;

  final LatLngBounds _selectedBounds = LatLngBounds();
  bool needsCameraUpdate = true;
  int indexNextDay = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _fetchStopData().then(
        (value) => _mapController.onReady.then((value) => setState(() {
              needsCameraUpdate = true;
            })),
      );
    });
  }

  @override
  void dispose() {
    _trufiMapController.dispose();
    super.dispose();
  }

  Future<void> _fetchStopData() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository()
        .fetchStopsRoute(widget.stopTime.trip.pattern.code)
        .then((value) async {
      if (mounted) {
        setState(() {
          patternOtp = value;
          currentMap = patternOtp.stops.map((e) {
            final point = LatLng(e.lat, e.lon);
            _selectedBounds.extend(point);
            return point;
          }).toList();
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

  @override
  Widget build(BuildContext context) {
    if (_mapController.ready) {
      if (needsCameraUpdate && _selectedBounds.isValid) {
        _trufiMapController.fitBounds(
          bounds: _selectedBounds,
          tickerProvider: this,
        );
        needsCameraUpdate = false;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.stopTime.trip.route.mode.name),
            Text(' - ${widget.stopTime.trip.route.shortName ?? ''}'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (loading)
            LinearProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          else if (patternOtp != null)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        TrufiMap(
                          key: const ValueKey("DetailStopMap"),
                          controller: _trufiMapController,
                          onPositionChanged: _handleOnMapPositionChanged,
                          layerOptionsBuilder: (context) => [
                            PolylineLayerOptions(
                              polylines: [
                                Polyline(
                                  points: currentMap,
                                  color: Color(
                                    int.tryParse(
                                            "0xFF${patternOtp.route?.color}") ??
                                        patternOtp.route.mode.color.value,
                                  ),
                                  strokeWidth: 6.0,
                                ),
                              ],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                ...currentMap.map((e) => buildTransferMarker(e))
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 16.0,
                          right: 16.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CropButton(
                                key: _cropButtonKey,
                                onPressed: () => setState(() {
                                  needsCameraUpdate = true;
                                }),
                              ),
                              const Padding(padding: EdgeInsets.all(4.0)),
                              YourLocationButton(
                                trufiMapController: _trufiMapController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomStopsDetails(
                    routeOtp: patternOtp.route,
                    stops: patternOtp.stops ?? [],
                    moveTo: (point) {
                      _trufiMapController.move(
                        center: point,
                        zoom: 16,
                        tickerProvider: this,
                      );
                    },
                  ),
                ],
              ),
            )
          else
            Text(
              fetchError,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  void _handleOnMapPositionChanged(
    MapPosition position,
    bool hasGesture,
  ) {
    if (selectedBounds != null && selectedBounds.isValid) {
      _cropButtonKey.currentState.setVisible(
        visible: !position.bounds.containsBounds(selectedBounds),
      );
    }
  }

  LatLngBounds get selectedBounds => _selectedBounds;

  MapController get _mapController => _trufiMapController.mapController;
}
