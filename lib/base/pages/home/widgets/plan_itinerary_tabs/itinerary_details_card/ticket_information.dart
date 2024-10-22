import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stadtnavi_core/base/models/othermodel/fare_component.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/models/utils/fare_utils.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/custom_text_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/consts.dart';

class TicketInformation extends StatefulWidget {
  final PlanItinerary itinerary;
  final List<PlanItineraryLeg> legs;

  const TicketInformation({
    Key? key,
    required this.itinerary,
    required this.legs,
  }) : super(key: key);

  @override
  State<TicketInformation> createState() => _TicketInformationState();
}

class _TicketInformationState extends State<TicketInformation> {
  bool loading = false;
  String? fetchError;
  List<FareComponent?>? fares;
  List<FareComponent?>? unknownFares;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFares();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final hasBikeLeg = widget.legs.any(
      (leg) =>
          (leg.rentedBike ?? false) ||
          leg.transportMode == TransportMode.bicycle ||
          leg.mode == 'BICYCLE_WALK',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loading)
          const _LoadingTIcketSkeleton()
        else if ((fares?.isEmpty ?? false) ||
            (unknownFares?.isNotEmpty ?? false))
          InfoMessage(message: localization.itineraryMissingPrice)
        else if (fares?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fares!.length > 1
                            ? '${localization.itineraryTicketsTitle}:'
                            : '${localization.itineraryTicketTitle}:',
                        style: theme.primaryTextTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            localization.fareTicketName,
                            style: theme.primaryTextTheme.bodyLarge,
                          ),
                          Text(
                            ' ${formatTwoDecimals(localeName: localization.localeName).format((fares![0]!.cents ?? 0) / 100)} €',
                            style: theme.primaryTextTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ...fares!.map((fare) {
                    final ticketUrl = fare?.agency?.fareUrl ?? fare?.url;
                    return ticketUrl != null
                        ? CustomTextButton(
                            text: localization.itineraryBuyTicket,
                            onPressed: () async {
                              if (await canLaunch(ticketUrl)) {
                                await launch(ticketUrl);
                              }
                            },
                            isDark: false,
                            height: 27,
                          )
                        : Container();
                  }).toList(),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  localization.copyrightsPriceProvider,
                  style: theme.primaryTextTheme.bodyLarge
                      ?.copyWith(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.left,
                ),
              ),
              if (hasBikeLeg)
                InfoMessage(
                  message: localization.itineraryPriceOnlyPublicTransport,
                  margin: const EdgeInsets.only(right: 15, top: 5),
                ),
            ],
          ),
        if (fares != null || loading) const Divider(),
      ],
    );
  }

  Future<void> loadFares() async {
    if (widget.itinerary.compressLegs.isNotEmpty &&
        widget.itinerary.compressLegs.any((leg) => leg.transitLeg)) {
      final String? faresUrl = ApiConfig().faresURL;
      if (faresUrl?.isEmpty ?? true) return;
      setState(() {
        fetchError = null;
        loading = true;
      });
      fetchFares(widget.itinerary, faresUrl!).then((value) {
        if (mounted) {
          setState(() {
            fares = getFares(value);
            unknownFares = getUnknownFares(
                value, fares, getRoutes(widget.itinerary.compressLegs));
            loading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            fetchError = "$error";
            loading = false;
          });
        }
      });
    }
  }
}

class _LoadingTIcketSkeleton extends StatelessWidget {
  const _LoadingTIcketSkeleton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      switchAnimationConfig: SwitchAnimationConfig(
        duration: Duration(milliseconds: 50),
      ),
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  child: Skeleton.leaf(
                    child: Card(
                      elevation: 0,
                  shadowColor: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: Container(
                        height: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  child: Skeleton.leaf(
                    child: Card(
                  shadowColor: Colors.transparent,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      child: Container(
                        height: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(2),
              child: Skeleton.leaf(
                child: Card(
                  shadowColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  child: Container(
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
