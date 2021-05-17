
enum PBFParkingLayerIds {
  parkingGarage,
  parkingSpot,
  rvParking,
  parkRide,
  undergroundCarPark,
  barrierFreeParkingSpace,
  parkCarpool,
}

extension PBFParkingLayerIdsToString on PBFParkingLayerIds {
  String enumToString() {
    final Map<PBFParkingLayerIds, String> enumStrings = {
      PBFParkingLayerIds.parkingGarage: "Parking Garage",
      PBFParkingLayerIds.parkingSpot: "Parking Spot",
      PBFParkingLayerIds.rvParking: "RV Parking",
      PBFParkingLayerIds.parkRide: "Park Ride",
      PBFParkingLayerIds.undergroundCarPark: "Underground car park",
      PBFParkingLayerIds.barrierFreeParkingSpace: "Barrier-free parking space",
      PBFParkingLayerIds.parkCarpool: "Park Carpool",
    };
    return enumStrings[this];
  }
}

PBFParkingLayerIds pbfParkingLayerIdsstringToEnum(String id) {
  final Map<String, PBFParkingLayerIds> enumStrings = {
    "Parkhaus": PBFParkingLayerIds.parkingGarage,
    "Parkplatz": PBFParkingLayerIds.parkingSpot,
    "Wohnmobilparkplatz": PBFParkingLayerIds.rvParking,
    "Park-Ride": PBFParkingLayerIds.parkRide,
    "Tiefgarage": PBFParkingLayerIds.undergroundCarPark,
    "Barrierefreier-Parkplatz": PBFParkingLayerIds.barrierFreeParkingSpace,
    "Park-Carpool": PBFParkingLayerIds.parkCarpool,
  };
  if (enumStrings[id] == null) {
    throw Exception(
      "Should never happened, there is no PBFParkingLayerIds for $id",
    );
  }
  return enumStrings[id];
}
