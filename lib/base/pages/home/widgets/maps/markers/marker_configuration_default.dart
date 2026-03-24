part of 'marker_configuration.dart';

class DefaultMarkerConfiguration implements MarkerConfiguration {
  const DefaultMarkerConfiguration();

  @override
  Widget get fromMarker => const FromMarker();

  @override
  Widget get toMarker => const ToMarker();

  @override
  Widget get yourLocationMarker => const MyLocationMarker();

  @override
  TrufiMarker buildFromTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'from_marker_${point.latitude}_${point.longitude}',
      position: point,
      size: const Size(24, 24),
      alignment: Alignment.center,
      imageCacheKey: 'default_from_marker',
      widget: fromMarker,
    );
  }

  @override
  TrufiMarker buildToTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'to_marker_${point.latitude}_${point.longitude}',
      position: point,
      size: const Size(30, 30),
      alignment: Alignment.topCenter,
      imageCacheKey: 'default_to_marker',
      widget: toMarker,
    );
  }

  @override
  TrufiMarker buildYourLocationTrufiMarker(LatLng point) {
    return TrufiMarker(
      id: 'your_location_marker',
      position: point,
      size: const Size(50, 50),
      alignment: Alignment.center,
      imageCacheKey: 'default_your_location_marker',
      widget: const MyLocationMarker(),
    );
  }
}
