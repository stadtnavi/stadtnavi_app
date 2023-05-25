import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/configuration/icons.dart';

class StopFeatureTile extends StatelessWidget {
  final StopFeature element;

  const StopFeatureTile({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (element.type != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 13),
              child: typeToIconDataStadtnavi(
                stopsLayerIdsEnumToString(element.type!),
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                element.name ?? '',
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
