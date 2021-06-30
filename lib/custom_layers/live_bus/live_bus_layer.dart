import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';

import 'live_bus_enum.dart';
import 'live_bus_icons.dart';
import 'live_bus_marker_modal.dart';
import 'live_bus_model.dart';

class OnLiveBusStateChangeContainer {
  final String id;
  final void Function() dispose;
  void Function(LiveBusFeature) onUpdate;

  OnLiveBusStateChangeContainer(this.id, this.dispose);
  void update(LiveBusFeature liveBusFeature) {
    if (onUpdate != null) {
      onUpdate(liveBusFeature);
    }
  }
}

class LiveBusLayer extends CustomLayer {
  final Map<String, LiveBusFeature> _pbfMarkers = {};
  OnLiveBusStateChangeContainer onLiveBusStateChangeContainer;
  LiveBusLayer(String id) : super(id) {
    connect().catchError((error) {
      // should not make any effect on layer behavior
    });
  }
  Future<MqttServerClient> connect() async {
    final MqttServerClient client = MqttServerClient.withPort(
      'wss://api.dev.stadtnavi.eu/mqtt/',
      'flutter_client',
      443,
    );
    client.useWebSocket = true;
    client.setProtocolV311();
    client.autoReconnect = true;
    client.connectionMessage = MqttConnectMessage();
    await client.connect();

    client.subscribe("/json/vp/#", MqttQos.atLeastOnce);
    client.updates.listen((inputs) {
      for (final MqttReceivedMessage<MqttMessage> input in inputs) {
        final message = input.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );
        //  1=gtfsrt
        //  2=vp
        //  3=feed_Id
        //  4=agency_id
        //  5=agency_name
        //  6=mode
        //  7=route_id
        //  8=direction_id
        //  9=trip_headsign
        //  10=trip_id
        //  11=next_stop
        //  12=start_time
        //  13=vehicle_id
        //  14=geo_hash
        //  15=short_name
        //  16=color
        //  17=??
        //  18=name
        final header = message.variableHeader.topicName.split("/");
        if (header.length != 19) continue;
        final data = jsonDecode(payload);
        if (data["entity"] != null) {
          final entities = data["entity"];
          for (final entity in entities) {
            if (entity["vehicle"] != null) {
              final liveBusFeature = LiveBusFeature.fromGeoJsonLine(
                entity["vehicle"] as Map,
                tripId: header[10],
                name: header[18],
                to: header[9],
                time: header[12],
              );
              addMarker(liveBusFeature);
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
    if (onLiveBusStateChangeContainer != null &&
        onLiveBusStateChangeContainer.id == pointFeature.id) {
      onLiveBusStateChangeContainer.update(pointFeature);
    }
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
    switch (zoom) {
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
                          onLiveBusStateChangeContainer =
                              OnLiveBusStateChangeContainer(
                            element.id,
                            () {
                              onLiveBusStateChangeContainer = null;
                            },
                          );
                          final panelCubit = context.read<PanelCubit>();
                          panelCubit.setPanel(
                            CustomMarkerPanel(
                              panel: (context, onFetchPlan) =>
                                  LiveBusMarkerModal(
                                mainElement: element,
                                onLiveBusStateChangeContainer:
                                    onLiveBusStateChangeContainer,
                              ),
                              positon: element.position,
                              minSize: 50,
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            if (element.bearing != null)
                              Transform.rotate(
                                angle: element.bearing * pi / 180,
                                child: SvgPicture.string("""
                                <svg version="1.1" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                    <path fill="red" d="M50 0L32.4 14.08A40 40 0 0 0 10 50a40 40 0 0 0 40 40 40 40 0 0 0 40-40 40 40 0 0 0-22.398-35.918L50 0z" />
                                </svg>
                              """),
                              ),
                            Container(
                              margin: EdgeInsets.all(markerSize / 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(markerSize),
                              ),
                              child: Center(
                                child: Text(
                                  element.name,
                                  style: TextStyle(
                                    fontSize: markerSize / 2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ))
              .toList()
          : zoom != null && zoom > 11
              ? markersList
                  .map(
                    (element) => Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: liveBusStateColor(element.type) ??
                              Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
    );
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en" ? "Bus positions" : "Buspositionen";
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(menuLiveBusStop);
  }
}
