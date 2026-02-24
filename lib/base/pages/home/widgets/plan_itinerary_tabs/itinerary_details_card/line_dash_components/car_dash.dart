import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/offer_carpool/offer_carpool_screen.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/mode_transport_screen.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/custom_text_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/configuration/custom_async_executor.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

import 'dash_line_place.dart';
import 'separator_place.dart';

class CarDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final MoveInMap moveInMap;

  const CarDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final textCarInstruction =
        '${localization.carInstructionDrive} ${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})';
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            location: leg.fromPlace?.name ?? '',
            color: leg.primaryColor,
          ),
        SeparatorPlace(
          color: leg.primaryColor,
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
                if (leg.steps != null && leg.steps!.isNotEmpty)
                  ExpansionTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      textCarInstruction,
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
                    child: Text(textCarInstruction),
                  ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BaseTrufiPage(
                                child: OfferCarpoolScreen(
                                  planItineraryLeg: leg,
                                ),
                              ),
                        ),
                      );
                    },
                    child: Text(
                      localization.localeName == "en"
                          ? "Offer carpool"
                          : "Fahrgemeinschaft anbieten",
                      style: TextStyle(color: theme.colorScheme.surface),
                    ),
                  ),
                ),
                if ((leg
                            .toPlace
                            ?.vehicleParkingWithEntrance
                            ?.vehicleParking
                            ?.tags !=
                        null) &&
                    (leg
                        .toPlace!
                        .vehicleParkingWithEntrance!
                        .vehicleParking!
                        .tags!
                        .contains('state:few')))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      InfoMessage(
                        message: localization.carParkCloseCapacityMessage,
                      ),
                      CustomTextButton(
                        text: localization.carParkExcludeFull,
                        onPressed: () async {
                          final mapRouteState =
                              context.read<MapRouteCubit>().state;
                          final mapModesCubit = context.read<MapModesCubit>();
                          final settingFetchState =
                              context.read<SettingFetchCubit>().state;
                          customAsyncExecutor.run<MapModesState>(
                            context: context,
                            onExecute:
                                () async =>
                                    await mapModesCubit.fetchPlanModeRidePark(
                                      from: mapRouteState.fromPlace!,
                                      to: mapRouteState.toPlace!,
                                      localeName:
                                          Localizations.localeOf(
                                            context,
                                          ).languageCode,
                                      dateTime: settingFetchState.date,
                                      arriveBy: settingFetchState.arriveBy,
                                    ),
                            onFinish: (mapModesState) {
                              final modesTransport =
                                  mapModesState.modesTransport;
                              if (modesTransport?.parkRidePlan != null) {
                                mapModesCubit.setValuesMap(
                                  plan: modesTransport!.parkRidePlan!,
                                );
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (
                                          BuildContext context,
                                        ) => ModeTransportScreen(
                                          title:
                                              localization
                                                  .settingPanelMyModesTransportParkRide,
                                          typeTransport:
                                              ModesTransportType.parkRidePlan,
                                        ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
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
