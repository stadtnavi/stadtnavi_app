import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/live_bus/live_bus_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/geojson_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/cifs/cifs_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';

abstract class HBLayerData {
  static Map<String, MapLayerCategory> categoriesMapDetails = {};
  static final List<MapLayerCategory> categories = [];

  static Future<void> loadHbLayers() async {
    const String url =
        'https://services.stadtnavi.eu/layer-categories/herrenberg/layers.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedBody);
        for (final categoryData in data) {
          categories.add(MapLayerCategory.fromJson(categoryData));
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading HB layers: $e');
    }
  }
}

class MapLayerProperties {
  final String? layerType;
  final String? layerUrl;
  final int? layerPriority;
  final int? layerMinZoom;
  final bool? layerEnabledPerDefault;

  final String? iconSvg;
  final String? iconSvgMenu;
  final String? iconOrigin;
  final String? iconBackgroundColor;
  final String? iconColor;

  MapLayerProperties({
    this.layerType,
    this.layerUrl,
    this.layerPriority,
    this.layerMinZoom,
    this.layerEnabledPerDefault,
    this.iconSvg,
    this.iconSvgMenu,
    this.iconOrigin,
    this.iconBackgroundColor,
    this.iconColor,
  });

  factory MapLayerProperties.fromJson(json) {
    final layerMap = json['layer'];
    final iconMap = json['icon'];

    return MapLayerProperties(
      // Campos de "layer"
      layerType: layerMap?['type'],
      layerUrl: layerMap?['url'],
      layerPriority: layerMap?['priority'],
      layerMinZoom: layerMap?['min_zoom'],
      layerEnabledPerDefault: layerMap?['enabled_per_default'],

      // Campos de "icon"
      iconSvg: iconMap?['svg'],
      iconSvgMenu: iconMap?['svg_menu'],
      iconOrigin: iconMap?['origin'],
      iconBackgroundColor: iconMap?['background_color'],
      iconColor: iconMap?['color'],
    );
  }
}

class MapLayerCategory {
  final String code;
  final String en;
  final String de;
  final List<MapLayerCategory> categories;
  final MapLayerProperties? properties;

  MapLayerCategory({
    required this.code,
    required this.en,
    required this.de,
    required this.categories,
    this.properties,
  });

  factory MapLayerCategory.fromJson(Map<String, dynamic> json) {
    return MapLayerCategory(
      code: json['code'],
      en: json['translations']?['en'] ?? 'Unknown',
      de: json['translations']?['de'] ?? 'Unknown',
      categories: json['categories'] == null
          ? []
          : (json['categories'] as List)
              .map((cat) => MapLayerCategory.fromJson(cat))
              .toList(),
      properties: json['properties'] == null
          ? null
          : MapLayerProperties.fromJson(json['properties']),
    );
  }
  static MapLayerCategory? findCategoryWithProperties(
    MapLayerCategory category,
    String codeToFind,
  ) {
    if (category.code == codeToFind && category.properties != null) {
      return category;
    }
    for (final subcategory in category.categories) {
      final result = findCategoryWithProperties(subcategory, codeToFind);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  CustomLayer toLayer() {
    final realType =
        properties?.layerType ?? categories.first.properties?.layerType;
    if (realType == "otp_layer") {
      final whiteList = ["rail", "subway", "bus", "funicular"];
      if (whiteList.contains(code)) return StopsLayer(this, 4);
      if (code == "vehicles") {
        return LiveBusLayer(this, 3);
      }
      if (code == "parkAndRideForBikes") {
        return BikeParkLayer(this, 4);
      }

      if (code == "parkAndRide") {
        return ParkingLayer(this, 3);
      }

      if (code == "scooter") {
        return MapPoiLayer(this, 3);
      }
      if (code == "cargo_bicycle") {
        return MapPoiLayer(this, 3);
      }
      if (code == "bicycle") {
        return CityBikesLayer(this, 5);
      }
      if (code == "car") {
        return MapPoiLayer(this, 3);
      }
      if (code == "carpool") {
        return StopsLayer(this, 3);
      }
      if (code == "taxi") {
        return MapPoiLayer(this, 3);
      }
    }
    if (realType == "geojson_layer") {
      return GeojsonLayer(this, 3, url: properties?.layerUrl);
    }
    if (realType == "poi_layer") {
      return MapPoiLayer(this, 3);
    }
    if (realType == "wmst_layer") {
      if (code == "cycle_network") {
        return MapPoiLayer(this, 3);
      }
    }
    if (realType == "vector_tiles_layer") {
      if (code == "weatherStations") {
        return WeatherLayer(this, 3);
      }
      if (code == "roadworks") {
        return RoadworksLayer(this, 3);
      }
      if (code == "chargingStations") {
        return ChargingLayer(this, 4);
      }
    }

    return UndefinedMapLayer();
  }
}

class UndefinedMapLayer extends CustomLayer {
  UndefinedMapLayer() : super("UndefinedMapLayer", 1);

  @override
  Widget buildMarkerLayer(int zoom) {
    return const Icon(Icons.error, color: Colors.red);
  }

  @override
  Widget icon(BuildContext context) {
    return const Icon(
      Icons.error,
      color: Colors.red,
    );
  }

  @override
  String name(BuildContext context) {
    return "TODO: implement name";
  }
}
