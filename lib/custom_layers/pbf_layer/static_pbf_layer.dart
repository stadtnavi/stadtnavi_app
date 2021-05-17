import './stop_map/pbf_stops_layer.dart';
import 'hb_parking_map/pbf_hb_parking_layer.dart';
import 'hb_parking_map/pbf_stops_enum.dart';
import 'stop_map/pbf_stops_enum.dart';

final Map<PBFStopsLayerIds, PBFStopsLayer> pbfStopsLayers = {
  PBFStopsLayerIds.bus: PBFStopsLayer(PBFStopsLayerIds.bus),
  PBFStopsLayerIds.rail: PBFStopsLayer(PBFStopsLayerIds.rail),
  PBFStopsLayerIds.carpool: PBFStopsLayer(PBFStopsLayerIds.carpool),
};

final Map<PBFParkingLayerIds, PBFParkingLayer> pbfParkingLayers = {
  PBFParkingLayerIds.parkingGarage: PBFParkingLayer(
    PBFParkingLayerIds.parkingGarage,
  ),
  PBFParkingLayerIds.parkingSpot: PBFParkingLayer(
    PBFParkingLayerIds.parkingSpot,
  ),
  PBFParkingLayerIds.rvParking: PBFParkingLayer(
    PBFParkingLayerIds.rvParking,
  ),
  PBFParkingLayerIds.parkRide: PBFParkingLayer(
    PBFParkingLayerIds.parkRide,
  ),
  PBFParkingLayerIds.undergroundCarPark: PBFParkingLayer(
    PBFParkingLayerIds.undergroundCarPark,
  ),
  PBFParkingLayerIds.barrierFreeParkingSpace: PBFParkingLayer(
    PBFParkingLayerIds.barrierFreeParkingSpace,
  ),
  PBFParkingLayerIds.parkCarpool: PBFParkingLayer(
    PBFParkingLayerIds.parkCarpool,
  ),
};
