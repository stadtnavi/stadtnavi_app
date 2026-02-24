import 'package:stadtnavi_core/base/otp/entities/plan_entity.dart';
import 'package:stadtnavi_core/base/otp/entities/step_entity.dart';
import 'package:stadtnavi_core/base/otp/enums/enums_plan/absolute_direction.dart';
import 'package:stadtnavi_core/base/otp/enums/enums_plan/relative_direction.dart';
import 'package:stadtnavi_core/base/otp/models/alert.dart';
import 'package:stadtnavi_core/base/otp/models/booking_info.dart';
import 'package:stadtnavi_core/base/otp/models/enums/leg/realtime_state.dart';
import 'package:stadtnavi_core/base/otp/models/enums/mode.dart';
import 'package:stadtnavi_core/base/otp/models/enums/place/vertex_type.dart';
import 'package:stadtnavi_core/base/otp/models/pickup_booking_info.dart';
import 'package:stadtnavi_core/base/otp/models/trip.dart';
import 'package:stadtnavi_core/base/otp/models/vehicle_parking_with_entrance.dart';
import 'package:stadtnavi_core/base/otp/models/elevation_profile_component.dart';
import 'package:stadtnavi_core/base/otp/utils/polyline_utils.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

/// Parses OTP GraphQL responses directly into stadtnavi domain entities.
///
/// Pure static methods — no state, no side effects.
/// Follows the trufi_core response parser pattern where parsing produces
/// domain models directly without an intermediate model layer.
class StadtnaviOtpResponseParser {
  StadtnaviOtpResponseParser._();

  /// Parses a plan from the `viewer.plan` GraphQL response.
  ///
  /// Returns a [PlanEntity] with itineraries, deduplicating and
  /// computing min emissions.
  static PlanEntity parsePlan(Map<String, dynamic>? planJson) {
    if (planJson == null) return const PlanEntity();

    final itineraries = planJson['itineraries'] != null
        ? PlanEntity.removePlanItineraryDuplicates(
            (planJson['itineraries'] as List<dynamic>)
                .map((x) => _parseItinerary(x as Map<String, dynamic>))
                .toList(),
          )
        : <PlanItinerary>[];

    PlanEntity.findMinEmissionsPerPerson(itineraries);

    return PlanEntity(
      from: planJson['from'] != null
          ? _parsePlanLocation(planJson['from'] as Map<String, dynamic>)
          : null,
      to: planJson['to'] != null
          ? _parsePlanLocation(planJson['to'] as Map<String, dynamic>)
          : null,
      itineraries: itineraries,
    ).copyWith(type: 'plan');
  }

  /// Parses multi-modal transport plans from the GraphQL response.
  ///
  /// Expects keys like `walkPlan`, `bikePlan`, `bikeAndPublicPlan`, etc.
  static ModesTransportEntity parseModesTransport(
      Map<String, dynamic> json) {
    PlanEntity? parsePlanKey(String key) {
      final data = json[key] as Map<String, dynamic>?;
      if (data == null) return null;
      return parsePlan(data).copyWith(type: key);
    }

    // Special handling for onDemandTaxiPlan: filter walk-only itineraries
    PlanEntity? parseOnDemandTaxi() {
      final data = json['onDemandTaxiPlan'] as Map<String, dynamic>?;
      if (data == null) return null;
      final plan = parsePlan(data);
      return plan.copyWith(
        type: 'onDemandTaxiPlan',
        itineraries: plan.itineraries
            ?.where((itinerary) => !itinerary.legs.every(
                  (leg) => leg.transportMode == TransportMode.walk,
                ))
            .toList(),
      );
    }

    return ModesTransportEntity(
      walkPlan: parsePlanKey('walkPlan'),
      bikePlan: parsePlanKey('bikePlan'),
      bikeAndPublicPlan: parsePlanKey('bikeAndPublicPlan'),
      bikeParkPlan: parsePlanKey('bikeParkPlan'),
      carPlan: parsePlanKey('carPlan'),
      carParkPlan: parsePlanKey('carParkPlan'),
      parkRidePlan: parsePlanKey('parkRidePlan'),
      onDemandTaxiPlan: parseOnDemandTaxi(),
    );
  }

  // Private parsers

