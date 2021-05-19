class PlaceInterface {
  String id;
  double lat;
  double lon;

  PlaceInterface({
    this.id,
    this.lat,
    this.lon,
  });

  factory PlaceInterface.fromJson(Map<String, dynamic> json) => PlaceInterface(
        id: json['id'].toString(),
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'lon': lon,
      };
}
