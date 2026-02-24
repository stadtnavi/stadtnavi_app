import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stadtnavi_core/base/custom_layers/models/custom_marker_panel.dart';
export 'package:stadtnavi_core/base/custom_layers/models/custom_marker_panel.dart';
part 'panel_state.dart';

class PanelCubit extends Cubit<PanelState> {
  PanelCubit() : super(const PanelState());
  void setPanel(CustomMarkerPanel panel, {Marker? selectedMarker}) {
    // emit(const PanelState());
    Future.delayed(
      const Duration(milliseconds: 0),
      () => emit(
        state.isTransportPanel
            ? state.copyWith(modeTransportPanel: panel, selectedMarker: selectedMarker)
            : state.copyWith(panel: panel, selectedMarker: selectedMarker),
      ),
    );
  }

  void cleanPanel() {
    emit(
      state.isTransportPanel
          ? PanelState(
              panel: state.panel,
              isTransportPanel: state.isTransportPanel,
              selectedMarker: null,
            )
          : PanelState(
              modeTransportPanel: state.modeTransportPanel,
              isTransportPanel: state.isTransportPanel,
              selectedMarker: null,
            ),
    );
  }

  void changeTransportPanel(bool isTransportPanel) {
    emit(state.copyWith(isTransportPanel: isTransportPanel));
  }
}
