part of 'trufi_map_cubit.dart';

@immutable
class TrufiMapState extends Equatable {
  final List<TrufiMarker> unselectedMarkers;
  final List<TrufiLine> unselectedLines;
  final List<TrufiMarker> selectedMarkers;
  final List<TrufiLine> selectedLines;

  const TrufiMapState({
    this.unselectedMarkers = const [],
    this.unselectedLines = const [],
    this.selectedMarkers = const [],
    this.selectedLines = const [],
  });

  TrufiMapState copyWith({
    List<TrufiMarker>? unselectedMarkers,
    List<TrufiLine>? unselectedLines,
    List<TrufiMarker>? selectedMarkers,
    List<TrufiLine>? selectedLines,
  }) {
    return TrufiMapState(
      unselectedMarkers: unselectedMarkers ?? this.unselectedMarkers,
      unselectedLines: unselectedLines ?? this.unselectedLines,
      selectedMarkers: selectedMarkers ?? this.selectedMarkers,
      selectedLines: selectedLines ?? this.selectedLines,
    );
  }

  @override
  List<Object?> get props => [
        unselectedMarkers,
        unselectedLines,
        selectedMarkers,
        selectedLines,
      ];

  @override
  String toString() {
    return 'TrufiMapState: {}';
  }
}
