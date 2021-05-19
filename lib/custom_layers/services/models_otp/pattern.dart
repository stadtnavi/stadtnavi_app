import 'alert.dart';
import 'coordinates.dart';
import 'geometry.dart';
import 'route.dart';
import 'stop.dart';
import 'trip.dart';

class Pattern {
  String id;
  Route route;
  int directionId;
  String name;
  String code;
  String headsign;
  List<Trip> trips;
  List<Trip> tripsForDate;
  List<Stop> stops;
  List<Coordinates> geometry;
  Geometry patternGeometry;
  String semanticHash;
  List<Alert> alerts;
  Pattern(
      {this.id,
      this.route,
      this.directionId,
      this.name,
      this.code,
      this.headsign,
      this.trips,
      this.tripsForDate,
      this.stops,
      this.geometry,
      this.patternGeometry,
      this.semanticHash,
      this.alerts});

  factory Pattern.fromJson(Map<String, dynamic> json) => Pattern(
        id: json['id'].toString(),
        route: json['route'] != null
            ? Route.fromJson(json['route'] as Map<String, dynamic>)
            : null,
        directionId: int.tryParse(json['directionId'].toString()) ?? 0,
        name: json['name'].toString(),
        code: json['code'].toString(),
        headsign: json['headsign'].toString(),
        trips: json['trips'] != null
            ? List<Trip>.from((json["trips"] as List<dynamic>).map(
                (x) => Trip.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        tripsForDate: json['tripsForDate'] != null
            ? List<Trip>.from((json["tripsForDate"] as List<dynamic>).map(
                (x) => Trip.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stops: json['stops'] != null
            ? List<Stop>.from((json["stops"] as List<dynamic>).map(
                (x) => Stop.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        geometry: json['geometry'] != null
            ? List<Coordinates>.from((json["geometry"] as List<dynamic>).map(
                (x) => Coordinates.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        patternGeometry: json['patternGeometry'] != null
            ? Geometry.fromJson(json['patternGeometry'] as Map<String, dynamic>)
            : null,
        semanticHash: json['semanticHash'].toString(),
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'route': route?.toJson(),
        'directionId': directionId,
        'name': name,
        'code': code,
        'headsign': headsign,
        'trips': List<dynamic>.from(trips.map((x) => x.toJson())),
        'tripsForDate': List<dynamic>.from(tripsForDate.map((x) => x.toJson())),
        'stops': List<dynamic>.from(stops.map((x) => x.toJson())),
        'geometry': List<dynamic>.from(geometry.map((x) => x.toJson())),
        'patternGeometry': patternGeometry?.toJson(),
        'semanticHash': semanticHash,
        'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
      };
}