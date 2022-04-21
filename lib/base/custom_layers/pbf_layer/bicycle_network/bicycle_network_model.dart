import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BicycleNetworkModel extends Equatable {
  final List<LatLng> coordinates;
  final Color color;
  final double weight;
  final String? dashArray;

  const BicycleNetworkModel({
    required this.coordinates,
    required this.color,
    required this.weight,
    this.dashArray,
  });

  BicycleNetworkModel copyWith({
    List<LatLng>? coordinates,
    Color? color,
    double? weight,
    String? dashArray,
  }) {
    return BicycleNetworkModel(
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
      weight: weight ?? this.weight,
      dashArray: dashArray ?? this.dashArray,
    );
  }

  factory BicycleNetworkModel.fromJson(Map<String, dynamic> map) {
    final codeColor = map['style']?['color']?.replaceAll('#', '0x');
    return BicycleNetworkModel(
      coordinates: List<LatLng>.from((map['geometry']?['coordinates'] ?? [])
          .map((x) => LatLng(x[1], x[0]))),
      color: Color(
        int.tryParse(codeColor) ?? 0xffffffff,
      ).withOpacity(
        map['style']?['opacity']?.toDouble() ?? 1.0,
      ),
      weight: map['style']?['weight']?.toDouble() ?? 0.0,
      dashArray: map['style']?['dashArray'],
    );
  }

  @override
  List<Object?> get props => [
        color,
        weight,
        dashArray,
      ];
}

class BicycleNetworkJoin {
  final List<List<LatLng>> coordinates;
  final Color color;
  final double weight;
  final String? dashArray;

  const BicycleNetworkJoin({
    required this.coordinates,
    required this.color,
    required this.weight,
    this.dashArray,
  });

  BicycleNetworkJoin copyWith({
    List<List<LatLng>>? coordinates,
    Color? color,
    double? weight,
    String? dashArray,
  }) {
    return BicycleNetworkJoin(
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
      weight: weight ?? this.weight,
      dashArray: dashArray ?? this.dashArray,
    );
  }
}

  // Color get backgroundColor {
  //   return route?.color != null
  //       ? Color(int.tryParse('0xFF${route?.color}')!)
  //       : transportMode.backgroundColor;
  // }

  // {
    //   "type": "Feature",
    //   "properties": { "FID": 351915, "ID_FÜHR_FOR": 5 },
    //   "geometry": {
    //     "type": "LineString",
    //     "coordinates": [
    //       [9.191657586332683, 48.89414286298559],
    //       [9.192786943634818, 48.89414958950941],
    //       [9.193926741738967, 48.89415370562495]
    //     ]
    //   },
    //   "style": { "color": "#ADE2B1", "opacity": 0.6, "weight": 3 }
    // },