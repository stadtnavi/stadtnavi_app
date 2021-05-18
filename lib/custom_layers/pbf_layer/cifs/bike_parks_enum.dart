enum CifsTypeIds {
  roadClosed,
}
enum CifsSubTypeIds {
  roadClosedConstruction,
}
CifsTypeIds cifsTypeIdsStringToEnum(String id) {
  final Map<String, CifsTypeIds> enumStrings = {
    "ROAD_CLOSED": CifsTypeIds.roadClosed,
  };
  return enumStrings[id];
}

CifsSubTypeIds cifsSubTypeIdsStringToEnum(String id) {
  final Map<String, CifsSubTypeIds> enumStrings = {
    "ROAD_CLOSED_CONSTRUCTION": CifsSubTypeIds.roadClosedConstruction,
  };
  return enumStrings[id];
}
