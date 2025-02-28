import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'dart:typed_data';
import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'live_bus_icons.dart';
import 'live_bus_marker_modal.dart';
import 'live_bus_model.dart';

class OnLiveBusStateChangeContainer {
  final String id;
  final void Function() dispose;
  void Function(LiveBusFeature)? onUpdate;

  OnLiveBusStateChangeContainer(this.id, this.dispose);
  void update(LiveBusFeature liveBusFeature) {
    if (onUpdate != null) {
      onUpdate!(liveBusFeature);
    }
  }
}

class LiveBusLayer extends CustomLayer {
  final MapLayerCategory mapCategory;
  final Map<String, LiveBusFeature> _pbfMarkers = {};
  OnLiveBusStateChangeContainer? onLiveBusStateChangeContainer;
  LiveBusLayer(this.mapCategory, int weight) : super(mapCategory.code, weight) {
    connect().catchError((error) {
      print(error);
    });
    filterOldValues().catchError((error) {
      print(error);
    });
  }
  Future<void> filterOldValues() async {
    final date = DateTime.now();
    _pbfMarkers.removeWhere(
      (key, value) => date.difference(value.created).inMinutes >= 3,
    );
    await Future.delayed(const Duration(seconds: 30));
    filterOldValues();
  }

  Future<MqttServerClient> connect() async {
    final MqttServerClient client = MqttServerClient(
        "wss://vehiclepositions.stadtnavi.eu/mqtt/", "flutter_client");
    client.port = 443;
    client.useWebSocket = true;
    client.keepAlivePeriod = 20;
    // client.setProtocolV311();
    client.autoReconnect = true;
    client.connectionMessage =
        MqttConnectMessage().withWillQos(MqttQos.atLeastOnce).startClean();
    await client.connect();

    client.subscribe("/gtfsrt/vp/hbg/#", MqttQos.atLeastOnce);
    client.updates?.listen((inputs) {
      for (final MqttReceivedMessage<MqttMessage> input in inputs) {
        final message = input.payload as MqttPublishMessage;
        final Uint8List payloadBytes = Uint8List.fromList(
          message.payload.message,
        );

        final FeedMessage feedMessage = FeedMessage.fromBuffer(payloadBytes);

        final header = (message.variableHeader?.topicName ?? '').split("/");
        if (header.length != 21) continue;

        for (final entity in feedMessage.entity) {
          if (entity.hasVehicle()) {
            final liveBusFeature = LiveBusFeature.fromVehiclePosition(
              entity.vehicle,
              lastUpdate: feedMessage.header.timestamp.toInt(),
              header: header,
            );
            addMarker(liveBusFeature);
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
        onLiveBusStateChangeContainer!.id == pointFeature.id) {
      onLiveBusStateChangeContainer!.update(pointFeature);
    }
  }

  @override
  Widget buildMarkerLayer(int? zoom) {
    double? markerSize;
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
    return MarkerLayer(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize! * 2,
                    width: markerSize * 2,
                    point: element.position,
                    alignment: Alignment.center,
                    child: Builder(builder: (context) {
                      return GestureDetector(
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
                                panel: (
                                  context,
                                  onFetchPlan, {
                                  isOnlyDestination,
                                }) =>
                                    LiveBusMarkerModal(
                                  mainElement: element,
                                  onLiveBusStateChangeContainer:
                                      onLiveBusStateChangeContainer,
                                ),
                                position: element.position,
                                minSize: 50,
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              if (element.bearing != null)
                                Transform.rotate(
                                  angle: element.bearing! * pi / 180,
                                  child: SvgPicture.string("""
                                <svg version="1.1" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                    <path fill="red" d="M50 0L32.4 14.08A40 40 0 0 0 10 50a40 40 0 0 0 40 40 40 40 0 0 0 40-40 40 40 0 0 0-22.398-35.918L50 0z" />
                                </svg>
                              """),
                                ),
                              Container(
                                margin: EdgeInsets.all(markerSize! / 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(markerSize),
                                      border: Border.all(color:hexToColor(element.color) )
                                ),
                                child: Center(
                                  child: Text(
                                    element.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: markerSize / 2,
                                      color: hexToColor(element.color),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }),
                  ))
              .toList()
          : zoom != null && zoom > 11
              ? markersList
                  .map(
                    (element) => Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: hexToColor(element.color),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
    );
  }
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }
  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return localeName == "en" ? mapCategory.en : mapCategory.de;
  }

  @override
  Widget icon(BuildContext context) {
    return SvgPicture.string(menuLiveBusStop);
  }

  @override
  bool isDefaultOn() => mapCategory.properties?.layerEnabledPerDefault ?? false;
}
