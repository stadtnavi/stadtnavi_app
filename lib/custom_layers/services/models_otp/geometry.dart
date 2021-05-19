class Geometry {
  int length;
  String points;

  Geometry({this.length, this.points});

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        length: int.tryParse(json['length'].toString()) ?? 0,
        points: json['points'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'length': length,
        'points': points,
      };
}
