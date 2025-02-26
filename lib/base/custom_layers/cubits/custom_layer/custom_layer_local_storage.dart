import 'dart:convert';
import 'package:hive/hive.dart';

class CustomLayerLocalStorage {
  static const String path = "custom_layers_storage";
  Future<bool> save(Map<String, bool> currentState) async {
    try {
      final _box = Hive.box(path);
      await _box.put(path, jsonEncode(currentState));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> load() async {
    final _box = Hive.box(path);
    final jsonString = _box.get(path);
    return jsonString != null
        ? (jsonDecode(jsonString) as Map<String, dynamic>?)?.map<String, bool>(
                (key, value) => MapEntry(key, value as bool)) ??
            {}
        : {};
  }
}
