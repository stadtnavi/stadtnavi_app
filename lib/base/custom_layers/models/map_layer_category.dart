import 'package:stadtnavi_core/base/custom_layers/models/map_layer_properties.dart';

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
    if (json['properties'] != null && json["code"] == "school_route_map") {
      json['properties']?['layer']?['url'] =
          "https://data.mfdz.de/hbg/dt-layers/school_route_map.geojson";
    }
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

  bool isDefaultOn() {
    if (properties?.layerEnabledPerDefault == true) {
      return true;
    }

    for (var category in categories) {
      if (category.isDefaultOn()) {
        return true;
      }
    }
    return false;
  }
}
