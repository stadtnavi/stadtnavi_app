import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'citybike_feature_model.dart';
import 'citybikes_enum.dart';
import 'citybikes_icon.dart';

extension CityBikeLayerIdsToString on CityBikeLayerIds {
  String enumToString() {
    final Map<CityBikeLayerIds, String> enumStrings = {
      CityBikeLayerIds.carSharing: "Car sharing station",
      CityBikeLayerIds.regiorad: "Bike rental station",
      CityBikeLayerIds.taxi: "Taxi rank",
    };

    return enumStrings[this];
  }
}

class CitybikeMarkerModal extends StatelessWidget {
  final CityBikeFeature element;
  const CitybikeMarkerModal({Key key, @required this.element})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(
                  cityBikeIcons[element.type] ?? "",
                ),
              ),
              Expanded(
                child: Text(
                  element.id ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (element.type != null)
                Text(
                  element.type.enumToString(),
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
