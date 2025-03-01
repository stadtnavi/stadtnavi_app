import 'package:flutter/material.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

import 'agency.dart';
import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'enums/bikes_allowed.dart';
import 'pattern.dart';
import 'stop.dart';
import 'trip.dart';

class RouteOtp {
  final String? id;
  final String? gtfsId;
  final Agency? agency;
  final String? shortName;
  final String? longName;
  final TransportMode? mode;
  final int? type;
  final String? desc;
  final String? url;
  final String? color;
  final String? textColor;
  final BikesAllowed? bikesAllowed;
  final List<PatternOtp>? patterns;
  final List<Stop>? stops;
  final List<Trip>? trips;
  final List<Alert>? alerts;

  const RouteOtp({
    this.id,
    this.gtfsId,
    this.agency,
    this.shortName,
    this.longName,
    this.mode,
    this.type,
    this.desc,
    this.url,
    this.color,
    this.textColor,
    this.bikesAllowed,
    this.patterns,
    this.stops,
    this.trips,
    this.alerts,
  });

  factory RouteOtp.fromJson(Map<String, dynamic> json) => RouteOtp(
        id: json['id'] as String?,
        gtfsId: json['gtfsId'] as String?,
        agency: json['agency'] != null
            ? Agency.fromJson(json['agency'] as Map<String, dynamic>)
            : null,
        shortName: json['shortName'] as String?,
        longName: json['longName'] as String?,
        mode: getTransportMode(mode: json['mode'].toString()),
        type: int.tryParse(json['type'].toString()) ?? 0,
        desc: json['desc'] as String?,
        url: json['url'] as String?,
        color: json['color'] as String?,
        textColor: json['textColor'] as String?,
        bikesAllowed: getBikesAllowedByString(json['bikesAllowed'].toString()),
        patterns: json['patterns'] != null
            ? List<PatternOtp>.from((json["patterns"] as List<dynamic>).map(
                (x) => PatternOtp.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stops: json['stops'] != null
            ? List<Stop>.from((json["stops"] as List<dynamic>).map(
                (x) => PatternOtp.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        trips: json['trips'] != null
            ? List<Trip>.from((json["trips"] as List<dynamic>).map(
                (x) => PatternOtp.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'gtfsId': gtfsId,
  //       'agency': agency?.toJson(),
  //       'shortName': shortName,
  //       'longName': longName,
  //       'mode': mode?.name,
  //       'type': type,
  //       'desc': desc,
  //       'url': url,
  //       'color': color,
  //       'textColor': textColor,
  //       'bikesAllowed': bikesAllowed?.name,
  //       'patterns': List<dynamic>.from(patterns.map((x) => x.toJson())),
  //       'stops': List<dynamic>.from(stops.map((x) => x.toJson())),
  //       'trips': List<dynamic>.from(trips.map((x) => x.toJson())),
  //       'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
  //     };

  Color get primaryColor {
    return color != null
        ? Color(int.tryParse('0xFF$color')!)
        : mode?.color ?? Colors.black;
  }

  String get headsignFromRouteLongName {
    return longName ?? (longName ?? "");
  }

  bool get useIcon {
    return shortName == null || (shortName?.length ?? 0) > 6;
  }
}
