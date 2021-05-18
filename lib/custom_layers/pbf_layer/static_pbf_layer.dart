import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_layer.dart';

import 'parking/parkings_layer.dart';
import 'stops/stops_enum.dart';

final Map<StopsLayerIds, StopsLayer> stopsLayers = {
  StopsLayerIds.bus: StopsLayer(StopsLayerIds.bus),
  StopsLayerIds.rail: StopsLayer(StopsLayerIds.rail),
  StopsLayerIds.carpool: StopsLayer(StopsLayerIds.carpool),
};

final ParkingLayer parkingLayer = ParkingLayer("Parking");
