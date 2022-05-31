enum ParkingsLayerIds {
  parkingGarage,
  parkingSpot,
  rvParking,
  parkRide,
  undergroundCarPark,
  barrierFreeParkingSpace,
  parkCarpool,
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
  return enumStrings[id]!;
}
