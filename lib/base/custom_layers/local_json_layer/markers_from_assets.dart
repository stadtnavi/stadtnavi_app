import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'custom_marker_model.dart';

Future<List<CustomMarker>> markersFromAssets(String path) async {
  final List<CustomMarker> markers = [];
  final Map<String?, String> icons = {};
  final body = await rootBundle.loadString(path).then(
        (jsonStr) => jsonDecode(jsonStr),
      );
  final List features = body["features"] as List;
  for (final feature in features) {
    final properties = feature["properties"];
    final icon = properties["icon"];
    final iconId = icon["id"] as String?;
    final iconSvg = icon["svg"];
    if (iconSvg != null) {
      icons[iconId] = await getImgeCode(iconId, iconSvg as String);
    }
    final coordinate = feature["geometry"]["coordinates"];
    final position = LatLng(
      coordinate[1] as double,
      coordinate[0] as double,
    );
    markers.add(CustomMarker(
      id: properties["id"] as String?,
      position: position,
      image: icons[iconId] ?? getImage(iconId),
      name: properties["name"] as String?,
      nameEn: properties["name_en"] as String?,
      nameDe: properties["name_de"] as String?,
      popupContent: properties["popupContent"] as String?,
      popupContentEn: properties["popupContent_en"] as String?,
      popupContentDe: properties["popupContent_de"] as String?,
    ));
  }
  return markers;
}

Future<List<CustomMarker>> markersFromUrl(String path) async {
  final List<CustomMarker> markers = [];
  final Map<String?, String?> icons = {};
  final uri = Uri.parse(path);
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception(
      "Server Error ParkZone $uri with ${response.statusCode}",
    );
  }
  final body =
      jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true));
  final List features = body["features"] as List;
  for (final feature in features) {
    final properties = feature["properties"];
    final icon = properties["icon"];
    final iconId = icon["id"] as String?;
    final iconSvg = icon["svg"];
    if (iconSvg != null) {
      icons[iconId] = await getImgeCode(iconId, iconSvg as String);
    }
    final coordinate = feature["geometry"]["coordinates"];
    final position = LatLng(
      (coordinate[1] as num).toDouble(),
      (coordinate[0] as num).toDouble(),
    );
    markers.add(CustomMarker(
      id: properties["id"] as String?,
      position: position,
      image: icons[iconId] ?? getImage(iconId),
      name: properties["name"] as String?,
      nameEn: properties["name_en"] as String?,
      nameDe: properties["name_de"] as String?,
      popupContent: properties["popupContent"] as String?,
      popupContentEn: properties["popupContent_en"] as String?,
      popupContentDe: properties["popupContent_de"] as String?,
    ));
  }
  return markers;
}

Future<String> getImgeCode(String? iconId, String icon) async {
  if (icon.contains('<style')) {
    return mapIcons[iconId] ?? bikeRepIcon;
  } else {
    return icon;
  }
}

String getImage(String? iconId) {
  return mapIcons[iconId] ?? bikeShopIcon;
}

