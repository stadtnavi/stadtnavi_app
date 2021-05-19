import 'place_interface.dart';

class PlaceAtDistance {
  String id;
  PlaceInterface place;
  int distance;

  PlaceAtDistance({this.id, this.place, this.distance});

  factory PlaceAtDistance.fromJson(Map<String, dynamic> json) =>
      PlaceAtDistance(
        id: json['id'].toString(),
        place: json['place'] != null
            ? PlaceInterface.fromJson(json['place'] as Map<String, dynamic>)
            : null,
        distance: int.tryParse(json['distance'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'place': place?.toJson(),
        'distance': distance,
      };
}
