import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'citybike_feature_model.dart';
import 'citybikes_enum.dart';
import 'citybikes_icon.dart';

extension CityBikeLayerIdsToString on CityBikeLayerIds {
  String enumToString({bool isEnglishCode = true}) {
    final Map<CityBikeLayerIds, String> enumStrings = {
      CityBikeLayerIds.carSharing:
          isEnglishCode ? "Car sharing station" : "Carsharing-Station",
      CityBikeLayerIds.regiorad:
          isEnglishCode ? "Bike rental station" : "Fahrradverleih",
      CityBikeLayerIds.taxi: isEnglishCode ? "Taxi rank" : "Taxistand",
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
    final languageCode = Localizations.localeOf(context).languageCode;
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
                  element.type
                      .enumToString(isEnglishCode: languageCode == 'en'),
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
