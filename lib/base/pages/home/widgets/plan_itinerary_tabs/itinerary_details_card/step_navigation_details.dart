import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/absolute_direction.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/relative_direction.dart';
import 'package:stadtnavi_core/base/models/step_entity.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class StepNavigationDetails extends StatelessWidget {
  final StepEntity step;
  final bool isFirst;
  final bool showNavigationIcon;

  const StepNavigationDetails({
    super.key,
    required this.step,
    required this.isFirst,
    this.showNavigationIcon=true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    final localizationST = StadtnaviBaseLocalization.of(context);

    String instruction = "";
    if (isFirst) {
      instruction = localizationST.legStepsStartInstructions(
          step.absoluteDirection?.translatesTitle(localizationST) ?? "",
          step.streetName ?? "");
    } else {
      instruction = step.relativeDirection?.translatesTitle(
            localizationST,
            step.streetName ?? "",
            exitNumber: step.exit ?? "",
          ) ??
          "";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          step.relativeDirection?.getImage() ?? Container(),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instruction,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  step.distanceString(localization),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          if(showNavigationIcon)
          SizedBox(
            width: 20,
            height: 20,
            child: showOnMapSvg(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
