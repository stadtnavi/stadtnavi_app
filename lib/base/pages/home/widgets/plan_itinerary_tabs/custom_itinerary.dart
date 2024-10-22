import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/base/widgets/alerts/fetch_error_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stadtnavi_core/base/models/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/itinerary_card.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/itinerary_details_card.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

class CustomItinerary extends StatefulWidget {
  final TrufiMapController trufiMapController;

  const CustomItinerary({
    Key? key,
    required this.trufiMapController,
  }) : super(key: key);

  @override
  _CustomItineraryState createState() => _CustomItineraryState();
}

class _CustomItineraryState extends State<CustomItinerary>
    with TickerProviderStateMixin {
  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor, context: context);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (showDetail) {
      setState(() {
        showDetail = false;
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final mapRouteCubit = context.watch<MapRouteCubit>();
    final mapRouteState = mapRouteCubit.state;
    final payloadDataPlanState = context.watch<SettingFetchCubit>().state;
    return Stack(
      children: [
        if (mapRouteState.plan?.isOnlyWalk ?? false)
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: InfoMessage(
              message:
                  mapRouteState.plan!.planInfoBox!.translateValue(localization),
              isErrorMessage: mapRouteState.plan!.isTypeMessageInformation,
              widget: mapRouteState.plan!.isOutSideLocation
                  ? Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            style: theme.textTheme. bodyLarge?.copyWith(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            text: localization
                                .infoMessageUseNationalServicePrefix,
                          ),
                          TextSpan(
                            style: theme.primaryTextTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            text: ' Fahrplanauskunft efa-bw',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch('https://www.efa-bw.de');
                              },
                          )
                        ]),
                      ),
                    )
                  : null,
            ),
          )
        else
          Visibility(
            visible: !showDetail,
            maintainState: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await _fetchMoreitineraries(
                              context: context,
                              isFetchEarlier: true,
                            );
                          },
                          child: Text(
                            payloadDataPlanState.arriveBy
                                ? localization
                                    .fetchMoreItinerariesLaterDeparturesTitle
                                : localization
                                    .fetchMoreItinerariesEarlierDepartures,
                            style: TextStyle(color: theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await _fetchMoreitineraries(
                              context: context,
                              isFetchEarlier: false,
                            );
                          },
                          child: Text(
                            payloadDataPlanState.arriveBy
                                ? localization
                                    .fetchMoreItinerariesEarlierDepartures
                                : localization
                                    .fetchMoreItinerariesLaterDeparturesTitle,
                            style: TextStyle(color: theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  if (mapRouteState.isFetchEarlier ||
                      mapRouteState.isFetchLater)
                    LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  if (mapRouteState.plan?.planInfoBox != null &&
                      mapRouteState.plan!.planInfoBox != PlanInfoBox.undefined)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InfoMessage(
                        message: mapRouteState.plan!.planInfoBox!
                            .translateValue(localization),
                        closeInfo: () async =>
                            await mapRouteCubit.removeInfoBox(),
                      ),
                    ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: mapRouteState.plan?.itineraries?.length ?? 0,
                    itemBuilder: (buildContext, index) {
                      final itinerary = mapRouteState.plan!.itineraries![index];
                      return ItineraryCard(
                        itinerary: itinerary,
                        onTap: () {
                          setState(() {
                            showDetail = true;
                          });
                        },
                        selectedItinerary: mapRouteState.selectedItinerary!,
                        selectItinerary: (selectedItinerary,
                            {showAllItineraries}) {
                          mapRouteCubit.selectItinerary(
                            selectedItinerary,
                            showAllItineraries: showAllItineraries ?? true,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        if (showDetail && mapRouteState.selectedItinerary != null)
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: ItineraryDetailsCard(
              itinerary: mapRouteState.selectedItinerary!,
              onBackPressed: () {
                setState(() {
                  showDetail = false;
                });
                mapRouteCubit.showAllItineraries();
              },
              moveInMap: (latLng) => widget.trufiMapController.move(
                center: latLng,
                zoom: 15,
                tickerProvider: this,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _fetchMoreitineraries({
    required BuildContext context,
    required bool isFetchEarlier,
  }) async {
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapRouteState = mapRouteCubit.state;
    final payloadDataPlanCubit = context.read<SettingFetchCubit>();
    if (!mapRouteState.isFetchEarlier && !mapRouteState.isFetchLater) {
      if (payloadDataPlanCubit.state.arriveBy) {
        await mapRouteCubit
            .fetchMoreArrivalPlan(
              advancedOptions: payloadDataPlanCubit.state,
              isFetchEarlier: isFetchEarlier,
              itineraries: mapRouteState.plan?.itineraries ?? [],
            )
            .catchError((error) => onFetchError(context, error as Exception));
      } else {
        await mapRouteCubit
            .fetchMoreDeparturePlan(
              advancedOptions: payloadDataPlanCubit.state,
              isFetchEarlier: isFetchEarlier,
              itineraries: mapRouteState.plan?.itineraries ?? [],
            )
            .catchError((error) => onFetchError(context, error as Exception));
      }
    }
  }
}
