import 'package:flutter/material.dart';

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
    AbsoluteDirection.north: Icons.arrow_upward,
    AbsoluteDirection.northeast: Icons.arrow_upward,
    AbsoluteDirection.east: Icons.arrow_forward,
    AbsoluteDirection.southeast: Icons.arrow_downward,
    AbsoluteDirection.south: Icons.arrow_downward,
    AbsoluteDirection.southwest: Icons.arrow_downward,
    AbsoluteDirection.west: Icons.arrow_back,
    AbsoluteDirection.northwest: Icons.arrow_upward,
  };

  String get name => names[this] ?? 'NORTH';
  IconData get icon => icons[this] ?? Icons.help;
}