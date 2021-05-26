import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'charging_feature_model.dart';
import 'charging_icons.dart';

class ChargingMarkerModal extends StatelessWidget {
  final ChargingFeature element;
  const ChargingMarkerModal({Key key, @required this.element})
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
                  chargingIcon,
                ),
              ),
              Expanded(
                child: Text(
                  element.name ?? "",
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
              if (element.id != null)
                Text(
                  "id: ${element.id}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (element.c != null)
                Text(
                  "c: ${element.c}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (element.ca != null)
                Text(
                  "ca: ${element.ca}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (element.tb != null)
                Text(
                  "tb: ${element.tb}",
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
