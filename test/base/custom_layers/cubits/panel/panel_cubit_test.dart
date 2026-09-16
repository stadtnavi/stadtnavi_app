import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';

void main() {
  test('opening a panel without a marker clears the previous marker', () async {
    final cubit = PanelCubit();
    final firstMarker = Marker(
      point: const LatLng(48.59, 8.87),
      child: const SizedBox(),
    );
    final firstPanel = CustomMarkerPanel(
      panel: (context, onFetchPlan, {isOnlyDestination}) => const SizedBox(),
      position: const LatLng(48.59, 8.87),
      minSize: 50,
    );
    final secondPanel = CustomMarkerPanel(
      panel: (context, onFetchPlan, {isOnlyDestination}) => const SizedBox(),
      position: const LatLng(48.60, 8.88),
      minSize: 50,
    );

    cubit.setPanel(firstPanel, selectedMarker: firstMarker);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.selectedMarker, same(firstMarker));

    cubit.setPanel(secondPanel);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.panel, same(secondPanel));
    expect(cubit.state.selectedMarker, isNull);

    await cubit.close();
  });
}
