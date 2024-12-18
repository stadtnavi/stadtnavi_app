import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

abstract class HBLayerData {
  static Map<String, CategoryData> categoriesList = {};
  static Map<String, SubCategory> subCategoriesList = {};
  static Future<void> loadHbLayers() async {
    final String jsonString = await rootBundle
        .loadString('packages/stadtnavi_core/assets/hb-layers.json');
    final data = jsonDecode(jsonString);
    for (final categoryData in data) {
      _loadCategory(categoryData);
    }
  }

  static void _loadCategory(data) {
    final category = CategoryData.fromJson(data);
    categoriesList[category.code] = category;
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

class CategoryData {
  final String code;
  final String en;
  final String de;

  CategoryData({
    required this.code,
    required this.en,
    required this.de,
  });

  factory CategoryData.fromJson(json) {
    return CategoryData(
      code: json['code'],
      en: json['translations']['en'],
      de: json['translations']['de'],
    );
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
