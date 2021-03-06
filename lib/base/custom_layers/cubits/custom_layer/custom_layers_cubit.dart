import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'custom_layer_local_storage.dart';
part 'custom_layers_state.dart';

class CustomLayersCubit extends Cubit<CustomLayersState> {
  final CustomLayerLocalStorage _localStorage = CustomLayerLocalStorage();
  final List<CustomLayerContainer> layersContainer;
  CustomLayersCubit(this.layersContainer)
      : super(
          CustomLayersState(
            layersSatus: layersContainer
                .fold<List<CustomLayer>>(
                    [],
                    (previousValue, element) =>
                        [...previousValue, ...element.layers])
                .asMap()
                .map((key, value) => MapEntry(value.id, true)),
            layers: layersContainer.fold<List<CustomLayer>>(
                [],
                (previousValue, element) =>
                    [...previousValue, ...element.layers]),
          ),
        ) {
    for (final CustomLayerContainer layerContainer in layersContainer) {
      for (final CustomLayer layer in layerContainer.layers) {
        layer.onRefresh = () {
          // TODO: improve state refresh
          final tempLayers = state.layers;
          emit(state.copyWith(layers: []));
          emit(state.copyWith(layers: tempLayers));
        };
      }
    }
    _loadSavedStatus();
  }
  Future<void> _loadSavedStatus() async {
    final savedMap = await _localStorage.load();
    emit(state.copyWith(layersSatus: {...state.layersSatus, ...savedMap}));
  }

  void changeCustomMapLayerState({
    required CustomLayer customLayer,
    required bool newState,
  }) {
    final Map<String, bool> tempMap = Map.from(state.layersSatus);
    tempMap[customLayer.id] = newState;
    switch (customLayer.id) {
      case 'Bicycle Network Space':
        StaticTileLayers.bicycleNetworkLayer.load();
        break;
      case 'Parking Zones':
        StaticTileLayers.parkingZonesLayer.load();
        break;
      default:
    }
    LayerIds.values.forEach(((id) {
      if (id.enumString == customLayer.id) {
        (customLayer as Layer).load();
      }
    }));

    emit(state.copyWith(layersSatus: tempMap));
    _localStorage.save(state.layersSatus);
  }

  void changeCustomMapLayerContainerState({
    required CustomLayerContainer customLayer,
    required bool newState,
  }) {
    final Map<String, bool> tempMap = Map.from(state.layersSatus);
    for (final CustomLayer layer in customLayer.layers) {
      tempMap[layer.id] = newState;
    }

    emit(state.copyWith(layersSatus: tempMap));
    _localStorage.save(state.layersSatus);
  }

  List<LayerOptions> activeCustomLayers(int zoom) {
    final listSort = state.layers
        .where((element) => state.layersSatus[element.id] ?? false)
        .toList();
    listSort.sort((a, b) => a.weight.compareTo(b.weight));
    List<LayerOptions> list = [];
    LayerOptions? layer;
    for (CustomLayer customL in listSort) {
      layer = customL.buildLayerOptionsPriority(zoom);
      if (layer != null) {
        list.add(layer);
      }
    }

    return zoom > 12
        ? [
            ...listSort
                .map((element) => element.buildLayerOptions(zoom))
                .toList(),
            ...list,
          ]
        : [];
  }
}
