import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';

typedef LayerOptionsBuilder = List<LayerOptions> Function(BuildContext context);

class StadtnaviMapController {
  static const int animationDuration = 500;

  final _mapController = MapController();
  final _mapReadyController = BehaviorSubject<void>();

  TrufiMapState _state;
  // TrufiMapAnimations _animations;

  void setState(TrufiMapState state) {
    _state = state;
    _mapController.onReady.then((_) {
      // final cfg = TrufiConfiguration();
      // final zoom = cfg.map.defaultZoom;
      // final mapCenter = cfg.map.center;

      // _mapController.move(mapCenter, zoom);
      _inMapReady.add(null);
    });
    // _animations = TrufiMapAnimations(_mapController);
  }

  void dispose() {
    _mapReadyController.close();
  }

  Future<void> moveToYourLocation({
    @required BuildContext context,
    TickerProvider tickerProvider,
  }) async {
    // final cfg = TrufiConfiguration();
    // final zoom = cfg.map.chooseLocationZoom;
    // final locationProviderBloc = LocationProviderBloc.of(context);
    // final location = await locationProviderBloc.currentLocation;
    // if (location != null) {
    //   move(
    //     center: location,
    //     zoom: zoom,
    //     tickerProvider: tickerProvider,
    //   );
    //   locationProviderBloc.start();
    //   return;
    // }
    // showDialog(
    //   context: context,
    //   builder: (context) => buildAlertLocationServicesDenied(context),
    // );
  }

  void move({
    @required LatLng center,
    @required double zoom,
    TickerProvider tickerProvider,
  }) {
    if (tickerProvider == null) {
      _mapController.move(center, zoom);
    } else {
      // _animations.move(
      //   center: center,
      //   zoom: zoom,
      //   tickerProvider: tickerProvider,
      //   milliseconds: animationDuration,
      // );
    }
  }

  void fitBounds({
    @required LatLngBounds bounds,
    TickerProvider tickerProvider,
  }) {
    if (tickerProvider == null) {
      _mapController.fitBounds(bounds);
    } else {
      // _animations.fitBounds(
      //   bounds: bounds,
      //   tickerProvider: tickerProvider,
      //   milliseconds: animationDuration,
      // );
    }
  }

  Sink<void> get _inMapReady => _mapReadyController.sink;

  Stream<void> get outMapReady => _mapReadyController.stream;

  MapController get mapController => _mapController;

  LayerOptions get yourLocationLayer => _state.yourLocationLayer;
}

class StatdnaviMap extends StatefulWidget {
  const StatdnaviMap({
    Key key,
    @required this.controller,
    @required this.mapOptions,
    @required this.layerOptionsBuilder,
  }) : super(key: key);

  final StadtnaviMapController controller;
  final MapOptions mapOptions;
  final LayerOptionsBuilder layerOptionsBuilder;

  @override
  TrufiMapState createState() => TrufiMapState();
}

class TrufiMapState extends State<StatdnaviMap> {
  LayerOptions yourLocationLayer;

  @override
  void initState() {
    super.initState();
    widget.controller.setState(this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final locationProviderBloc = LocationProviderBloc.of(context);
    // final cfg = TrufiConfiguration();
    return Stack(children: [
      Positioned.fill(
        child: FlutterMap(
          mapController: widget.controller.mapController,
          options: widget.mapOptions,
          layers: widget.layerOptionsBuilder(context),
        ),
      ),
      Positioned(
        left: 0.0,
        bottom: 0.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: SafeArea(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: theme.textTheme.caption.copyWith(
                      color: Colors.black,
                    ),
                    text: "© MapTiler ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // launch(cfg.url.mapTilerCopyright);
                      },
                  ),
                  TextSpan(
                    style: theme.textTheme.caption.copyWith(
                      color: Colors.black,
                    ),
                    text: "© OpenStreetMap contributors",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // launch(cfg.url.openStreetMapCopyright);
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
