
enum ParkingsLayerIds {
  parkingGarage,
  parkingSpot,
  rvParking,
  parkRide,
  undergroundCarPark,
  barrierFreeParkingSpace,
  parkCarpool,
}

extension PBFParkingLayerIdsToString on ParkingsLayerIds {
  String enumToString() {
    final Map<ParkingsLayerIds, String> enumStrings = {
      ParkingsLayerIds.parkingGarage: "Parking Garage",
      ParkingsLayerIds.parkingSpot: "Parking Spot",
      ParkingsLayerIds.rvParking: "RV Parking",
      ParkingsLayerIds.parkRide: "Park Ride",
      ParkingsLayerIds.undergroundCarPark: "Underground car park",
      ParkingsLayerIds.barrierFreeParkingSpace: "Barrier-free parking space",
      ParkingsLayerIds.parkCarpool: "Park Carpool",
    };
    return enumStrings[this];
  }
}

ParkingsLayerIds pbfParkingLayerIdsstringToEnum(String id) {
  final Map<String, ParkingsLayerIds> enumStrings = {
    "Parkhaus": ParkingsLayerIds.parkingGarage,
    "Parkplatz": ParkingsLayerIds.parkingSpot,
    "Wohnmobilparkplatz": ParkingsLayerIds.rvParking,
    "Park-Ride": ParkingsLayerIds.parkRide,
    "Tiefgarage": ParkingsLayerIds.undergroundCarPark,
    "Barrierefreier-Parkplatz": ParkingsLayerIds.barrierFreeParkingSpace,
    "Park-Carpool": ParkingsLayerIds.parkCarpool,
  };
  if (enumStrings[id] == null) {
    throw Exception(
      "Should never happened, there is no PBFParkingLayerIds for $id",
    );
  }
  return enumStrings[id];
}
