part of 'plan_entity.dart';

class PlaceEntity extends Equatable {
  static const _name = 'name';
  static const _vertexType = 'vertexType';
  static const _lat = 'lat';
  static const _lon = 'lon';
  static const _arrivalTime = 'arrivalTime';
  static const _departureTime = 'departureTime';
  static const _stopEntity = 'stop';
  static const _bikeRentalStation = 'bikeRentalStation';
  static const _bikeParkEntity = 'bikeParkEntity';
  static const _carParkEntity = 'carParkEntity';
  static const _vehicleParkingWithEntrance = 'vehicleParkingWithEntrance';

  final String name;
  final VertexType vertexType;
  final double lat;
  final double lon;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final StopEntity? stopEntity;
  final BikeRentalStationEntity? bikeRentalStation;
  final BikeParkEntity? bikeParkEntity;
  final CarParkEntity? carParkEntity;
  final VehicleParkingWithEntrance? vehicleParkingWithEntrance;

  const PlaceEntity({
    required this.name,
    required this.vertexType,
    required this.lat,
    required this.lon,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopEntity,
    required this.bikeRentalStation,
    required this.bikeParkEntity,
    required this.carParkEntity,
    required this.vehicleParkingWithEntrance,
  });

  Map<String, dynamic> toMap() {
    return {
      _name: name,
      _vertexType: vertexType.name,
      _lat: lat,
      _lon: lon,
      _arrivalTime: arrivalTime?.millisecondsSinceEpoch,
      _departureTime: departureTime?.millisecondsSinceEpoch,
      _stopEntity: stopEntity?.toMap(),
      _bikeRentalStation: bikeRentalStation?.toMap(),
      _bikeParkEntity: bikeParkEntity?.toMap(),
      _carParkEntity: carParkEntity?.toMap(),
      _vehicleParkingWithEntrance: vehicleParkingWithEntrance?.toMap(),
    };
  }

  factory PlaceEntity.fromMap(Map<String, dynamic> map) {
    return PlaceEntity(
      name: map[_name] as String,
      vertexType: getVertexTypeByString(map[_vertexType] as String),
      lat: map[_lat] as double,
      lon: map[_lon] as double,
      arrivalTime: map[_arrivalTime] != null
          ? DateTime.fromMillisecondsSinceEpoch((map[_arrivalTime] ?? 0) as int)
          : null,
      departureTime: map[_departureTime] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map[_departureTime] ?? 0) as int)
          : null,
      stopEntity: map[_stopEntity] != null
          ? StopEntity.fromMap(map[_stopEntity] as Map<String, dynamic>)
          : null,
      bikeRentalStation: map[_bikeRentalStation] != null
          ? BikeRentalStationEntity.fromMap(
              map[_bikeRentalStation] as Map<String, dynamic>)
          : null,
      bikeParkEntity: map[_bikeParkEntity] != null
          ? BikeParkEntity.fromMap(map[_bikeParkEntity] as Map<String, dynamic>)
          : null,
      carParkEntity: map[_carParkEntity] != null
          ? CarParkEntity.fromMap(map[_carParkEntity] as Map<String, dynamic>)
          : null,
      vehicleParkingWithEntrance: map[_vehicleParkingWithEntrance] != null
          ? VehicleParkingWithEntrance.fromMap(
              map[_vehicleParkingWithEntrance] as Map<String, dynamic>)
          : null,
    );
  }

  PlaceEntity copyWith({
    String? name,
    VertexType? vertexType,
    double? lat,
    double? lon,
    DateTime? arrivalTime,
    DateTime? departureTime,
    StopEntity? stopEntity,
    BikeRentalStationEntity? bikeRentalStation,
    BikeParkEntity? bikeParkEntity,
    CarParkEntity? carParkEntity,
    VehicleParkingWithEntrance? vehicleParkingWithEntrance,
  }) {
    return PlaceEntity(
      name: name ?? this.name,
      vertexType: vertexType ?? this.vertexType,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      stopEntity: stopEntity ?? this.stopEntity,
      bikeRentalStation: bikeRentalStation ?? this.bikeRentalStation,
      bikeParkEntity: bikeParkEntity ?? this.bikeParkEntity,
      carParkEntity: carParkEntity ?? this.carParkEntity,
      vehicleParkingWithEntrance:
          vehicleParkingWithEntrance ?? this.vehicleParkingWithEntrance,
    );
  }

  @override
  List<Object?> get props => [
        name,
        vertexType,
        lat,
        lon,
        arrivalTime,
        departureTime,
        stopEntity,
        bikeRentalStation,
        bikeParkEntity,
        carParkEntity,
        vehicleParkingWithEntrance,
      ];
}
