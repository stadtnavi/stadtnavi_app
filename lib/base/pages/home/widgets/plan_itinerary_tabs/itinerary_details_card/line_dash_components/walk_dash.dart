import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'separator_place.dart';

class WalkDash extends StatelessWidget {
  final PlanItineraryLeg leg;
  final MoveInMap moveInMap;
  const WalkDash({Key? key, required this.leg, required this.moveInMap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    return Column(
      children: [
        SeparatorPlace(
          color: leg.primaryColor,
          height: 10,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 19,
            width: 19,
            child: walkSvg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leg.steps != null && leg.steps!.isNotEmpty)
                ExpansionTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Text(
                    '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})',
                    style: const TextStyle(fontSize: 14),
                  ),
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  textColor: theme.colorScheme.onSurface,
                  collapsedTextColor: theme.colorScheme.onSurface,
                  iconColor: theme.primaryColor,
                  collapsedIconColor: theme.primaryColor,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                  children:
                      leg.steps!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;

                        return InkWell(
                          onTap: () {
                            if (step.lat != null && step.lon != null) {
                              moveInMap(LatLng(step.lat!, step.lon!), zoom: 18);
                            }
                          },
                          child: StepNavigationDetails(
                            step: step,
                            isFirst: index == 0,
                          ),
                        );
                      }).toList(),
                )
              else
                Text(
                  '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
