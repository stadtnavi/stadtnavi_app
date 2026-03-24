import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart'
    hide TrufiMapController, MapConfigurationCubit, cachedFirstFetch,
         MyLocationMarker, MarkerConfiguration, FromMarker, ToMarker;

import 'package:trufi_core/base/widgets/maps/markers/base_marker/from_marker.dart';
import 'package:trufi_core/base/widgets/maps/markers/base_marker/my_location_marker.dart';
import 'package:trufi_core/base/widgets/maps/markers/base_marker/to_marker.dart';

part 'marker_configuration_default.dart';

abstract class MarkerConfiguration {
  Widget get toMarker;
  Widget get fromMarker;
  Widget get yourLocationMarker;

  TrufiMarker buildToTrufiMarker(LatLng point);
  TrufiMarker buildFromTrufiMarker(LatLng point);
  TrufiMarker buildYourLocationTrufiMarker(LatLng point);
}
