import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/live_bus/live_bus_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/geojson_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/models/map_layer_category.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/carsharing_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/scooter/scooter_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/undefined_map_layer.dart';

/// Extension that adds the [toLayer] factory method to [MapLayerCategory].
///
/// Separated from the model to keep [MapLayerCategory] free of layer
/// implementation dependencies.
extension MapLayerCategoryFactory on MapLayerCategory {
  CustomLayer toLayer() {
    final realType =
        properties?.layerType ?? categories.first.properties?.layerType;
    if (realType == "otp_layer") {
      if (["rail", "subway", "bus", "funicular"].contains(code)) {
        return StopsLayer(this, 4);
      }
      if (code == "vehicles") {
        return LiveBusLayer(this, 3);
      }
      if (code == "parkAndRideForBikes") {
        return BikeParkLayer(this, 4);
      }

      if (code == "parkAndRide") {
        return ParkingLayer(this, 3);
      }

      if (code == "scooter") {
        return ScooterLayer(this, 3);
      }
      if (["car", "cargo_bicycle", "bicycle"].contains(code)) {
        return CarSharingLayer(this, 4);
      }
      if (code == "carpool") {
        return StopsLayer(this, 3);
      }
      if (code == "taxi") {
        return MapPoiLayer(this, 3);
      }
    }
    if (realType == "geojson_layer") {
      return GeojsonLayer(this, 3, url: properties?.layerUrl);
    }
    if (realType == "poi_layer") {
      return MapPoiLayer(this, 3);
    }
    if (realType == "wmst_layer") {
      if (code == "cycle_network") {
        return MapPoiLayer(this, 3);
      }
    }
    if (realType == "vector_tiles_layer") {
      if (code == "weatherStations") {
        return WeatherLayer(this, 3);
      }
      if (code == "roadworks") {
        return RoadworksLayer(this, 3);
      }
      if (code == "chargingStations") {
        return ChargingLayer(this, 4);
      }
    }

    return UndefinedMapLayer();
  }
}
