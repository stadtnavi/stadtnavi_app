import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rxdart/subjects.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'live_bus_enum.dart';
import 'live_bus_icons.dart';
import 'live_bus_marker_modal.dart';
import 'live_bus_model.dart';

class LiveBusLayer extends CustomLayer {
  final Map<String, LiveBusFeature> _pbfMarkers = {};

  final currentFocus = BehaviorSubject<LiveBusFeature>();
  LiveBusLayer(String id) : super(id) {
    connect().catchError((error) {
      log("$error");
    });
  }
  Future<MqttServerClient> connect() async {
    final MqttServerClient client = MqttServerClient.withPort(
      'wss://api.dev.stadtnavi.eu/mqtt/',
      'flutter_client',
      443,
    );
    client.useWebSocket = true;
    client.connectionMessage = MqttConnectMessage().startClean().withWillQos(
          MqttQos.atLeastOnce,
        );
    await client.connect();
    client.subscribe("/json/#", MqttQos.atLeastOnce);
    client.updates.listen((
      List<MqttReceivedMessage<MqttMessage>> inputs,
    ) {
      for (final MqttReceivedMessage<MqttMessage> input in inputs) {
        final message = input.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );
        final data = jsonDecode(payload);
        if (data["entity"] != null) {
          final entities = data["entity"];
          for (final entity in entities) {
            if (entity["vehicle"] != null) {
              final liveBusFeature = LiveBusFeature.fromGeoJsonLine(
                entity["vehicle"] as Map,
              );
              addMarker(liveBusFeature);
              log(jsonEncode(entity["vehicle"]));
            }
          }
        }
      }
    });
    return client;
  }

  void addMarker(LiveBusFeature pointFeature) {
    _pbfMarkers[pointFeature.id] = pointFeature;
    refresh();
    currentFocus.stream.last.then((value) {
      if (value != null && value.id == pointFeature.id) {
        currentFocus.sink.add(pointFeature);
      }
    });
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
    switch (zoom) {
      case 13:
        markerSize = 5;
        break;
      case 14:
        markerSize = 10;
        break;
      case 15:
        markerSize = 15;
        break;
      case 16:
        markerSize = 20;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    return MarkerLayerOptions(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize * 1.5,
                    width: markerSize * 1.5,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        final panelCubit = context.read<PanelCubit>();
                        panelCubit.setPanel(
                          CustomMarkerPanel(
                            panel: (context, onFetchPlan) => CifsMarkerModal(
                              mainElement: element,
                              currentFocus: currentFocus,
                            ),
                            positon: element.position,
                            minSize: 130,
                          ),
                        );
                      },
                      child: liveBusStateIcon(element.type),
                    ),
                  ))
              .toList()
          : [],
    );
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en" ? "Bus positions (Beta)" : "Buspositionen (Beta)";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(menuLiveBusStop);
  }
}
