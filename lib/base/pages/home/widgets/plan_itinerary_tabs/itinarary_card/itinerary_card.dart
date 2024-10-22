import 'package:flutter/material.dart';

import 'package:trufi_core/base/const/styles.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/itinerary_summary_advanced.dart';

class ItineraryCard extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItinerary selectedItinerary;
  final GestureTapCallback onTap;
  final Function(
    PlanItinerary selectItinerary, {
    bool? showAllItineraries,
  }) selectItinerary;

  const ItineraryCard({
    Key? key,
    required this.itinerary,
    required this.selectedItinerary,
    required this.onTap,
    required this.selectItinerary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    return GestureDetector(
      onTap: () async {
        await selectItinerary(itinerary);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: Insets.sm,
                bottom: Insets.xs,
                right: Insets.xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${itinerary.startDateText(localizationBase)} ${itinerary.startTimeHHmm} - ${itinerary.endTimeHHmm}",
                    style: theme.primaryTextTheme. bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itinerary.durationFormat(localizationBase),
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 50 * MediaQuery.of(context).textScaleFactor,
                  color: itinerary == selectedItinerary
                      ? theme.colorScheme.primary
                      : Colors.grey[400],
                  margin: const EdgeInsets.only(
                    right: 5,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (builderContext, constrains) {
                    return ItinerarySummaryAdvanced(
                      maxWidth: constrains.maxWidth,
                      itinerary: itinerary,
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () async {
                    onTap();
                    await selectItinerary(
                      itinerary,
                      showAllItineraries: false,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 30,
                    height: 50,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
