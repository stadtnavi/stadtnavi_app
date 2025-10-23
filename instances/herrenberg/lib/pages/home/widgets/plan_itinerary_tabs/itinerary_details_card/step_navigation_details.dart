import 'package:flutter/material.dart';
import 'package:trufi_core/extensions/stadtnavi_models/enums_plan/icons/other_icons.dart';
import 'package:trufi_core/extensions/translations-st/stadtnavi_base_localizations.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/models/enums/relative_direction.dart';
import 'package:trufi_core/models/step_entity.dart';
import 'package:trufi_core/extensions/stadtnavi/stadtnavi_extensions.dart';

class StepNavigationDetails extends StatelessWidget {
  final StepEntity step;
  final bool isFirst;
  final bool showNavigationIcon;

  const StepNavigationDetails({
    super.key,
    required this.step,
    required this.isFirst,
    this.showNavigationIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalization.of(context);
    final localizationST = StadtnaviBaseLocalization.of(context);

    String instruction = "";
    //TODO GT implement logic for translate
    // if (isFirst) {
    //   instruction = localizationST.legStepsStartInstructions(
    //     step.absoluteDirection?.translatesTitle(localizationST) ?? "",
    //     step.streetName ?? "",
    //   );
    // } else {
    //   instruction =
    //       step.relativeDirection?.translatesTitle(
    //         localizationST,
    //         step.streetName ?? "",
    //         exitNumber: step.exit ?? "",
    //       ) ??
    //       "";
    // }

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
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  step.distanceString(localization),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          if (showNavigationIcon)
            SizedBox(
              width: 20,
              height: 20,
              child: showOnMapSvg(color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
