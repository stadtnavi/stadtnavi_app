import 'package:stadtnavi_core/base/custom_layers/live_bus/live_bus_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bicycle_network/parkings_zones_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parkings_zones_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

import 'pbf_layer/bike_parks/bike_parks_layer.dart';
import 'pbf_layer/cifs/cifs_layer.dart';
import 'pbf_layer/parking/parkings_layer.dart';
import 'pbf_layer/stops/stops_enum.dart';
import 'pbf_layer/weather/weather_layer.dart';

class StaticTileLayers {
  static Map<StopsLayerIds, StopsLayer> stopsLayers = {
    StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus, '3'),
    StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail, '3'),
    StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool, '3'),
    StopsLayerIds.subway: StopsLayer(StopsLayerIds.subway, '3'),
  };
  static ParkingLayer parkingLayer = ParkingLayer("Parking", '3');
  static ParkingZonesLayer parkingZonesLayer =
      ParkingZonesLayer("Parking Zones", '1');
  static CityBikesLayer citybikeLayer = CityBikesLayer("Sharing", '3');
  static BikeParkLayer bikeParkLayer = BikeParkLayer("Bike Parking Space", '3');
  static BicycleNetworkLayer bicycleNetworkLayer =
      BicycleNetworkLayer("Bicycle Network Space", '2');
  static CifsLayer cifsLayer = CifsLayer("Roadworks", '1');
  static LiveBusLayer liveBusLayer = LiveBusLayer("LiveBusBeta", '3');
  static WeatherLayer weatherLayer = WeatherLayer("Road Weather", '3');
  static ChargingLayer chargingLayer = ChargingLayer("Charging", '3');
}

// final List<CustomLayerContainer> customLayers = [
//   CustomLayerContainer(
//     name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
//         ? "Public Transit"
//         : "Öffentlicher Nahverkehr",
//     icon: (context) => const Icon(
//       Icons.train,
//       color: Colors.grey,
//     ),
//     layers: [
//       stopsLayers[StopsLayerIds.bus]!,
//       stopsLayers[StopsLayerIds.subway]!,
//       stopsLayers[StopsLayerIds.rail]!,
//       // TODO is only herrenberg
//       // liveBusLayer,
//     ],
//   ),
//   CustomLayerContainer(
//     name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
//         ? "Bicycle"
//         : "Fahrrad",
//     icon: (context) => const Icon(
//       Icons.directions_bike,
//       color: Colors.grey,
//     ),
//     layers: [
//       bikeParkLayer,
//       Layer(
//         LayerIds.bicycleInfrastructure,
//         '3',
//         url: 'https://node21-iot.apps.okd.swlb.de/radservice.json',
//         isOnline: true,
//       ),
//       bicycleNetworkLayer,
//     ],
//   ),
//   CustomLayerContainer(
//     name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
//         ? "Sharing Offers"
//         : "Sharing Angebote",
//     icon: (context) => const Icon(
//       Icons.bike_scooter,
//       color: Colors.grey,
//     ),
//     layers: [
//       citybikeLayer,
//       // TODO is only herrenberg
//       // stopsLayers[StopsLayerIds.carpool]!,
//     ],
//   ),
//   CustomLayerContainer(
//     name: (context) =>
//         TrufiBaseLocalization.of(context).localeName == "en" ? "Car" : "Auto",
//     icon: (context) => SvgPicture.string(
//       carDefaultIcon,
//       color: Colors.grey,
//     ),
//     layers: [
//       parkingLayer,
//       chargingLayer,
//       parkingZonesLayer,
//     ],
//   ),
//   CustomLayerContainer(
//     name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
//         ? "Others"
//         : "Andere",
//     icon: (context) => const Icon(
//       Icons.map,
//       color: Colors.grey,
//     ),
//     layers: [
//       Layer(
//         LayerIds.publicToilets,
//         '3',
//         url: 'https://node21-iot.apps.okd.swlb.de/nettetoilette.json',
//         isOnline: true,
//       ),
//       cifsLayer,
//       weatherLayer,
//       Layer(
//         LayerIds.lorawanGateways,
//         '3',
//         url: 'https://node21-iot.apps.okd.swlb.de/lora.json',
//         isOnline: true,
//       ),
//     ],
//   ),
// ];
