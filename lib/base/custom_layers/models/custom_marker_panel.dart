import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CustomMarkerPanel extends Equatable {
  final Widget Function(
    BuildContext context,
    void Function() onFetchPlan, {
    bool? isOnlyDestination,
  }) panel;
  final LatLng position;
  final double minSize;

  const CustomMarkerPanel({
    required this.panel,
    required this.position,
    required this.minSize,
  });

  @override
  List<Object?> get props => [
        panel,
        position,
        minSize,
      ];
}
