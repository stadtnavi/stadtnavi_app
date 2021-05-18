enum StopsLayerIds {
  bus,
  carpool,
  rail,
}

extension StopsLayerIdsIdsToString on StopsLayerIds {
  String enumToString() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: "Bus stops",
      StopsLayerIds.rail: "Train stations",
      StopsLayerIds.carpool: "Carpool stops",
    };
    return enumStrings[this];
  }
}

StopsLayerIds stopsLayerIdsstringToEnum(String id) {
  final Map<String, StopsLayerIds> enumStrings = {
    "BUS": StopsLayerIds.bus,
    "CARPOOL": StopsLayerIds.carpool,
    "RAIL": StopsLayerIds.rail,
  };
  return enumStrings[id];
}