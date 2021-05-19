import 'stop.dart';

class StopAtDistance {
  String id;
  Stop stop;
  int distance;

  StopAtDistance({
    this.id,
    this.stop,
    this.distance,
  });

  factory StopAtDistance.fromJson(Map<String, dynamic> json) => StopAtDistance(
        id: json['id'].toString(),
        stop: json['stop'] != null
            ? Stop.fromJson(json['stop'] as Map<String, dynamic>)
            : null,
        distance: int.tryParse(json['distance'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stop': stop?.toJson(),
        'distance': distance,
      };
}
