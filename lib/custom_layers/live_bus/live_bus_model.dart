import 'package:latlong/latlong.dart';

import 'live_bus_enum.dart';

class LiveBusFeature {
  final String id;
  final LatLng position;
  final LiveBusState type;
  LiveBusFeature.fromGeoJsonLine(Map json)
      : id = json["vehicle"]["id"].toString(),
        position = LatLng(
          json["position"]["latitude"] as double,
          json["position"]["longitude"] as double,
        ),
        type = liveBusStateToEnum(json["occupancyStatus"].toString());
        
}
