import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HBLayerData {
  static Map<String, SubCategory> subCategoriesList = {};
  static Future<void> loadHbLayers() async {
    const String url =
        'https://services.stadtnavi.eu/layer-categories/herrenberg/layers.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (final categoryData in data) {
          _loadCategory(categoryData);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading HB layers: $e');
    }
  }

  static void _loadCategory(data) {
    final category = SubCategory.fromJson(data);
    subCategoriesList[category.code] = category;
    for (final value in data["categories"]) {
      if (value["categories"] == null) {
        final subCategory = SubCategory.fromJson(value);
        subCategoriesList[subCategory.code] = subCategory;
      } else {
        _loadCategory(value);
      }
    }
  }
}

class SubCategory {
  final String code;
  final String en;
  final String de;
  final int? priority;
  final int? minZoom;
  final String icon;
  final String backgroundColor;
  final String color;

  SubCategory({
    required this.code,
    required this.en,
    required this.de,
    required this.priority,
    required this.minZoom,
    required this.icon,
    required this.backgroundColor,
    required this.color,
  });

  factory SubCategory.fromJson(json) {
    return SubCategory(
      code: json['code'],
      en: json['translations']['en'],
      de: json['translations']['de'],
      priority: json['properties']?['layer']['priority'],
      minZoom: json['properties']?['layer']['min_zoom'],
      icon: json['properties']?['icon']['svg'] ?? "",
      backgroundColor: json['properties']?['icon']['background_color'] ?? "",
      color: json['properties']?['icon']['color'] ?? "",
    );
  }
}
