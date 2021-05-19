import 'enums/leg/pickup_dropoff_type.dart';
import 'enums/leg/realtime_state.dart';
import 'stop.dart';
import 'trip.dart';

class Stoptime {
  Stop stop;
  int scheduledArrival;
  int realtimeArrival;
  int arrivalDelay;
  int scheduledDeparture;
  int realtimeDeparture;
  int departureDelay;
  bool timepoint;
  bool realtime;
  RealtimeState realtimeState;
  PickupDropoffType pickupType;
  PickupDropoffType dropoffType;
  double serviceDay;
  Trip trip;
  String headsign;

  Stoptime({
    this.stop,
    this.scheduledArrival,
    this.realtimeArrival,
    this.arrivalDelay,
    this.scheduledDeparture,
    this.realtimeDeparture,
    this.departureDelay,
    this.timepoint,
    this.realtime,
    this.realtimeState,
    this.pickupType,
    this.dropoffType,
    this.serviceDay,
    this.trip,
    this.headsign,
  });

  factory Stoptime.fromJson(Map<String, dynamic> json) => Stoptime(
        stop: json['stop'] != null
            ? Stop.fromJson(json['stop'] as Map<String, dynamic>)
            : null,
        scheduledArrival:
            int.tryParse(json['scheduledArrival'].toString()) ?? 0,
        realtimeArrival: int.tryParse(json['realtimeArrival'].toString()) ?? 0,
        arrivalDelay: int.tryParse(json['arrivalDelay'].toString()) ?? 0,
        scheduledDeparture:
            int.tryParse(json['scheduledDeparture'].toString()) ?? 0,
        realtimeDeparture:
            int.tryParse(json['realtimeDeparture'].toString()) ?? 0,
        departureDelay: int.tryParse(json['departureDelay'].toString()) ?? 0,
        timepoint: json['timepoint'] as bool,
        realtime: json['realtime'] as bool,
        realtimeState:
            getRealtimeStateByString(json['realtimeState'].toString()),
        pickupType: getPickupDropoffTypeByString(json['pickupType'].toString()),
        dropoffType:
            getPickupDropoffTypeByString(json['dropoffType'].toString()),
        serviceDay: double.tryParse(json['serviceDay'].toString()) ?? 0,
        trip: json['trip'] != null
            ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
            : null,
        headsign: json['headsign'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'stop': stop?.toJson(),
        'scheduledArrival': scheduledArrival,
        'realtimeArrival': realtimeArrival,
        'arrivalDelay': arrivalDelay,
        'scheduledDeparture': scheduledDeparture,
        'realtimeDeparture': realtimeDeparture,
        'departureDelay': departureDelay,
        'timepoint': timepoint,
        'realtime': realtime,
        'realtimeState': realtimeState?.name,
        'pickupType': pickupType?.name,
        'dropoffType': dropoffType?.name,
        'serviceDay': serviceDay,
        'trip': trip?.toJson(),
        'headsign': headsign,
      };
}
