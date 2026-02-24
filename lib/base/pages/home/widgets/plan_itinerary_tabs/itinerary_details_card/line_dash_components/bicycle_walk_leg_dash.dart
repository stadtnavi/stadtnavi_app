import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import 'transport_mode_extension.dart';

class BicycleWalkLegDash extends StatelessWidget {
  const BicycleWalkLegDash({
    super.key,
    required this.bicycleWalkLeg,
    required this.child,
  });
  final PlanItineraryLeg? bicycleWalkLeg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    final showAfterBicycleWalkLeg = bicycleWalkLeg?.toPlace?.stopEntity == null;

    final walkDash = Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            showAfterBicycleWalkLeg
                ? localizationST.bicycleWalkFromTransitNoDuration(
                  bicycleWalkLeg?.fromPlace?.stopEntity?.vehicleMode
                          ?.getSecondaryTranslate(localizationST) ??
                      "",
                )
                : localizationST.bicycleWalkToTransitNoDuration(
                  bicycleWalkLeg?.toPlace?.stopEntity?.vehicleMode
                          ?.getSecondaryTranslate(localizationST) ??
                      "",
                ),
          ),
          Positioned(
            left: -24,
            top: -5,
            child: Container(
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                height: 20,
                width: 20,
                child: bicycleWalkSvg(),
              ),
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bicycleWalkLeg != null && showAfterBicycleWalkLeg) walkDash,
        child,
        if (bicycleWalkLeg != null && !showAfterBicycleWalkLeg) walkDash,
      ],
    );
  }
}
