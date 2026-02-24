import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/models/map_layer_category.dart';

abstract class HBLayerData {
  static final List<MapLayerCategory> categories = [];

  static Future<void> loadHbLayers() async {
    const String url =
        'https://services.stadtnavi.eu/layer-categories/herrenberg/layers.json';
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (error) {
      throw Exception('Failed to load HBLayerData');
    }
    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedBody);
      for (final categoryData in data) {
        categories.add(MapLayerCategory.fromJson(categoryData));
      }
    } else {
      throw Exception('Failed to load HBLayerData: ${response.statusCode}');
    }
  }

  static MapLayerCategory? findCategoryRecursively(
    List<MapLayerCategory> categories,
    String codeToFind,
  ) {
    for (final category in categories) {
      if (category.code.toLowerCase() == codeToFind.toLowerCase()) {
        return category;
      }
      final foundInChildren =
          findCategoryRecursively(category.categories, codeToFind);
      if (foundInChildren != null) {
        return foundInChildren;
      }
    }
    return null;
  }
}
