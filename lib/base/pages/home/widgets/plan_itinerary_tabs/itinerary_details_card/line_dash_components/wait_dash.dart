import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'dash_line_place.dart';
import 'separator_place.dart';

class WaitDash extends StatelessWidget {
  final PlanItineraryLeg legBefore;
  final PlanItineraryLeg legAfter;
  const WaitDash({Key? key, required this.legBefore, required this.legAfter})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    return Column(
      children: [
        if (legBefore.endTime.millisecondsSinceEpoch -
                legAfter.startTime.millisecondsSinceEpoch !=
            0)
          DashLinePlace(
            date: legBefore.endTimeString.toString(),
            location: legBefore.toPlace?.name ?? '',
            color: Colors.grey,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        SeparatorPlace(
          color: Colors.grey,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            height: 19,
            width: 19,
            child: waitSvg,
          ),
          height: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              "${localization.commonWait} (${localization.instructionDurationMinutes(legAfter.startTime.difference(legBefore.endTime).inMinutes)})",
            ),
          ),
        ),
      ],
    );
  }
}
