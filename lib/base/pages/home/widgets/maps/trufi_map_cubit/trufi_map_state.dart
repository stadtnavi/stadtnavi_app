part of 'trufi_map_cubit.dart';

@immutable
class TrufiMapState extends Equatable {
  final MarkerLayer? unselectedMarkersLayer;
  final PolylineLayer? unselectedPolylinesLayer;
  final MarkerLayer? selectedMarkersLayer;
  final PolylineLayer? selectedPolylinesLayer;

  const TrufiMapState({
    this.unselectedMarkersLayer,
    this.unselectedPolylinesLayer,
    this.selectedMarkersLayer,
    this.selectedPolylinesLayer,
  });

  TrufiMapState copyWith({
    MarkerLayer? fromMarkerLayer,
    MarkerLayer? toMarkerLayer,
    MarkerLayer? unselectedMarkersLayer,
    PolylineLayer? unselectedPolylinesLayer,
    MarkerLayer? selectedMarkersLayer,
    PolylineLayer? selectedPolylinesLayer,
  }) {
    return TrufiMapState(
      unselectedMarkersLayer:
          unselectedMarkersLayer ?? this.unselectedMarkersLayer,
      unselectedPolylinesLayer:
          unselectedPolylinesLayer ?? this.unselectedPolylinesLayer,
      selectedMarkersLayer: selectedMarkersLayer ?? this.selectedMarkersLayer,
      selectedPolylinesLayer:
          selectedPolylinesLayer ?? this.selectedPolylinesLayer,
    );
  }

  @override
  List<Object?> get props => [
        unselectedMarkersLayer,
        unselectedPolylinesLayer,
        selectedMarkersLayer,
        selectedPolylinesLayer,
      ];

  @override
  String toString() {
    return 'TrufiMapState: {}';
  }
}
