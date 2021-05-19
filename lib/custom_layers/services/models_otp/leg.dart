import 'agency.dart';
import 'alert.dart';
import 'enums/leg/pickup_dropoff_type.dart';
import 'enums/leg/realtime_state.dart';
import 'enums/mode.dart';
import 'geometry.dart';
import 'place.dart';
import 'route.dart';
import 'step.dart';
import 'stop.dart';
import 'trip.dart';

class Leg {
  double startTime;
  double endTime;
  int departureDelay;
  int arrivalDelay;
  Mode mode;
  double duration;
  int generalizedCost;
  Geometry legGeometry;
  Agency agency;
  bool realTime;
  RealtimeState realtimeState;
  double distance;
  bool transitLeg;
  bool rentedBike;
  Place from;
  Place to;
  Route route;
  Trip trip;
  String serviceDate;
  List<Stop> intermediateStops;
  List<Place> intermediatePlaces;
  bool intermediatePlace;
  List<Step> steps;
  PickupDropoffType pickupType;
  PickupDropoffType dropoffType;
  bool interlineWithPreviousLeg;
  List<Alert> alerts;
  Leg(
      {this.startTime,
      this.endTime,
      this.departureDelay,
      this.arrivalDelay,
      this.mode,
      this.duration,
      this.generalizedCost,
      this.legGeometry,
      this.agency,
      this.realTime,
      this.realtimeState,
      this.distance,
      this.transitLeg,
      this.rentedBike,
      this.from,
      this.to,
      this.route,
      this.trip,
      this.serviceDate,
      this.intermediateStops,
      this.intermediatePlaces,
      this.intermediatePlace,
      this.steps,
      this.pickupType,
      this.dropoffType,
      this.interlineWithPreviousLeg,
      this.alerts});

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        startTime: double.tryParse(json['startTime'].toString()) ?? 0,
        endTime: double.tryParse(json['endTime'].toString()) ?? 0,
        departureDelay: int.tryParse(json['departureDelay'].toString()) ?? 0,
        arrivalDelay: int.tryParse(json['arrivalDelay'].toString()) ?? 0,
        mode: getModeByString(json['mode'].toString()),
        duration: double.tryParse(json['duration'].toString()) ?? 0,
        generalizedCost: int.tryParse(json['generalizedCost'].toString()) ?? 0,
        legGeometry: json['legGeometry'] != null
            ? Geometry.fromJson(json['legGeometry'] as Map<String, dynamic>)
            : null,
        agency: json['agency'] != null
            ? Agency.fromJson(json['agency'] as Map<String, dynamic>)
            : null,
        realTime: json['realTime'] as bool,
        realtimeState:
            getRealtimeStateByString(json['realtimeState'].toString()),
        distance: double.tryParse(json['distance'].toString()) ?? 0,
        transitLeg: json['transitLeg'] as bool,
        rentedBike: json['rentedBike'] as bool,
        from: json['from'] != null
            ? Place.fromJson(json['from'] as Map<String, dynamic>)
            : null,
        to: json['to'] != null
            ? Place.fromJson(json['to'] as Map<String, dynamic>)
            : null,
        route: json['route'] != null
            ? Route.fromJson(json['route'] as Map<String, dynamic>)
            : null,
        trip: json['trip'] != null
            ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
            : null,
        serviceDate: json['serviceDate'].toString(),
        intermediateStops: json['intermediateStops'] != null
            ? List<Stop>.from((json["intermediateStops"] as List<dynamic>).map(
                (x) => Stop.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        intermediatePlaces: json['intermediatePlaces'] != null
            ? List<Place>.from(
                (json["intermediatePlaces"] as List<dynamic>).map(
                (x) => Place.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        intermediatePlace: json['intermediatePlace'] as bool,
        steps: json['steps'] != null
            ? List<Step>.from((json["steps"] as List<dynamic>).map(
                (x) => Step.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        pickupType: getPickupDropoffTypeByString(json['pickupType'].toString()),
        dropoffType:
            getPickupDropoffTypeByString(json['dropoffType'].toString()),
        interlineWithPreviousLeg: json['interlineWithPreviousLeg'] as bool,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'departureDelay': departureDelay,
        'arrivalDelay': arrivalDelay,
        'mode': mode?.name,
        'duration': duration,
        'generalizedCost': generalizedCost,
        'legGeometry': legGeometry?.toJson(),
        'agency': agency?.toJson(),
        'realTime': realTime,
        'realtimeState': realtimeState?.name,
        'distance': distance,
        'transitLeg': transitLeg,
        'rentedBike': rentedBike,
        'from': from?.toJson(),
        'to': to?.toJson(),
        'route': route?.toJson(),
        'trip': trip?.toJson(),
        'serviceDate': serviceDate,
        'intermediateStops':
            List<dynamic>.from(intermediateStops.map((x) => x.toJson())),
        'intermediatePlaces':
            List<dynamic>.from(intermediatePlaces.map((x) => x.toJson())),
        'intermediatePlace': intermediatePlace,
        'steps': List<dynamic>.from(steps.map((x) => x.toJson())),
        'pickupType': pickupType?.name,
        'dropoffType': dropoffType?.name,
        'interlineWithPreviousLeg': interlineWithPreviousLeg,
        'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
      };
}
