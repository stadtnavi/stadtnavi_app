import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster_2/src/node/marker_node.dart';
import 'package:stadtnavi_core/base/custom_layers/decoder_layer_data/bike_park_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/decoder_layer_data/charging_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/decoder_layer_data/city_bike_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/decoder_layer_data/parking_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/decoder_layer_data/stop_feature_tile.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';

class ShowOverlappingData extends StatelessWidget {
  final Key keyData;
  final MarkerNode markerNode;
  const ShowOverlappingData({
    super.key,
    required this.keyData,
    required this.markerNode,
  });

  @override
  Widget build(BuildContext context) {
    final keyValue = getData(keyData);

    return keyValue != null
        ? Container(
            height: 50,
            padding: const EdgeInsets.only(top: 5),
            child: InkWell(
              onTap: () {
                final data = (markerNode.child as Builder).build(context)
                    as GestureDetector;
                data.onTap!();
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Expanded(
                    child: keyValue is CityBikeFeature
                        ? CityBikeFeatureTile(
                            element: keyValue,
                          )
                        : keyValue is ChargingFeature
                            ? ChargingFeatureTile(
                                element: keyValue,
                              )
                            : keyValue is ParkingFeature
                                ? ParkingFeatureTile(
                                    element: keyValue,
                                  )
                                : keyValue is BikeParkFeature
                                    ? BikeParkFeatureTile(
                                        element: keyValue,
                                      )
                                    : keyValue is StopFeature
                                        ? StopFeatureTile(
                                            element: keyValue,
                                          )
                                        : Container(),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ))
        : Container();
  }

  dynamic getData(Key key) {
    final keyString = (key as ValueKey).value.toString();
    int idx = keyString.indexOf(":");
    List keyValue = [keyString.substring(0, idx), keyString.substring(idx + 1)];

    switch (keyValue[0]) {
      case "Sharing":
        return StaticTileLayers.citybikeLayer.data[keyValue[1]];
      case "Charging":
        return StaticTileLayers.chargingLayer.data[keyValue[1]];
      case "Parking":
        return StaticTileLayers.parkingLayer.data[keyValue[1]];
      case "Bike Parking Space":
        return StaticTileLayers.bikeParkLayer.data[keyValue[1]];
      case "Bus stops":
        return StaticTileLayers
            .stopsLayers[StopsLayerIds.bus]?.data[keyValue[1]];
      case "Train stations":
        return StaticTileLayers
            .stopsLayers[StopsLayerIds.rail]?.data[keyValue[1]];
      case "Carpool stops":
        return StaticTileLayers
            .stopsLayers[StopsLayerIds.carpool]?.data[keyValue[1]];
      case "Metro Station":
        return StaticTileLayers
            .stopsLayers[StopsLayerIds.subway]?.data[keyValue[1]];
      default:
        return null;
    }
  }
}

  //   StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus, '4'),
  //   StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail, '4'),
  //   StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool, '4'),
  //   StopsLayerIds.subway: StopsLayer(StopsLayerIds.subway, '4'),
  // };
  // static ParkingLayer parkingLayer = ParkingLayer("Parking", '4');
  // static ParkingZonesLayer parkingZonesLayer =
  //     ParkingZonesLayer("Parking Zones", '1');
  // static CityBikesLayer citybikeLayer = CityBikesLayer("Sharing", '5');
  // static BikeParkLayer bikeParkLayer = BikeParkLayer("Bike Parking Space", '4');
  // static BicycleNetworkLayer bicycleNetworkLayer =
  //     BicycleNetworkLayer("Bicycle Network Space", '2');
  // static CifsLayer cifsLayer = CifsLayer("Roadworks", '3');
  // static LiveBusLayer liveBusLayer = LiveBusLayer("LiveBusBeta", '3');
  // static WeatherLayer weatherLayer = WeatherLayer("Road Weather", '3');
  // static ChargingLayer chargingLayer = ChargingLayer("Charging", '4');