import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'bicycle_walk_leg_dash.dart';
import 'dash_line_place.dart';
import 'separator_place.dart';

class BicycleDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final PlanItineraryLeg? bicycleWalkLeg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final MoveInMap moveInMap;

  const BicycleDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.bicycleWalkLeg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final isTypeBikeRentalNetwork =
        leg.transportMode == TransportMode.bicycle &&
        leg.fromPlace?.bikeRentalStation != null;
    final distance = leg.distanceString(localizationBase);
    final duration = leg.durationLeg(localizationBase);
    final bikerentalNetwork = getBikeRentalNetwork(
      leg.fromPlace?.bikeRentalStation?.networks?[0],
    );
    final isScooter =
        isTypeBikeRentalNetwork
            ? bikerentalNetwork == BikeRentalNetwork.scooter
            : false;

    final isSimpleBicycle =
        (leg.mode != 'BICYCLE_WALK') && isTypeBikeRentalNetwork;
    final stopsDescription =
        localization.localeName == 'en'
            ? leg.mode == 'BICYCLE_WALK'
                ? (isScooter
                    ? 'Walk your kick scooter $duration ($distance)'
                    : 'Walk your bike $duration ($distance)')
                : (isScooter
                    ? 'Ride your kick scooter $duration ($distance)'
                    : 'Cycle $duration ($distance)')
            : leg.mode == 'BICYCLE_WALK'
            ? (isScooter
                ? 'Scooter $distance schieben ($duration)'
                : 'Fahrrad schieben: $duration ($distance)')
            : (isScooter
                ? 'Scooter $distance fahren ($duration)'
                : 'Radfahren: $duration ($distance)');
    final isAvailibleBikes =
        leg.fromPlace?.bikeRentalStation?.bikesAvailable ?? 0;
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            location: bikerentalNetwork.getTranslateTitle(localizationBase),
            color: BikeRentalNetwork.cargoBike.color,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: BikeRentalNetwork.cargoBike.color,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
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
          color:
              isSimpleBicycle
                  ? BikeRentalNetwork.cargoBike.color
                  : Colors.grey[400],
          separator: null,
          child: GestureDetector(
            onTap: () {
              if (leg.fromPlace != null) {
                moveInMap(LatLng(leg.fromPlace!.lat, leg.fromPlace!.lon));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 0),
                if (isSimpleBicycle)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          leg.fromPlace?.name != null &&
                                  leg.fromPlace!.name.isNotEmpty
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  isTypeBikeRentalNetwork
                                      ? bikerentalNetwork.image
                                      : null,
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color:
                                      isAvailibleBikes == 0
                                          ? const Color(0xffDC0451)
                                          : (isAvailibleBikes > 3
                                              ? const Color(0xff3B7F00)
                                              : const Color(0xffFCBC19)),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FittedBox(
                                      child: Text(
                                        isAvailibleBikes.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 5),
                            child:
                                isTypeBikeRentalNetwork
                                    ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          leg.fromPlace?.name != null &&
                                                  leg.fromPlace!.name.isNotEmpty
                                              ? leg.fromPlace!.name
                                              : bikerentalNetwork.getTranslate(
                                                localizationBase,
                                              ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (leg.fromPlace?.name != null &&
                                            leg.fromPlace!.name.isNotEmpty)
                                          Text(
                                            localization.bikeRentalBikeStation,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                      ],
                                    )
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isTypeBikeRentalNetwork &&
                    (itinerary.arrivedAtDestinationWithRentedBicycle))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InfoMessage(
                      message: localization.bikeRentalNetworkFreeFloating,
                    ),
                  ),
                BicycleWalkLegDash(
                  bicycleWalkLeg: bicycleWalkLeg,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if ((leg.steps != null && leg.steps!.isNotEmpty))
                        ExpansionTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            stopsDescription,
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
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          children:
                              leg.steps!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final step = entry.value;

                                return InkWell(
                                  onTap: () {
                                    if (step.lat != null && step.lon != null) {
                                      moveInMap(
                                        LatLng(step.lat!, step.lon!),
                                        zoom: 18,
                                      );
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(stopsDescription),
                        ),
                      Positioned(
                        left: -24,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              height: 20,
                              width: 20,
                              child: bikeSvg(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
