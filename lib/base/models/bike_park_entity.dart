part of 'plan_entity.dart';

class BikeParkEntity extends Equatable {
  final String? id;
  final String? bikeParkId;
  final String? name;
  final int? spacesAvailable;
  final bool? realtime;
  final double? lon;
  final double? lat;

  const BikeParkEntity({
    this.id,
    this.bikeParkId,
    this.name,
    this.spacesAvailable,
    this.realtime,
    this.lon,
    this.lat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bikeParkId': bikeParkId,
      'name': name,
      'spacesAvailable': spacesAvailable,
      'realtime': realtime,
      'lon': lon,
      'lat': lat,
    };
  }

  factory BikeParkEntity.fromMap(Map<String, dynamic> map) {
    return BikeParkEntity(
      id: map['id'] as String?,
      bikeParkId: map['bikeParkId'] as String?,
      name: map['name'] as String?,
      spacesAvailable: map['spacesAvailable'] as int?,
      realtime: map['realtime'] as bool?,
      lon: map['lon'] as double?,
      lat: map['lat'] as double?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bikeParkId,
        name,
        spacesAvailable,
        realtime,
        lon,
        lat,
      ];
}
