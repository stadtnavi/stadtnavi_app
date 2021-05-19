import 'agency.dart';
import 'alert.dart';
import 'enums/bikes_allowed.dart';
import 'enums/mode.dart';
import 'pattern.dart';
import 'stop.dart';
import 'trip.dart';

class Route {
  final String id;
  final String gtfsId;
  final Agency agency;
  final String shortName;
  final String longName;
  final Mode mode;
  final int type;
  final String desc;
  final String url;
  final String color;
  final String textColor;
  final BikesAllowed bikesAllowed;
  final List<Pattern> patterns;
  final List<Stop> stops;
  final List<Trip> trips;
  final List<Alert> alerts;

  const Route({
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

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        id: json['id'].toString(),
        gtfsId: json['gtfsId'].toString(),
        agency: json['agency'] != null
            ? Agency.fromJson(json['agency'] as Map<String, dynamic>)
            : null,
        shortName: json['shortName'].toString(),
        longName: json['longName'].toString(),
        mode: getModeByString(json[' mode'].toString()),
        type: int.tryParse(json['type'].toString()) ?? 0,
        desc: json['desc'].toString(),
        url: json['url'].toString(),
        color: json['color'].toString(),
        textColor: json['textColor'].toString(),
        bikesAllowed: getBikesAllowedByString(json['bikesAllowed'].toString()),
        patterns: json['patterns'] != null
            ? List<Pattern>.from((json["patterns"] as List<dynamic>).map(
                (x) => Pattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stops: json['stops'] != null
            ? List<Stop>.from((json["stops"] as List<dynamic>).map(
                (x) => Pattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        trips: json['trips'] != null
            ? List<Trip>.from((json["trips"] as List<dynamic>).map(
                (x) => Pattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gtfsId': gtfsId,
        'agency': agency?.toJson(),
        'shortName': shortName,
        'longName': longName,
        'mode': mode?.name,
        'type': type,
        'desc': desc,
        'url': url,
        'color': color,
        'textColor': textColor,
        'bikesAllowed': bikesAllowed?.name,
        'patterns': List<dynamic>.from(patterns.map((x) => x.toJson())),
        'stops': List<dynamic>.from(stops.map((x) => x.toJson())),
        'trips': List<dynamic>.from(trips.map((x) => x.toJson())),
        'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
      };
}
