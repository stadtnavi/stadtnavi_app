import 'package:flutter/material.dart';

import 'package:stadtnavi_app/configuration_service.dart';
import 'package:stadtnavi_app/custom_layers/map_layers/map_leyers.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:stadtnavi_app/custom_menu.dart';
import 'package:stadtnavi_app/custom_search_location/online_search_location.dart';
import 'package:stadtnavi_app/theme.dart';
import 'package:trufi_core/trufi_app.dart';
import 'custom_layers/services/graphl_client/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  // Run app
  runApp(
    TrufiApp(
      theme: stadtnaviTheme,
      bottomBarTheme: bottomBarTheme,
      configuration: setupTrufiConfiguration(),
      customLayers: customLayers,
      mapTileProviders: [
        MapLayer(MapLayerIds.streets),
        MapLayer(MapLayerIds.satellite),
        MapLayer(MapLayerIds.bike),
      ],
      searchLocationManager: OnlineSearchLocation(),
      menuItems: menuItems,
    ),
  );
}
