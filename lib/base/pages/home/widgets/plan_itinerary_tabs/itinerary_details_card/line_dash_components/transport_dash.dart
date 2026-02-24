import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/stop_marker_modal_base.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/transit_leg.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:trufi_core/base/models/journey_plan/utils/duration_utils.dart';

import 'alert_action_icon.dart';
import 'dash_line_place.dart';
import 'separator_place.dart';

class TransportDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final bool showAfterText;
  final MoveInMap moveInMap;

  const TransportDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
    this.showAfterText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelCubit = context.read<PanelCubit>();
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            delayedDate:
                leg.departureDelay > 0
                    ? durationToHHmm(
                      leg.startTime.subtract(
                        Duration(seconds: leg.departureDelay),
                      ),
                    )
                    : null,
            location: leg.fromPlace?.name ?? '',
            color: leg.primaryColor,
            isDelayed:
                leg.departureDelay > 0
                    ? true
                    : leg.arrivalDelay >= 0
                    ? false
                    : null,
            alertSeverityIcon: AlertActionIcon.getActiveAlertSeverityLevel(
              alerts: leg.fromPlace?.stopEntity?.alerts,
              referenceUnixTime: leg.startTime.millisecondsSinceEpoch / 1000,
              ontap: () {
                panelCubit.setPanel(
                  CustomMarkerPanel(
                    panel:
                        (context, _, {isOnlyDestination}) =>
                            StopMarkerModalBase(
                              initialIndex: 2,
                              stopFeature: StopFeature(
                                code: leg.fromPlace?.stopEntity?.code,
                                gtfsId: leg.fromPlace?.stopEntity?.gtfsId ?? "",
                                name: leg.fromPlace?.stopEntity?.name,
                                parentStation: null,
                                patterns: null,
                                platform: null,
                                type: leg.transportMode.name,
                                position: LatLng(
                                  leg.fromPlace!.lat,
                                  leg.fromPlace!.lon,
                                ),
                              ),
                            ),
                    position: LatLng(leg.fromPlace!.lat, leg.fromPlace!.lon),
                    minSize: 130,
                  ),
                );
              },
            ),
          ),
        SeparatorPlace(
          color: leg.primaryColor,
          child: GestureDetector(
            onTap: () {
              if (leg.fromPlace != null) {
                moveInMap(LatLng(leg.fromPlace!.lat, leg.fromPlace!.lon));
              }
            },
            child: TransitLeg(
              itinerary: itinerary,
              leg: leg,
              moveInMap: moveInMap,
            ),
          ),
        ),
        if (showAfterLine)
          DashLinePlace(
            date: leg.endTimeString.toString(),
            delayedDate:
                leg.arrivalDelay > 0
                    ? durationToHHmm(
                      leg.endTime.subtract(
                        Duration(seconds: leg.arrivalDelay),
                      ),
                    )
                    : null,
            location: showAfterText ? (leg.toPlace?.name ?? '') : '',
            isDelayed:
                leg.departureDelay <= 0
                    ? false
                    : leg.arrivalDelay > 0
                    ? true
                    : null,
            color: leg.primaryColor,
            alertSeverityIcon: AlertActionIcon.getActiveAlertSeverityLevel(
              alerts: leg.toPlace?.stopEntity?.alerts,
              referenceUnixTime: leg.startTime.millisecondsSinceEpoch / 1000,
              ontap: () {
                panelCubit.setPanel(
                  CustomMarkerPanel(
                    panel:
                        (context, _, {isOnlyDestination}) =>
                            StopMarkerModalBase(
                              initialIndex: 2,
                              stopFeature: StopFeature(
                                code: leg.toPlace?.stopEntity?.code,
                                gtfsId: leg.toPlace?.stopEntity?.gtfsId ?? "",
                                name: leg.toPlace?.stopEntity?.name,
                                parentStation: null,
                                patterns: null,
                                platform: null,
                                type: leg.transportMode.name,
                                position: LatLng(
                                  leg.toPlace!.lat,
                                  leg.toPlace!.lon,
                                ),
                              ),
                            ),
                    position: LatLng(leg.toPlace!.lat, leg.toPlace!.lon),
                    minSize: 130,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
