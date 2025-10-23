import 'package:de_stadtnavi_herrenberg_internal/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/duration_component.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/walk_distance.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/models/enums/custom_icons.dart';
import 'package:trufi_core/models/plan_entity.dart';
import 'package:trufi_core/extensions/stadtnavi/stadtnavi_extensions.dart';

class BarItineraryDetails extends StatelessWidget {
  final PlanItinerary itinerary;
  const BarItineraryDetails({Key? key, required this.itinerary})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalization.of(context);
    return Container(
      height: itinerary.startDateText(localization) == '' ? 40 : 54,
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DurationComponent(
            duration: itinerary.duration,
            startTime: itinerary.startTime,
            endTime: itinerary.endTime,
            futureText: itinerary.startDateText(localization),
          ),
          Row(
            children: [
              if (itinerary.walkDistance > 0)
                WalkDistance(
                  walkDistance: itinerary.totalWalkingDistance,
                  walkDuration: itinerary.totalWalkingDuration,
                  icon: walkIcon(color: theme.iconTheme.color),
                ),
              const SizedBox(width: 10),
              if (itinerary.totalBikingDistance > 0)
                WalkDistance(
                  walkDistance: itinerary.totalBikingDistance,
                  walkDuration: itinerary.totalBikingDuration,
                  icon: bikeIcon(color: theme.iconTheme.color),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
