import 'package:flutter/material.dart';

import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/widgets/utils/date_time_utils.dart';
import 'package:trufi_core/widgets/utils/leg_utils.dart';

class WalkDistance extends StatelessWidget {
  final double walkDistance;
  final Duration walkDuration;
  final Widget icon;

  const WalkDistance({
    Key? key,
    required this.walkDistance,
    required this.walkDuration,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(6),
          width: 24,
          height: 24,
          child: icon,
        ),
        const SizedBox(width: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTimeUtils.durationToStringMinutes(walkDuration),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              ItineraryLegUtils.distanceWithTranslation(
                walkDistance,
                localization,
              ),
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
