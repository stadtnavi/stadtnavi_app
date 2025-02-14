import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HBLayerData {
  static Map<String, MapLayerCategory> subCategoriesList = {};
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
          categories.add(_loadCategory(categoryData));
        }
        print("");
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading HB layers: $e');
    }
  }

  static MapLayerCategory _loadCategory(Map<String, dynamic> data) {
    final category = MapLayerCategory.fromJson(data);
    subCategoriesList[category.code] = category;

    if (data["categories"] != null) {
      for (final value in data["categories"]) {
        category.categories.add(_loadCategory(value));
      }
    }
    return category;
  }
}

class MapLayerCategory {
  final String code;
  final String en;
  final String de;
  final int? priority;
  final int? minZoom;
  final String icon;
  final String svgMenu;
  final String backgroundColor;
  // final String color;
  final bool enabledPerDefault;
  final List<MapLayerCategory> categories;

  MapLayerCategory({
    required this.code,
    required this.en,
    required this.de,
    required this.priority,
    required this.minZoom,
    required this.icon,
    required this.svgMenu,
    required this.backgroundColor,
    // required this.color,
    required this.enabledPerDefault,
    required this.categories,
  });

  factory MapLayerCategory.fromJson(Map<String, dynamic> json) {
    return MapLayerCategory(
      code: json['code'] ?? '',
      en: json['translations']?['en'] ?? 'Unknown',
      de: json['translations']?['de'] ?? 'Unknown',
      priority: json['properties']?['layer']?['priority'],
      minZoom: json['properties']?['layer']?['min_zoom'],
      icon: json['properties']?['icon']?['svg'] ?? "",
      svgMenu: json['properties']?['icon']?['svg_menu'] ?? "",
      backgroundColor: json['properties']?['icon']?['background_color'] ?? "",
      // color: json['properties']?['icon']?['color'] ?? "",
      enabledPerDefault:
          json['properties']?['layer']?['enabled_per_default'] ?? false,
      categories: [],
    );
  }
}
