import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/icons_transport_modes.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'dash_line_place.dart';
import 'separator_place.dart';

class BikeParkDash extends StatelessWidget {
  final PlanItineraryLeg leg;
  final BikeParkEntity? bikePark;
  const BikeParkDash({Key? key, required this.leg, this.bikePark})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final bikerentalNetwork = getBikeRentalNetwork(
      leg.fromPlace?.bikeRentalStation?.networks?[0],
    );
    return Column(
      children: [
        DashLinePlace(
          date: leg.endTimeString.toString(),
          location:
              bikePark != null
                  ? localization.bikePark
                  : bikerentalNetwork.getTranslateTitle(localizationBase),
          subtitle: bikePark?.name ?? leg.toPlace?.name ?? '',
          color: leg.primaryColor,
          child: Column(
            children: [
              SizedBox(height: 18, width: 24, child: bikeParkingSvg),
              Container(width: 5, color: Colors.red),
            ],
          ),
        ),
        SeparatorPlace(
          color: leg.primaryColor,
          height: 10,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 19,
            width: 19,
            child: walkSvg,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              '${localizationBase.commonWalk} ${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})',
            ),
          ),
        ),
      ],
    );
  }
}
