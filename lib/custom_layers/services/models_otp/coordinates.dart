class Coordinates {
  double lat;
  double lon;
  Coordinates({this.lat, this.lon});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };
}
