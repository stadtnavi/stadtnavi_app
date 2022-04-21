import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking_zones/parking_zones_model.dart';

class ParkingZoneModal extends StatelessWidget {
  final ParkingZoneMarkerModel element;
  const ParkingZoneModal({
    Key? key,
    required this.element,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Text(
          element.popupContent,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
