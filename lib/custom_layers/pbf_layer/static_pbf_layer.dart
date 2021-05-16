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
      PBFLayerIds.carpool: "Carpool stops",
      PBFLayerIds.rail: "Train stations",
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
  PBFLayerIds.carpool: PBFLayer(PBFLayerIds.carpool),
  PBFLayerIds.rail: PBFLayer(PBFLayerIds.rail),
};