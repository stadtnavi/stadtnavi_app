import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/mode_leg.dart';

class BicycleLeg extends StatelessWidget {
  final double maxWidth;
  final PlanItineraryLeg leg;
  final PlanItineraryLeg? bicycleWalkLeg;
  final double legLength;

  const BicycleLeg({
    Key? key,
    required this.leg,
    required this.bicycleWalkLeg,
    required this.legLength,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModeLeg(
      maxWidth: maxWidth,
      leg: bicycleWalkLeg ?? leg,
      legLength: legLength,
    );
  }
}
