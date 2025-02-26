import 'package:intl/intl.dart';

import 'enums/leg/pickup_dropoff_type.dart';
import 'enums/leg/realtime_state.dart';
import 'stop.dart';
import 'trip.dart';

class StoptimeOtp {
  final Stop? stop;
  final int? scheduledArrival;
  final int? realtimeArrival;
  final int? arrivalDelay;
  final int? scheduledDeparture;
  final int? realtimeDeparture;
  final int? departureDelay;
  final bool? timepoint;
  final bool? realtime;
  final RealtimeState? realtimeState;
  final PickupDropoffType? pickupType;
  final PickupDropoffType? dropoffType;
  final double? serviceDay;
  final Trip? trip;
  final String? headsign;

  const StoptimeOtp({
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

  factory StoptimeOtp.fromJson(Map<String, dynamic> json) => StoptimeOtp(
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
        timepoint: json['timepoint'] as bool?,
        realtime: json['realtime'] as bool?,
        realtimeState:
            getRealtimeStateByString(json['realtimeState'].toString()),
        pickupType: getPickupDropoffTypeByString(json['pickupType'].toString()),
        dropoffType:
            getPickupDropoffTypeByString(json['dropoffType'].toString()),
        serviceDay: double.tryParse(json['serviceDay'].toString()) ?? 0,
        trip: json['trip'] != null
            ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
            : null,
        headsign: json['headsign'] as String?,
      );

  // Map<String, dynamic> toJson() => {
  //       'stop': stop?.toJson(),
  //       'scheduledArrival': scheduledArrival,
  //       'realtimeArrival': realtimeArrival,
  //       'arrivalDelay': arrivalDelay,
  //       'scheduledDeparture': scheduledDeparture,
  //       'realtimeDeparture': realtimeDeparture,
  //       'departureDelay': departureDelay,
  //       'timepoint': timepoint,
  //       'realtime': realtime,
  //       'realtimeState': realtimeState?.name,
  //       'pickupType': pickupType?.name,
  //       'dropoffType': dropoffType?.name,
  //       'serviceDay': serviceDay,
  //       'trip': trip?.toJson(),
  //       'headsign': headsign,
  //     };

  bool get isArrival {
    return pickupType == PickupDropoffType.none;
  }

  bool get canceled {
    return realtimeState == RealtimeState.canceled;
  }

  String getHeadsing({
    required bool isLastStop,
    String? languageCode,
  }) {
    if (isArrival) {
      if (isLastStop) {
        return languageCode == 'en'
            ? 'Arrives / Terminus'
            : 'Ankunft / Endstation';
      }
      return trip?.tripHeadsign ??
          (languageCode == 'en' ? 'Drop-off only' : 'Nur Ausstieg');
    }
    final String tempHeadsing = headsign ??
        (trip?.pattern?.headsign ??
            (trip?.tripHeadsign ??
                trip?.pattern?.route?.headsignFromRouteLongName ??
                ''));
    if (tempHeadsing.endsWith(' via')) {
      return tempHeadsing.substring(0, tempHeadsing.indexOf(' via'));
    }
    return tempHeadsing;
  }

  int get arrivalTime {
    return ((serviceDay ?? 0) +
            (canceled ? (scheduledArrival ?? 0) : (realtimeArrival ?? 0)))
        .truncate();
  }

  int get departureTime {
    return ((serviceDay ?? 0) +
            (canceled ? (scheduledDeparture ?? 0) : (realtimeDeparture ?? 0)))
        .truncate();
  }

  DateTime get dateTime {
    final int timestamp = isArrival ? arrivalTime : departureTime;
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  bool get isNextDay {
    final now = DateTime.now();
    final dateTemp = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return dateTime.isAfter(dateTemp);
  }

  String get timeDiffInMinutes {
    String timeDiffInMinutes = '';
    final diffMinutes = dateTime.difference(DateTime.now()).inMinutes;
    if (diffMinutes < 0) {
      // TODO translate
      timeDiffInMinutes = '';
    } else if (diffMinutes == 0) {
      // TODO translate
      timeDiffInMinutes = 'now';
    } else if (diffMinutes < 10) {
      // TODO translate min
      timeDiffInMinutes = '${diffMinutes.toString()} min';
    }
    return timeDiffInMinutes;
  }

  String get stopTimeAsString {
    return DateFormat('HH:mm').format(dateTime);
  }
}
