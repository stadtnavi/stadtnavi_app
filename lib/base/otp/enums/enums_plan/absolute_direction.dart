import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

enum AbsoluteDirection {
  north,
  northeast,
  east,
  southeast,
  south,
  southwest,
  west,
  northwest,
}

AbsoluteDirection getAbsoluteDirectionByString(String direction) {
  return CompassDirectionExtension.names.keys.firstWhere(
    (key) => key.name == direction,
    orElse: () => AbsoluteDirection.north,
  );
}

extension CompassDirectionExtension on AbsoluteDirection {
  static const names = <AbsoluteDirection, String>{
    AbsoluteDirection.north: 'NORTH',
    AbsoluteDirection.northeast: 'NORTHEAST',
    AbsoluteDirection.east: 'EAST',
    AbsoluteDirection.southeast: 'SOUTHEAST',
    AbsoluteDirection.south: 'SOUTH',
    AbsoluteDirection.southwest: 'SOUTHWEST',
    AbsoluteDirection.west: 'WEST',
    AbsoluteDirection.northwest: 'NORTHWEST',
  };

  static const icons = <AbsoluteDirection, IconData>{
    AbsoluteDirection.north: Icons.north,
    AbsoluteDirection.northeast: Icons.north_east,
    AbsoluteDirection.east: Icons.east,
    AbsoluteDirection.southeast: Icons.south_east,
    AbsoluteDirection.south: Icons.south,
    AbsoluteDirection.southwest: Icons.south_west,
    AbsoluteDirection.west: Icons.west,
    AbsoluteDirection.northwest: Icons.north_west,
  };
  String translatesTitle(StadtnaviBaseLocalization localization) {
    return {
          AbsoluteDirection.north: localization.absoluteDirectionNorth,
          AbsoluteDirection.northeast: localization.absoluteDirectionNortheast,
          AbsoluteDirection.east: localization.absoluteDirectionEast,
          AbsoluteDirection.southeast: localization.absoluteDirectionSoutheast,
          AbsoluteDirection.south: localization.absoluteDirectionSouth,
          AbsoluteDirection.southwest: localization.absoluteDirectionSouthwest,
          AbsoluteDirection.west: localization.absoluteDirectionWest,
          AbsoluteDirection.northwest: localization.absoluteDirectionNorthwest,
        }[this] ??
        'errorType';
  }

  String get name => names[this] ?? 'NORTH';
  IconData get icon => icons[this] ?? Icons.help;
}
