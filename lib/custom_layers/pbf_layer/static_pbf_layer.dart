import 'pbf_layer.dart';

enum PBFLayerIds {
  bus,
  carpool,
  rail,
}

extension LayerIdsToString on PBFLayerIds {
  String enumToString() {
    final Map<PBFLayerIds, String> enumStrings = {
      PBFLayerIds.bus: "Bus stops",
      PBFLayerIds.rail: "Train stations",
      PBFLayerIds.carpool: "Carpool stops",
    };
    return enumStrings[this];
  }
}

PBFLayerIds pbfLayerIdsstringToEnum(String id) {
  final Map<String, PBFLayerIds> enumStrings = {
    "BUS": PBFLayerIds.bus,
    "CARPOOL": PBFLayerIds.carpool,
    "RAIL": PBFLayerIds.rail,
  };
  return enumStrings[id];
}

final Map<PBFLayerIds, PBFLayer> pbfLayers = {
  PBFLayerIds.bus: PBFLayer(PBFLayerIds.bus),
  PBFLayerIds.rail: PBFLayer(PBFLayerIds.rail),
  PBFLayerIds.carpool: PBFLayer(PBFLayerIds.carpool),
};
