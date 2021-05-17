enum PBFStopsLayerIds {
  bus,
  carpool,
  rail,
}

extension PBFStopsLayerIdsToString on PBFStopsLayerIds {
  String enumToString() {
    final Map<PBFStopsLayerIds, String> enumStrings = {
      PBFStopsLayerIds.bus: "Bus stops",
      PBFStopsLayerIds.rail: "Train stations",
      PBFStopsLayerIds.carpool: "Carpool stops",
    };
    return enumStrings[this];
  }
}

PBFStopsLayerIds pbfStopsLayerIdsstringToEnum(String id) {
  final Map<String, PBFStopsLayerIds> enumStrings = {
    "BUS": PBFStopsLayerIds.bus,
    "CARPOOL": PBFStopsLayerIds.carpool,
    "RAIL": PBFStopsLayerIds.rail,
  };
  return enumStrings[id];
}