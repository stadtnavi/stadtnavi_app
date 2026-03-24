import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart';
import 'custom_layer_local_storage.dart';
part 'custom_layers_state.dart';

class CustomLayersCubit extends Cubit<CustomLayersState> {
  final CustomLayerLocalStorage _localStorage = CustomLayerLocalStorage();
  final List<CustomLayerContainer> layersContainer;
  CustomLayersCubit(this.layersContainer)
      : super(
          CustomLayersState(
            layersStatus: layersContainer
                .fold<List<CustomLayer>>(
                    [],
                    (previousValue, element) =>
                        [...previousValue, ...element.layers])
                .asMap()
                .map((key, value) => MapEntry(value.id, value.isDefaultOn())),
            layers: layersContainer.fold<List<CustomLayer>>(
                [],
                (previousValue, element) =>
                    [...previousValue, ...element.layers]),
          ),
        ) {
    for (final CustomLayerContainer layerContainer in layersContainer) {
      for (final CustomLayer layer in layerContainer.layers) {
        layer.onRefresh = () {
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
    emit(state.copyWith(layersStatus: {...state.layersStatus, ...savedMap}));
  }

  void changeCustomMapLayerState({
    required CustomLayer customLayer,
    required bool newState,
  }) {
    final Map<String, bool> tempMap = Map.from(state.layersStatus);
    tempMap[customLayer.id] = newState;
    emit(state.copyWith(layersStatus: tempMap));
    _localStorage.save(state.layersStatus);
  }

  List<Type> getActiveLayersType() => state.layers
      .where((element) => state.layersStatus[element.id] ?? false)
      .map((value) => value.runtimeType)
      .toList();
  List<String> getActiveLayersCode() => state.layers
      .where((element) => state.layersStatus[element.id] ?? false)
      .map((value) => value.id)
      .toList();

  void changeCustomMapLayerContainerState({
    required CustomLayerContainer customLayer,
    required bool newState,
  }) {
    final Map<String, bool> tempMap = Map.from(state.layersStatus);
    for (final CustomLayer layer in customLayer.layers) {
      tempMap[layer.id] = newState;
    }

    emit(state.copyWith(layersStatus: tempMap));
    _localStorage.save(state.layersStatus);
  }

  /// Build TrufiLayers from all active custom layers at the given zoom.
  List<TrufiLayer> buildTrufiLayers(int zoom) {
    if (zoom <= 12) return [];

    final activeLayers = state.layers
        .where((element) => state.layersStatus[element.id] ?? false)
        .toList()
      ..sort((a, b) => a.weight.compareTo(b.weight));

    return activeLayers.map((layer) {
      return TrufiLayer(
        id: layer.id,
        markers: layer.buildTrufiMarkers(zoom),
        lines: layer.buildTrufiLines(zoom),
        layerLevel: layer.weight,
      );
    }).toList();
  }
}