  static PlanItinerary _parseItinerary(Map<String, dynamic> json) {
    return PlanItinerary(
      legs: json['legs'] != null
          ? (json['legs'] as List<dynamic>)
              .map((x) => _parseLeg(x as Map<String, dynamic>))
              .toList()
          : [],
      startTime: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['startTime'].toString()) ?? 0,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['endTime'].toString()) ?? 0,
      ),
      walkTime: Duration(
          seconds: int.tryParse(json['walkTime'].toString()) ?? 0),
      duration: Duration(
          seconds: int.tryParse(json['duration'].toString()) ?? 0),
      walkDistance: double.tryParse(json['walkDistance'].toString()) ?? 0,
      arrivedAtDestinationWithRentedBicycle:
          json['arrivedAtDestinationWithRentedBicycle'] as bool? ?? false,
      emissionsPerPerson: double.tryParse(
          json['emissionsPerPerson']?['co2']?.toString() ?? ''),
    );
  }

  static PlanItineraryLeg _parseLeg(Map<String, dynamic> json) {
    final mode = getModeByString(json['mode'].toString());
    final route = json['route'] != null
        ? _parseRouteEntity(json['route'] as Map<String, dynamic>)
        : null;
    final agency = json['agency'] != null
        ? _parseAgencyEntity(json['agency'] as Map<String, dynamic>)
        : null;
    final legGeometry = json['legGeometry'] as Map<String, dynamic>?;
    final points = legGeometry?['points'] as String? ?? '';

    return PlanItineraryLeg(
      points: points,
      mode: mode.name,
      route: route,
      routeLongName: route?.longName ?? '',
      distance: double.tryParse(json['distance'].toString()) ?? 0,
      duration: Duration(
          seconds: (double.tryParse(json['duration'].toString()) ?? 0).toInt()),
      agency: agency,
      realtimeState: getRealtimeStateByString(
          json['realtimeState']?.toString() ?? ''),
      toPlace: json['to'] != null
          ? _parsePlaceEntity(json['to'] as Map<String, dynamic>)
          : null,
      fromPlace: json['from'] != null
          ? _parsePlaceEntity(json['from'] as Map<String, dynamic>)
          : null,
      startTime: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['startTime'].toString()) ?? 0,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['endTime'].toString()) ?? 0,
      ),
      departureDelay: int.tryParse(json['departureDelay'].toString()) ?? 0,
      arrivalDelay: int.tryParse(json['arrivalDelay'].toString()) ?? 0,
      steps: json['steps'] != null
          ? (json['steps'] as List<dynamic>)
              .map((x) => _parseStepEntity(x as Map<String, dynamic>))
              .toList()
          : null,
      intermediatePlaces: json['intermediatePlaces'] != null
          ? (json['intermediatePlaces'] as List<dynamic>)
              .map((x) => _parsePlaceEntity(x as Map<String, dynamic>))
              .toList()
          : null,
      intermediatePlace: json['intermediatePlace'] as bool?,
      transitLeg: json['transitLeg'] as bool? ?? false,
      rentedBike: json['rentedBike'] as bool?,
      interlineWithPreviousLeg: json['interlineWithPreviousLeg'] as bool?,
      pickupBookingInfo: json['pickupBookingInfo'] != null
          ? PickupBookingInfo.fromMap(
              json['pickupBookingInfo'] as Map<String, dynamic>)
          : null,
      dropOffBookingInfo: json['dropOffBookingInfo'] != null
          ? BookingInfo.fromMap(
              json['dropOffBookingInfo'] as Map<String, dynamic>)
          : null,
      accumulatedPoints: points.isNotEmpty ? decodePolyline(points) : [],
      trip: json['trip'] != null
          ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
          : null,
    );
  }

  static PlanLocation _parsePlanLocation(Map<String, dynamic> json) {
    return PlanLocation(
      name: json['name'] as String? ?? '',
      latitude: double.tryParse(json['lat'].toString()) ?? 0,
      longitude: double.tryParse(json['lon'].toString()) ?? 0,
    );
  }

  static PlaceEntity _parsePlaceEntity(Map<String, dynamic> json) {
    return PlaceEntity(
      name: json['name'] as String? ?? '',
      vertexType: getVertexTypeByString(json['vertexType']?.toString() ?? ''),
      lat: double.tryParse(json['lat'].toString()) ?? 0,
      lon: double.tryParse(json['lon'].toString()) ?? 0,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              double.tryParse(json['arrivalTime'].toString())?.toInt() ?? 0)
          : null,
      departureTime: json['departureTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              double.tryParse(json['departureTime'].toString())?.toInt() ?? 0)
          : null,
      stopEntity: json['stop'] != null
          ? _parseStopEntity(json['stop'] as Map<String, dynamic>)
          : null,
      bikeRentalStation: json['bikeRentalStation'] != null
          ? _parseBikeRentalStationEntity(
              json['bikeRentalStation'] as Map<String, dynamic>)
          : null,
      bikeParkEntity: json['bikePark'] != null
          ? _parseBikeParkEntity(json['bikePark'] as Map<String, dynamic>)
          : null,
      carParkEntity: json['carPark'] != null
          ? _parseCarParkEntity(json['carPark'] as Map<String, dynamic>)
          : null,
      vehicleParkingWithEntrance: json['vehicleParkingWithEntrance'] != null
          ? VehicleParkingWithEntrance.fromMap(
              json['vehicleParkingWithEntrance'] as Map<String, dynamic>)
          : null,
    );
  }

  static StopEntity _parseStopEntity(Map<String, dynamic> json) {
    return StopEntity(
      id: json['id'] as String?,
      gtfsId: json['gtfsId'] as String?,
      name: json['name'] as String?,
      lat: double.tryParse(json['lat'].toString()),
      lon: double.tryParse(json['lon'].toString()),
      code: json['code'] as String?,
      zoneId: json['zoneId'] as String?,
      platformCode: json['platformCode'] as String?,
      vehicleMode: getTransportMode(
          mode: getModeByString(json['vehicleMode']?.toString() ?? '').name),
      alerts: json['alerts'] != null
          ? (json['alerts'] as List<dynamic>)
              .map((x) => Alert.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  static RouteEntity _parseRouteEntity(Map<String, dynamic> json) {
    return RouteEntity(
      id: json['id'] as String?,
      gtfsId: json['gtfsId'] as String?,
      agency: json['agency'] != null
          ? _parseAgencyEntity(json['agency'] as Map<String, dynamic>)
          : null,
      shortName: json['shortName'] as String?,
      longName: json['longName'] as String?,
      mode: getTransportMode(
          mode: getModeByString(json['mode']?.toString() ?? '').name),
      type: int.tryParse(json['type'].toString()),
      desc: json['desc'] as String?,
      url: json['url'] as String?,
      color: json['color'] as String?,
      textColor: json['textColor'] as String?,
      alerts: json['alerts'] != null
          ? (json['alerts'] as List<dynamic>)
              .map((x) => Alert.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  static AgencyEntity _parseAgencyEntity(Map<String, dynamic> json) {
    return AgencyEntity(
      id: int.tryParse(json['id'].toString()) ?? 0,
      gtfsId: json['gtfsId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? '',
      lang: json['lang']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      fareUrl: json['fareUrl']?.toString() ?? '',
    );
  }

  static StepEntity _parseStepEntity(Map<String, dynamic> json) {
    return StepEntity(
      distance: double.tryParse(json['distance'].toString()),
      lon: double.tryParse(json['lon'].toString()),
      lat: double.tryParse(json['lat'].toString()),
      elevationProfile: json['elevationProfile'] != null
          ? (json['elevationProfile'] as List<dynamic>)
              .map((x) =>
                  ElevationProfileComponent.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
      relativeDirection: json['relativeDirection'] != null
          ? getRelativeDirectionByString(json['relativeDirection'])
          : null,
      absoluteDirection: json['absoluteDirection'] != null
          ? getAbsoluteDirectionByString(json['absoluteDirection'])
          : null,
      streetName: json['streetName'] as String?,
      exit: json['exit'] as String?,
      stayOn: json['stayOn'] as bool?,
      area: json['area'] as bool?,
      bogusName: json['bogusName'] as bool?,
      walkingBike: json['walkingBike'] as bool?,
    );
  }

  static BikeRentalStationEntity _parseBikeRentalStationEntity(
      Map<String, dynamic> json) {
    return BikeRentalStationEntity(
      id: json['stationId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bikesAvailable: int.tryParse(json['bikesAvailable'].toString()),
      spacesAvailable: int.tryParse(json['spacesAvailable'].toString()),
      networks: json['networks'] != null
          ? (json['networks'] as List<dynamic>).cast<String>()
          : null,
    );
  }

  static BikeParkEntity _parseBikeParkEntity(Map<String, dynamic> json) {
    return BikeParkEntity(
      id: json['bikeParkId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      spacesAvailable: int.tryParse(json['spacesAvailable'].toString()),
    );
  }

  static CarParkEntity _parseCarParkEntity(Map<String, dynamic> json) {
    return CarParkEntity(
      id: json['carParkId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      spacesAvailable: int.tryParse(json['spacesAvailable'].toString()),
      maxCapacity: int.tryParse(json['maxCapacity'].toString()),
      realtime: json['realtime'] as bool?,
    );
  }
}
