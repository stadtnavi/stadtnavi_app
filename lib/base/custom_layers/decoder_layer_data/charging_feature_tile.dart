import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_icons.dart';

class ChargingFeatureTile extends StatelessWidget {
  final ChargingFeature element;
  const ChargingFeatureTile({
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
            height: 30,
            width: 30,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.string(
              chargingIcon,
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                element.name ?? "",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
