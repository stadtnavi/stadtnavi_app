enum CifsTypeIds {
  roadClosed,
  construction,
}
enum CifsSubTypeIds {
  roadClosedConstruction,
}
CifsTypeIds cifsTypeIdsStringToEnum(String id) {
  final Map<String, CifsTypeIds> enumStrings = {
    "ROAD_CLOSED": CifsTypeIds.roadClosed,
    "CONSTRUCTION": CifsTypeIds.construction,
  };
  return enumStrings[id] ?? CifsTypeIds.construction;
}

CifsSubTypeIds cifsSubTypeIdsStringToEnum(String id) {
  final Map<String, CifsSubTypeIds> enumStrings = {
    "ROAD_CLOSED_CONSTRUCTION": CifsSubTypeIds.roadClosedConstruction,
  };
  return enumStrings[id] ?? CifsSubTypeIds.roadClosedConstruction;
}
