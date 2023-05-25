import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';
import 'package:vector_tile/vector_tile.dart';

import '../../models/enums.dart';
import 'parkings_enum.dart';

class ParkingFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String? id;
  final String? name;
  final String? note;
  final String? url;
  // OPERATIONAL, TEMPORARILY_CLOSED, CLOSED
  final String? state;
  final String? tags;
  final String? openingHours;
  final String? feeHours;
  final bool? bicyclePlaces;
  final bool? anyCarPlaces;
  final bool? carPlaces;
  final bool? wheelchairAccessibleCarPlaces;
  final bool? realTimeData;
  final String? capacity;
  final int? bicyclePlacesCapacity;
  final int? carPlacesCapacity;
  final int? availabilityCarPlacesCapacity;
  final int? totalDisabled;
  final int? freeDisabled;
  final ParkingsLayerIds? type;
  final SimpleOpeningHours? sOpeningHours;

  final LatLng position;
  ParkingFeature({
    required this.geoJsonPoint,
    required this.id,
    required this.name,
    required this.note,
    required this.url,
    required this.state,
    required this.tags,
    required this.openingHours,
    required this.feeHours,
    required this.bicyclePlaces,
    required this.anyCarPlaces,
    required this.carPlaces,
    required this.wheelchairAccessibleCarPlaces,
    required this.realTimeData,
    required this.capacity,
    required this.bicyclePlacesCapacity,
    required this.carPlacesCapacity,
    required this.availabilityCarPlacesCapacity,
    required this.totalDisabled,
    required this.freeDisabled,
    required this.type,
    required this.sOpeningHours,
    required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static ParkingFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    String? id = properties['id']?.dartStringValue;
    String? name = properties['name']?.dartStringValue;
    String? note = properties['note']?.dartStringValue;
    String? url = properties['detailsUrl']?.dartStringValue;
    String? state = properties['state']?.dartStringValue;
    String? tags = properties['tags']?.dartStringValue;
    String? openingHours = properties['openingHours']?.dartStringValue;
    String? feeHours = properties['feeHours']?.dartStringValue;
    bool? bicyclePlaces = properties['bicyclePlaces']?.dartBoolValue;
    bool? anyCarPlaces = properties['anyCarPlaces']?.dartBoolValue;
    bool? carPlaces = properties['carPlaces']?.dartBoolValue;
    bool? wheelchairAccessibleCarPlaces =
        properties['wheelchairAccessibleCarPlaces']?.dartBoolValue;
    bool? realTimeData = properties['realTimeData']?.dartBoolValue;
    String? capacity = properties['capacity']?.dartStringValue;
    int? bicyclePlacesCapacity =
        properties['capacity.bicyclePlaces']?.dartIntValue?.toInt();
    int? carPlacesCapacity =
        properties['capacity.carPlaces']?.dartIntValue?.toInt();
    int? availabilityCarPlacesCapacity =
        properties['availability.carPlaces']?.dartIntValue?.toInt();
    int? totalDisabled = properties['capacity.wheelchairAccessibleCarPlaces']
        ?.dartIntValue
        ?.toInt();
    int? freeDisabled = properties['availability.wheelchairAccessibleCarPlaces']
        ?.dartIntValue
        ?.toInt();
    if (anyCarPlaces == null || !anyCarPlaces) return null;
    // ignore: unnecessary_raw_strings
    final regex = RegExp(r"lot_type:([^,]+)");
    final regexResult = tags != null ? regex.firstMatch(tags) : null;
    final String? stringType = regexResult?.group(1);
    final ParkingsLayerIds type = stringType != null
        ? pbfParkingLayerIdsstringToEnum(stringType)
        : ParkingsLayerIds.parkRide;
    return ParkingFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      name: name,
      note: note,
      url: url,
      state: state,
      tags: tags,
      openingHours: openingHours,
      feeHours: feeHours,
      bicyclePlaces: bicyclePlaces,
      anyCarPlaces: anyCarPlaces,
      carPlaces: carPlaces,
      wheelchairAccessibleCarPlaces: wheelchairAccessibleCarPlaces,
      realTimeData: realTimeData,
      capacity: capacity,
      bicyclePlacesCapacity: bicyclePlacesCapacity,
      carPlacesCapacity: carPlacesCapacity,
      availabilityCarPlacesCapacity: availabilityCarPlacesCapacity,
      totalDisabled: totalDisabled,
      freeDisabled: freeDisabled,
      type: type,
      sOpeningHours:
          openingHours != null ? SimpleOpeningHours(openingHours) : null,
      position: LatLng(
        geoJsonPoint?.geometry?.coordinates[1] ?? 0,
        geoJsonPoint?.geometry?.coordinates[0] ?? 0,
      ),
    );
  }

  static AvailabilityState? Function({
    String? state,
    int? availabilityCarPlacesCapacity,
    int? carPlacesCapacity,
    int? freeDisabled,
    int? totalDisabled,
    SimpleOpeningHours? sOpeningHours,
  }) calculateAvailavility = _defaultCalculateAvailavility;

  static AvailabilityState? _defaultCalculateAvailavility({
    String? state,
    int? availabilityCarPlacesCapacity,
    int? carPlacesCapacity,
    int? freeDisabled,
    int? totalDisabled,
    SimpleOpeningHours? sOpeningHours,
  }) {
    if (state == 'closed' ||
        availabilityCarPlacesCapacity == 0 ||
        (freeDisabled == 0 && false) ||
        !(sOpeningHours?.isOpenNow() ?? true)) {
      return AvailabilityState.unavailability;
    } else {
      AvailabilityState? isAvailible;
      if (carPlacesCapacity != null && availabilityCarPlacesCapacity != null) {
        isAvailible = _selectAvailavility(
            carPlacesCapacity, availabilityCarPlacesCapacity);
      } else if (totalDisabled != null && freeDisabled != null) {
        isAvailible = freeDisabled > 0
            ? AvailabilityState.availability
            : AvailabilityState.unavailability;
      }
      return isAvailible;
    }
  }

  static AvailabilityState _selectAvailavility(
      int capacity, int availabilityCapacity) {
    final percentage = (availabilityCapacity / capacity) * 100;
    if (percentage > 25) {
      return AvailabilityState.availability;
    } else {
      return AvailabilityState.partial;
    }
  }

  AvailabilityState? markerState() => calculateAvailavility(
        state: state,
        availabilityCarPlacesCapacity: availabilityCarPlacesCapacity,
        carPlacesCapacity: carPlacesCapacity,
        freeDisabled: freeDisabled,
        totalDisabled: totalDisabled,
        sOpeningHours: sOpeningHours,
      );

  String getCurrentOpeningTime() {
    final weekday = DateTime.now().weekday;
    return sOpeningHours!.openingHours.values.toList()[weekday-1].join(",");
  }

  ParkingFeature copyWith({
    GeoJsonPoint? geoJsonPoint,
    String? id,
    String? name,
    String? note,
    String? url,
    String? state,
    String? tags,
    String? openingHours,
    String? feeHours,
    bool? bicyclePlaces,
    bool? anyCarPlaces,
    bool? carPlaces,
    bool? wheelchairAccessibleCarPlaces,
    bool? realTimeData,
    String? capacity,
    int? bicyclePlacesCapacity,
    int? carPlacesCapacity,
    int? availabilityCarPlacesCapacity,
    int? totalDisabled,
    int? freeDisabled,
    ParkingsLayerIds? type,
    SimpleOpeningHours? sOpeningHours,
    LatLng? position,
  }) {
    return ParkingFeature(
      geoJsonPoint: geoJsonPoint ?? this.geoJsonPoint,
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      url: url ?? this.url,
      state: state ?? this.state,
      tags: tags ?? this.tags,
      openingHours: openingHours ?? this.openingHours,
      feeHours: feeHours ?? this.feeHours,
      bicyclePlaces: bicyclePlaces ?? this.bicyclePlaces,
      anyCarPlaces: anyCarPlaces ?? this.anyCarPlaces,
      carPlaces: carPlaces ?? this.carPlaces,
      wheelchairAccessibleCarPlaces:
          wheelchairAccessibleCarPlaces ?? this.wheelchairAccessibleCarPlaces,
      realTimeData: realTimeData ?? this.realTimeData,
      capacity: capacity ?? this.capacity,
      bicyclePlacesCapacity:
          bicyclePlacesCapacity ?? this.bicyclePlacesCapacity,
      carPlacesCapacity: carPlacesCapacity ?? this.carPlacesCapacity,
      availabilityCarPlacesCapacity:
          availabilityCarPlacesCapacity ?? this.availabilityCarPlacesCapacity,
      totalDisabled: totalDisabled ?? this.totalDisabled,
      freeDisabled: freeDisabled ?? this.freeDisabled,
      sOpeningHours: sOpeningHours ?? this.sOpeningHours,
      type: type ?? this.type,
      position: position ?? this.position,
    );
  }
}
