enum StopsLayerIds {
  bus,
  carpool,
  rail,
  subway,
}

extension StopsLayerIdsIdsToString on StopsLayerIds {
  String enumToString() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: "Bus stops",
      StopsLayerIds.rail: "Train stations",
      StopsLayerIds.carpool: "Carpool stops",
      StopsLayerIds.subway: "Metro Station",
    };
    return enumStrings[this] ?? "Bus stops";
  }
}

StopsLayerIds stopsLayerIdsstringToEnum(String id) {
  final Map<String, StopsLayerIds> enumStrings = {
    "BUS": StopsLayerIds.bus,
    "CARPOOL": StopsLayerIds.carpool,
    "RAIL": StopsLayerIds.rail,
    "SUBWAY": StopsLayerIds.subway,
  };
  return enumStrings[id] ?? StopsLayerIds.bus;
}
