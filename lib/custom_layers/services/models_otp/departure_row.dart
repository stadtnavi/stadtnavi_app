import 'pattern.dart';
import 'stop.dart';
import 'stoptime.dart';

class DepartureRow {
  String id;
  Stop stop;
  double lat;
  double lon;
  Pattern pattern;
  List<Stoptime> stoptimes;

  DepartureRow({
    this.id,
    this.stop,
    this.lat,
    this.lon,
    this.pattern,
    this.stoptimes,
  });

  factory DepartureRow.fromJson(Map<String, dynamic> json) => DepartureRow(
        id: json['id'] as String,
        stop: json['stop'] != null
            ? Stop.fromJson(json['stop'] as Map<String, dynamic>)
            : null,
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
        pattern: json['pattern'] != null
            ? Pattern.fromJson(json['pattern'] as Map<String, dynamic>)
            : null,
        stoptimes: json['stoptimes'] != null
            ? List<Stoptime>.from((json["stoptimes"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stop': stop?.toJson(),
        'lat': lat,
        'lon': lon,
        'pattern': pattern?.toJson(),
        'stoptimes': List<dynamic>.from(stoptimes.map((x) => x.toJson())),
      };
}