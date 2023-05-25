import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';

class ParkingFeatureTile extends StatelessWidget {
  final ParkingFeature element;
  const ParkingFeatureTile({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.string(
              parkingMarkerIcons[element.type] ?? "",
            ),
          ),
          Expanded(
            child: Text(
              element.name ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
