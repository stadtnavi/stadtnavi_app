import 'place_at_distance.dart';

class PlaceAtDistanceEdge {
  PlaceAtDistance node;
  String cursor;

  PlaceAtDistanceEdge({this.node, this.cursor});

  factory PlaceAtDistanceEdge.fromJson(Map<String, dynamic> json) =>
      PlaceAtDistanceEdge(
        node: json['node'] != null
            ? PlaceAtDistance.fromJson(json['node'] as Map<String, dynamic>)
            : null,
        cursor: json['cursor'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'node': node?.toJson(),
        'cursor': cursor,
      };
}
