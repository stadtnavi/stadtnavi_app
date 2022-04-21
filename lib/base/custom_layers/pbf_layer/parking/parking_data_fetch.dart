import 'package:stadtnavi_core/base/models/othermodel/vehicle_parking.dart';
import 'package:stadtnavi_core/base/models/othermodel/vehicle_places.dart';

class VehicleParkingDataFetch {
  final String? name;
  final double? lat;
  final double? lon;
  final VehiclePlaces? capacity;
  final VehiclePlaces? availability;
  final String? imageUrl;
  final List<String>? tags;
  final bool? anyCarPlaces;
  final String? vehicleParkingId;
  final String? detailsUrl;
  final String? note;
  final String? openingHours;

  const VehicleParkingDataFetch({
    this.name,
    this.lat,
    this.lon,
    this.capacity,
    this.availability,
    this.imageUrl,
    this.tags,
    this.anyCarPlaces,
    this.vehicleParkingId,
    this.detailsUrl,
    this.note,
    this.openingHours,
  });

  factory VehicleParkingDataFetch.fromVehicleParking(
    VehicleParking parkingData,
  ) {
    return VehicleParkingDataFetch(
      name: parkingData.name,
      lat: parkingData.lat,
      lon: parkingData.lon,
      capacity: parkingData.capacity,
      availability: parkingData.availability,
      imageUrl: parkingData.imageUrl,
      tags: parkingData.tags,
      anyCarPlaces: parkingData.anyCarPlaces,
      vehicleParkingId: parkingData.vehicleParkingId,
      detailsUrl: parkingData.detailsUrl,
      note: parkingData.note,
      openingHours: parkingData.openingHours,
    );
  }
}
