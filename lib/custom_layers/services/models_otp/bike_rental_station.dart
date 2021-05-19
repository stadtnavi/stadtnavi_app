class BikeRentalStation {
  String id;
  String stationId;
  String name;
  int bikesAvailable;
  int spacesAvailable;
  String state;
  bool realtime;
  bool allowDropoff;
  List<String> networks;
  double lon;
  double lat;
  int capacity;
  bool allowOverloading;

  BikeRentalStation({
    this.id,
    this.stationId,
    this.name,
    this.bikesAvailable,
    this.spacesAvailable,
    this.state,
    this.realtime,
    this.allowDropoff,
    this.networks,
    this.lon,
    this.lat,
    this.capacity,
    this.allowOverloading,
  });

  factory BikeRentalStation.fromJson(Map<String, dynamic> json) =>
      BikeRentalStation(
        id: json['id'].toString(),
        stationId: json['stationId'].toString(),
        name: json['name'].toString(),
        bikesAvailable: int.tryParse(json['bikesAvailable'].toString()) ?? 0,
        spacesAvailable: int.tryParse(json['spacesAvailable'].toString()) ?? 0,
        state: json['state'].toString(),
        realtime: json['realtime'] as bool,
        allowDropoff: json['allowDropoff'] as bool,
        networks: json['networks'] != null
            ? (json['networks'] as List<String>)
            : null,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        capacity: int.tryParse(json['capacity'].toString()) ?? 0,
        allowOverloading: json['allowOverloading'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stationId': stationId,
        'name': name,
        'bikesAvailable': bikesAvailable,
        'spacesAvailable': spacesAvailable,
        'state': state,
        'realtime': realtime,
        'allowDropoff': allowDropoff,
        'networks': networks,
        'lon': lon,
        'lat': lat,
        'capacity': capacity,
        'allowOverloading': allowOverloading,
      };
}