final mapIcons = {
  'bikeShopIcon': bikeShopIcon,
  'bikeRepIcon': bikeRepIcon,
};
const bikeShopIcon =
    '<svg xmlns="http://www.w3.org/2000/svg" data-name="Ebene 1" viewBox="0 0 32.53 32.53">  <path fill="#000001" d="M32.53 16.27A16.27 16.27 0 1116.24 0 16.26 16.26 0 0132.5 16.27"/>  <text fill="#fff" font-family="Interstate-Bold" font-size="7.1" font-weight="700" transform="translate(6.63 11.52)">    SHOP  </text>  <path fill="#fff" d="M18.9 16.66a1.47 1.47 0 01-1.05-.44 1.38 1.38 0 01-.46-1 1.57 1.57 0 011.51-1.51 1.39 1.39 0 011 .46 1.47 1.47 0 01.44 1 1.43 1.43 0 01-.44 1 1.45 1.45 0 01-1 .49zm-7.87 4.88a3.59 3.59 0 012.65 1.09 3.65 3.65 0 011.07 2.67 3.66 3.66 0 01-3.72 3.73 3.69 3.69 0 01-2.67-1.07 3.57 3.57 0 01-1.09-2.66 3.63 3.63 0 011.09-2.67 3.67 3.67 0 012.67-1.09zm0 6.36a2.58 2.58 0 002.6-2.6 2.56 2.56 0 00-.76-1.86 2.44 2.44 0 00-1.84-.77 2.5 2.5 0 00-1.86.77 2.54 2.54 0 00-.78 1.86 2.49 2.49 0 00.78 1.85 2.56 2.56 0 001.86.75zm4.32-7.48L17 22.14v4.64h-1.47v-3.73l-2.43-2.1a1.19 1.19 0 01-.42-1.06 1.42 1.42 0 01.42-1.05l2.11-2.11a1.19 1.19 0 011.06-.42 1.86 1.86 0 011.19.42l1.44 1.44a3.64 3.64 0 002.67 1.12v1.51a5.14 5.14 0 01-3.79-1.58l-.6-.59zm6.15 1.12a3.72 3.72 0 013.76 3.76 3.57 3.57 0 01-1.09 2.66 3.66 3.66 0 01-2.67 1.07 3.66 3.66 0 01-3.72-3.73 3.65 3.65 0 011.07-2.67 3.59 3.59 0 012.65-1.09zm0 6.36a2.56 2.56 0 001.86-.75 2.49 2.49 0 00.78-1.85 2.54 2.54 0 00-.78-1.86 2.5 2.5 0 00-1.86-.77 2.45 2.45 0 00-1.84.77 2.56 2.56 0 00-.76 1.86 2.58 2.58 0 002.6 2.6z/></svg>';
const bikeRepIcon =
    '<svg xmlns="http://www.w3.org/2000/svg" id="Ebene_1" data-name="Ebene 1" viewBox="0 0 32.53 32.54">    <path fill="#000001" d="M313.29 384.05A16.27 16.27 0 11297 367.78a16.27 16.27 0 0116.26 16.27" transform="translate(-280.76 -367.78)" />    <path d="M299.66 384.6a1.43 1.43 0 01-1.05-.44 1.35 1.35 0 01-.46-1 1.56 1.56 0 011.51-1.51 1.42 1.42 0 011 .45 1.51 1.51 0 01.44 1.06 1.5 1.5 0 01-1.48 1.47zm-7.87 4.89a3.55 3.55 0 012.65 1.09 3.62 3.62 0 011.07 2.67 3.66 3.66 0 01-3.72 3.72 3.65 3.65 0 01-2.67-1.07 3.55 3.55 0 01-1.09-2.65 3.72 3.72 0 013.76-3.76zm0 6.36a2.59 2.59 0 002.6-2.6 2.53 2.53 0 00-.76-1.86 2.45 2.45 0 00-1.84-.78 2.66 2.66 0 00-2.64 2.64 2.46 2.46 0 00.78 1.84 2.53 2.53 0 001.86.76zm4.32-7.49l1.65 1.73v4.63h-1.47V391l-2.43-2.11a1.18 1.18 0 01-.42-1.05 1.45 1.45 0 01.42-1.06l2.11-2.11a1.19 1.19 0 011.06-.42 1.86 1.86 0 011.19.42l1.44 1.45a3.68 3.68 0 002.67 1.12v1.51a5.18 5.18 0 01-3.79-1.58l-.6-.6zm6.15 1.13a3.72 3.72 0 013.76 3.76 3.55 3.55 0 01-1.09 2.65 3.62 3.62 0 01-2.67 1.07 3.66 3.66 0 01-3.72-3.72 3.62 3.62 0 011.07-2.67 3.55 3.55 0 012.65-1.09zm0 6.36a2.53 2.53 0 001.86-.76 2.46 2.46 0 00.78-1.84 2.66 2.66 0 00-2.64-2.64 2.46 2.46 0 00-1.84.78 2.53 2.53 0 00-.76 1.86 2.59 2.59 0 002.6 2.6zM304 374.92a.38.38 0 01.38.14.65.65 0 01.15.48v1.86a.51.51 0 01-.57.58h-7.4a3.46 3.46 0 01-1.34 1.58 3.67 3.67 0 01-2.07.61 3.79 3.79 0 01-2.22-.69 3.33 3.33 0 01-1.33-1.79h3.55v-2.44h-3.55a3.8 3.8 0 013.54-2.48 3.76 3.76 0 012.08.61 3.46 3.46 0 011.34 1.58z" fill="#fff" transform="translate(-280.76 -367.78)" /></svg>';
