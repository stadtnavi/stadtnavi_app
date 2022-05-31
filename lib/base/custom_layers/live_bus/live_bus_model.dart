import 'package:latlong2/latlong.dart';

import 'live_bus_enum.dart';

class LiveBusFeature {
  final String tripId;
  final String name;
  final String to;
  final String time;
  final String id;
  final LatLng position;
  final double? bearing;
  final LiveBusState? type;
  final DateTime created = DateTime.now();
  LiveBusFeature.fromGeoJsonLine(
    Map json, {
    required this.tripId,
    required this.name,
    required this.to,
    required this.time,
  })  : id = json["vehicle"]["id"].toString(),
        position = LatLng(
          json["position"]["latitude"] as double,
          json["position"]["longitude"] as double,
        ),
        bearing = double.parse("${json["position"]["bearing"]}"),
        type = liveBusStateToEnum(json["occupancyStatus"].toString());
}
