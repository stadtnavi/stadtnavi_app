import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:flutter_map/flutter_map.dart';
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
    emit(state.copyWith(layersStatus: {...state.layersStatus, ...savedMap}));
  }

  void changeCustomMapLayerState({
    required CustomLayer customLayer,
    required bool newState,
  }) {
    final Map<String, bool> tempMap = Map.from(state.layersStatus);
    tempMap[customLayer.id] = newState;
    // switch (customLayer.id) {
    //   case 'Bicycle Network Space':
    //     StaticTileLayers.bicycleNetworkLayer.load();
    //     break;
    //   case 'Parking Zones':
    //     StaticTileLayers.parkingZonesLayer.load();
    //     break;
    //   default:
    // }
    // LayerIds.values.forEach(((id) {
    //   if (id.enumString == customLayer.id) {
    //     (customLayer as Layer).load();
    //   }
    // }));

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

  List<Marker> markers(
    int zoom,
  ) {
    List<CustomLayer> listSort = state.layers
        .where((element) => state.layersStatus[element.id] ?? false)
        .toList();

    listSort.sort((a, b) => a.weight.compareTo(b.weight));
    final allList = listSort.map((element) {
      return element.buildClusterMarkers(zoom);
    }).toList();
    return allList.expand((list) => list ?? <Marker>[]).toList();
  }

  List<Widget> activeCustomLayers(
    int zoom,
    List<Widget> layersMid, {
    required Widget layersUnderMid,
    String? showLayerById,
  }) {
    List<CustomLayer> listSort = state.layers;
    if (showLayerById != null) {
      listSort =
          listSort.where((element) => element.id == showLayerById).toList();
    } else {
      listSort = state.layers
          .where((element) => state.layersStatus[element.id] ?? false)
          .toList();
    }

    listSort.sort((a, b) => a.weight.compareTo(b.weight));

    List<Widget> listPriority = [];
    Widget? layer;
    for (CustomLayer customL in listSort) {
      layer = customL.buildOverlapLayer(zoom);
      if (layer != null) {
        listPriority.add(layer);
      }
    }

    List<Widget> listBackground = [];
    Widget? layerBackground;
    for (CustomLayer customL in listSort) {
      layerBackground = customL.buildAreaLayer(zoom);
      if (layerBackground != null) {
        listBackground.add(layerBackground);
      }
    }
    return zoom > 12
        ? [
            ...listBackground,
            ...layersMid,
            ...listSort
                .map((element) => element.buildMarkerLayer(zoom))
                .toList(),
            layersUnderMid,
            ...listPriority,
          ]
        : layersMid;
  }
}
