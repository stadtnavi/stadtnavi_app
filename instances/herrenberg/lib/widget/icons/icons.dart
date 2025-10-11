import 'package:de_stadtnavi_herrenberg_internal/widget/icons/stadtnavi_icons.dart';
import 'package:flutter/material.dart';

Widget typeToIconDataStadtnavi(
  String? type, {
  Color? color,
  double? size,
}) {
  Widget? icon;
  IconData? iconData;
  switch (type ?? '') {
    case 'amenity:bar':
    case 'amenity:pub':
    case 'amenity:biergarten':
    case 'amenity:nightclub':
      iconData = Icons.local_bar;
      break;
    default:
      icon = StadtnaviIcons.getById(type) ?? Icon(Icons.place, color: color);
  }
  return iconData != null
      ? Icon(iconData, color: color)
      : SizedBox(
          width: 24,
          height: 24,
          child: icon!,
        );
}
