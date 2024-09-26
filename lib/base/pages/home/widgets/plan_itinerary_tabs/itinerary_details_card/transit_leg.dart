import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/route_number.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class TransitLeg extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final void Function(LatLng latlng) moveInMap;

  const TransitLeg({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final isTypeBikeRentalNetwork =
        leg.transportMode == TransportMode.bicycle &&
            leg.fromPlace?.bikeRentalStation != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RouteNumber(
          transportMode: leg.transportMode,
          backgroundColor: leg.backgroundColor,
          text: leg.route?.shortName ??
              leg.transportMode.getTranslate(localizationBase),
          tripHeadSing: leg.headSign,
          icon: (leg.route?.type ?? 0) == 715
              ? onDemandTaxiSvg(color: 'FFFFFF')
              : isTypeBikeRentalNetwork
                  ? getBikeRentalNetwork(
                          leg.fromPlace!.bikeRentalStation?.networks?[0])
                      .image
                  : null,
          duration: leg.durationLeg(localizationBase),
          distance: leg.distanceString(localizationBase),
          textContainer: isTypeBikeRentalNetwork
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      leg.fromPlace?.name ?? '',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        localization.bikeRentalBikeStation,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                )
              : null,
        ),
        if (TransportMode.carPool == leg.transportMode &&
            leg.route?.url != null)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () async {
                await launch(leg.route!.url!);
              },
              child: Text(
                localization.commonDetails,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        if (leg.dropOffBookingInfo != null)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: InfoMessage(
                  message:
                      '${leg.dropOffBookingInfo?.message ?? ''} ${leg.dropOffBookingInfo?.dropOffMessage ?? ''}',
                  widget: leg.dropOffBookingInfo?.contactInfo?.infoUrl != null
                      ? RichText(
                          text: TextSpan(
                            style: theme.primaryTextTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            text: localization.commonMoreInformartion,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (leg.dropOffBookingInfo?.contactInfo
                                        ?.infoUrl !=
                                    null) {
                                  launch(leg.dropOffBookingInfo!.contactInfo!
                                      .infoUrl!);
                                }
                              },
                          ),
                        )
                      : null,
                ),
              ),
              if (leg.dropOffBookingInfo?.contactInfo?.phoneNumber != null)
                GestureDetector(
                  onTap: () {
                    launch(
                      "tel:${leg.dropOffBookingInfo?.contactInfo?.phoneNumber}",
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      '${localization.commonCall}  ${leg.dropOffBookingInfo!.contactInfo!.phoneNumber}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (leg.dropOffBookingInfo?.contactInfo?.bookingUrl != null)
                GestureDetector(
                  onTap: () {
                    launch(leg.dropOffBookingInfo!.contactInfo!.bookingUrl!);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 210,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      localization.commonOnDemandTaxi,
                      style: theme.primaryTextTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        if ((leg.transportMode != TransportMode.bicycle &&
                leg.transportMode != TransportMode.car) ||
            (leg.transportMode == TransportMode.bicycle &&
                isTypeBikeRentalNetwork))
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              '${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})',
              style: theme.primaryTextTheme. bodyLarge
                  ?.copyWith(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        if (leg.intermediatePlaces != null &&
            leg.intermediatePlaces!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ExpansionTile(
              title: Text(
                '${leg.intermediatePlaces!.length} ${localizationBase.localeName == 'en' ? (leg.intermediatePlaces!.length > 1 ? 'stops' : 'stop') : (leg.intermediatePlaces!.length > 1 ? 'Zwischenstopps' : 'Zwischenstopp')}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
              textColor: theme.primaryColor,
              collapsedTextColor: theme.primaryColor,
              iconColor: theme.primaryColor,
              collapsedIconColor: theme.primaryColor,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                ...leg.intermediatePlaces!
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                if (e.stopEntity?.lat != null &&
                                    e.stopEntity?.lon != null) {
                                  moveInMap(LatLng(
                                    e.stopEntity!.lat!,
                                    e.stopEntity!.lon!,
                                  ));
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('HH:mm').format(
                                              e.arrivalTime ?? DateTime.now()),
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            e.stopEntity?.name ?? '',
                                          ),
                                        ),
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
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
      ],
    );
  }
}
