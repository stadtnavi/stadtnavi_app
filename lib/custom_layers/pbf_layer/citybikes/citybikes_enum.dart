enum CityBikeLayerIds {
  carSharing,
  regiorad,
  taxi,
}

CityBikeLayerIds cityBikeLayerIdStringToEnum(String id) {
  final Map<String, CityBikeLayerIds> enumStrings = {
    "car-sharing": CityBikeLayerIds.carSharing,
    "regiorad": CityBikeLayerIds.regiorad,
    "taxi": CityBikeLayerIds.taxi,
  };
  return enumStrings[id];
}
