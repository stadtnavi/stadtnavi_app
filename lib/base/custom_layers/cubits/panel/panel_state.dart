part of 'panel_cubit.dart';

class PanelState extends Equatable {
  final CustomMarkerPanel? panel;

  const PanelState({
    this.panel,
  });
  @override
  List<Object?> get props => [panel];
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
