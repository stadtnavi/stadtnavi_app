part of 'custom_layers_cubit.dart';

class CustomLayersState extends Equatable {
  final Map<String, bool> layersStatus;
  final List<CustomLayer> layers;
  const CustomLayersState({
    required this.layersStatus,
    required this.layers,
  });

  CustomLayersState copyWith({
    Map<String, bool>? layersStatus,
    List<CustomLayer>? layers,
    Widget? layer,
  }) {
    return CustomLayersState(
      layersStatus: layersStatus ?? this.layersStatus,
      layers: layers ?? this.layers,
    );
  }

  @override
  List<Object?> get props => [
        layersStatus,
        layers,
      ];
}
