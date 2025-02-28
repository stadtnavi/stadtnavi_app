import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';

import 'live_bus_enum.dart';

class LiveBusFeature {
  final String feedId;
  final String tripId;
  final String routeId;
  final String name;
  final String mode;
  final String to;
  final int time;
  final int lastUpdate;
  final String id;
  final LatLng position;
  final double? bearing;
  final LiveBusState? type;
  final DateTime created = DateTime.now();
  final MapLayerCategory? category;
  final String color;
  final List<String> header;

  LiveBusFeature({
    required this.feedId,
    required this.tripId,
    required this.routeId,
    required this.name,
    required this.mode,
    required this.to,
    required this.time,
    required this.lastUpdate,
    required this.id,
    required this.position,
    this.bearing,
    this.type,
    required this.category,
    required this.color,
    required this.header,
  });

  factory LiveBusFeature.fromVehiclePosition(
    VehiclePosition vehicle, {
    required int lastUpdate,
    required List<String> header,
  }) {
    //  0  = (empty)
    //  1  = gtfsrt
    //  2  = vp (vehicle position)
    //  3  = feed_id (e.g., hbg)
    //  4  = (empty)
    //  5  = (empty)
    //  6  = mode (e.g., BUS)
    //  7  = route_id (e.g., de:vvs:31554_:)
    //  8  = direction_id (e.g., 0)
    //  9  = (empty)
    //  10 = trip_id (e.g., de:vvs:31554_::1-T0-5540001-j25)
    //  11 = (empty)
    //  12 = (empty)
    //  13 = vehicle_id (e.g., 570)
    //  14 = geo_hash (e.g., 48;9.)
    //  15 = speed or another data point? (e.g., 90)
    //  16 = unknown field (e.g., 43)
    //  17 = unknown field (e.g., 33)
    //  18 = short_name or identifier (e.g., 554)
    //  19 = color (e.g., FF0000)
    final mode = header[6];
    final category = HBLayerData.findCategoryRecursively(
      HBLayerData.categories,
      mode.toLowerCase(),
    );
    return LiveBusFeature(
      feedId: header[3],
      tripId: header[10],
      routeId: header[7],
      name: header[18],
      mode: header[6],
      to: header[9],
      time: vehicle.timestamp.toInt(),
      lastUpdate: lastUpdate,
      id: vehicle.vehicle.id,
      position: LatLng(vehicle.position.latitude, vehicle.position.longitude),
      bearing: vehicle.position.hasBearing() ? vehicle.position.bearing : null,
      type: liveBusStateToEnum(vehicle.occupancyStatus.name),
      category: category,
      color: header[19],
      header: header,
    );
  }
}
