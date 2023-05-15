import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:vector_tile/vector_tile.dart';

import 'charging_enum.dart';

class ChargingFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String id;
  final String? name;
  final int? capacity;
  final int? available;
  final int? tb;
  final int? capacityUnknown;

  final ChargingLayerIds? type;

  final LatLng position;
  ChargingFeature({
    required this.geoJsonPoint,
    required this.id,
    required this.name,
    required this.capacity,
    required this.available,
    required this.tb,
    required this.capacityUnknown,
    required this.type,
    required this.position,
  });

  static ChargingFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    int? id = properties['id']?.dartIntValue?.toInt();
    String? name = properties['name']?.dartStringValue;
    int? capacity = properties['c']?.dartIntValue?.toInt();
    int? available = properties['ca']?.dartIntValue?.toInt();

    int? tb = properties['tb']?.dartIntValue?.toInt();
    int? cs = properties['cs']?.dartIntValue?.toInt();

    int? capacityUnknown = properties['cu']?.dartIntValue?.toInt();

    int? capacityUnknownTotal =
        capacityUnknown != null ? capacityUnknown + (cs ?? 0) : cs;

    ChargingLayerIds? type;

    return ChargingFeature(
      geoJsonPoint: geoJsonPoint,
      id: id.toString(),
      name: name,
      capacity: capacity,
      available: available,
      tb: tb,
      capacityUnknown: capacityUnknownTotal,
      type: type,
      position: LatLng(
        geoJsonPoint!.geometry!.coordinates[1],
        geoJsonPoint.geometry!.coordinates[0],
      ),
    );
  }

  AvailabilityState? getAvailabilityStatus() {
    if (capacity == capacityUnknown) {
      return null;
    }
    if (available == null) return null;
    if (available! > 1) {
      return AvailabilityState.availability;
    }
    if (available == 1) {
      return AvailabilityState.partial;
    }
    return AvailabilityState.unavailability;
  }

}
