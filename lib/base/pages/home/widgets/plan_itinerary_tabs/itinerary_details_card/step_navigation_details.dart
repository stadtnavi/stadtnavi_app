import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/relative_direction.dart';
import 'package:stadtnavi_core/base/models/step_entity.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class StepNavigationDetails extends StatelessWidget {
  final StepEntity step;

  const StepNavigationDetails({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    final localizationST = StadtnaviBaseLocalization.of(context);
    IconData icon = step.relativeDirection?.icon ?? Icons.help_outline;
    String instruction = _buildInstruction(step, localization, localizationST);
    List<Widget> subtitles = [
      Text(
        step.distanceString(localization),
        style: const TextStyle(fontSize: 12),
      ),
    ];

    if (step.walkingBike == true) {
      subtitles.add(Text(
        localizationST.commonWalkWithBicycle,
        style: const TextStyle(fontSize: 12),
      ));
    }

    // if (step.elevationProfile != null && step.elevationProfile!.isNotEmpty) {
    //   double elevationChange = (step.elevationProfile!.last.elevation ?? 0) -
    //       (step.elevationProfile!.first.elevation ?? 0);
    //   subtitles.add(
    //       Text('Cambio de elevación: ${elevationChange.toStringAsFixed(1)} m'));
    // }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.black),
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
                ...subtitles,
              ],
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.keyboard_arrow_right,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  String _buildInstruction(
    StepEntity step,
    TrufiBaseLocalization localization,
    StadtnaviBaseLocalization localizationST,
  ) {
    // if (step.bogusName == true ||
    //     step.streetName == null ||
    //     step.streetName!.isEmpty) {
    //   return '${localizationST.commonContinueFor} ${step.distanceString(localization)}';
    // }

    return step.relativeDirection != null
        ? step.relativeDirection!
            .translatesTitle(localizationST, step.streetName ?? "")
        : localizationST.commonContinue;
  }
}
