part of 'panel_cubit.dart';

class PanelState extends Equatable {
  final CustomMarkerPanel? panel;
  final CustomMarkerPanel? modeTransportPanel;
  final bool isTransportPanel;
  final Marker? selectedMarker;

  const PanelState({
    this.panel,
    this.modeTransportPanel,
    this.isTransportPanel = false,
    this.selectedMarker,
  });

  PanelState copyWith({
    CustomMarkerPanel? panel,
    CustomMarkerPanel? modeTransportPanel,
    bool? isTransportPanel,
    Marker? selectedMarker,
  }) {
    return PanelState(
      panel: panel ?? this.panel,
      modeTransportPanel: modeTransportPanel ?? this.modeTransportPanel,
      isTransportPanel: isTransportPanel ?? this.isTransportPanel,
      selectedMarker: selectedMarker ?? this.selectedMarker,
    );
  }

  @override
  List<Object?> get props => [panel, modeTransportPanel, isTransportPanel, selectedMarker];
}
