part of 'panel_cubit.dart';

class PanelState extends Equatable {
  final CustomMarkerPanel? panel;
  final CustomMarkerPanel? modeTransportPanel;
  final bool isTransportPanel;

  const PanelState({
    this.panel,
    this.modeTransportPanel,
    this.isTransportPanel = false,
  });

  PanelState copyWith({
    CustomMarkerPanel? panel,
    CustomMarkerPanel? modeTransportPanel,
    bool? isTransportPanel,
  }) {
    return PanelState(
      panel: panel ?? this.panel,
      modeTransportPanel: modeTransportPanel ?? this.modeTransportPanel,
      isTransportPanel: isTransportPanel ?? this.isTransportPanel,
    );
  }

  @override
  List<Object?> get props => [panel, modeTransportPanel, isTransportPanel];
}

class CustomMarkerPanel extends Equatable {
  final Widget Function(
    BuildContext context,
    void Function() onFetchPlan, {
    bool? isOnlyDestination,
  }) panel;
  final LatLng position;
  final double minSize;

  const CustomMarkerPanel({
    required this.panel,
    required this.position,
    required this.minSize,
  });

  @override
  List<Object?> get props => [
        panel,
        position,
        minSize,
      ];
}
