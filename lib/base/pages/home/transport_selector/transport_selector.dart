import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/card_transport_mode.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/mode_transport_screen.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/journey_plan/utils/duration_utils.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class TransportSelector extends StatelessWidget {
  const TransportSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapModesState = mapModesCubit.state;
    final modesTransport = mapModesState.modesTransport;
    final payloadDataPlanState = context.watch<SettingFetchCubit>().state;
    return mapModesState.isFetchingModes
        ? Skeletonizer(
            enabled: true,
            textBoneBorderRadius:
                TextBoneBorderRadius(BorderRadius.circular(0)),
            child: Container(
              color: Colors.grey[100],
              height: 54,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Skeleton.leaf(
                        child: Card(
                          shadowColor: Colors.transparent,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Skeleton.leaf(
                        child: Card(
                          shadowColor: Colors.transparent,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Skeleton.leaf(
                        child: Card(
                          shadowColor: Colors.transparent,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Skeleton.leaf(
                        child: Card(
                          shadowColor: Colors.transparent,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : mapModesState.hasTransportModes
            ? Container(
                color: Colors.grey[100],
                height: 54,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (modesTransport!.existWalkPlan &&
                        !payloadDataPlanState.wheelchair)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.walkPlan!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title: localizationBase.commonWalk,
                              typeTransport: ModesTransportType.walkPlan,
                            ),
                          ));
                        },
                        icon: walkSvg,
                        title: durationFormatString(
                          localizationBase,
                          modesTransport.walkPlan!.itineraries![0].duration,
                        ),
                        subtitle: displayDistanceWithLocale(
                          localizationBase,
                          modesTransport.walkPlan!.itineraries![0].walkDistance,
                        ),
                      ),
                    if (modesTransport.existBikePlan &&
                        !payloadDataPlanState.wheelchair &&
                        payloadDataPlanState.includeBikeSuggestions)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.bikePlan!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title:
                                  localization.settingPanelMyModesTransportBike,
                              typeTransport: ModesTransportType.bikePlan,
                            ),
                          ));
                        },
                        icon: bikeSvg(),
                        title: durationFormatString(localizationBase,
                            modesTransport.bikePlan!.itineraries![0].duration),
                        subtitle: displayDistanceWithLocale(
                            localizationBase,
                            modesTransport
                                .bikePlan!.itineraries![0].totalDistance),
                      ),
                    if (modesTransport.existBikeAndVehicle &&
                        !payloadDataPlanState.wheelchair &&
                        payloadDataPlanState.includeBikeSuggestions)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.bikeAndVehicle!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title: localization
                                  .settingPanelMyModesTransportBikeRide,
                              typeTransport: ModesTransportType.bikeAndVehicle,
                            ),
                          ));
                        },
                        icon: bikeSvg(),
                        secondaryIcon: SizedBox(
                          height: 12,
                          width: 12,
                          child: modesTransport
                              .bikeAndVehicle!.iconSecondaryPublic,
                        ),
                        title: durationFormatString(
                          localizationBase,
                          modesTransport
                              .bikeAndVehicle!.itineraries![0].duration,
                        ),
                        subtitle: displayDistanceWithLocale(
                            localizationBase,
                            modesTransport.bikeAndVehicle!.itineraries![0]
                                .totalBikingDistance),
                      ),
                    if (modesTransport.existParkRidePlan &&
                        payloadDataPlanState.includeParkAndRideSuggestions)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.parkRidePlan!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title: localization
                                  .settingPanelMyModesTransportParkRide,
                              typeTransport: ModesTransportType.parkRidePlan,
                            ),
                          ));
                        },
                        icon: carSvg(),
                        secondaryIcon: SizedBox(
                          height: 12,
                          width: 12,
                          child:
                              modesTransport.parkRidePlan!.iconSecondaryPublic,
                        ),
                        title: durationFormatString(
                          localizationBase,
                          modesTransport.parkRidePlan!.itineraries![0].duration,
                        ),
                        subtitle: displayDistanceWithLocale(
                          localizationBase,
                          modesTransport
                              .parkRidePlan!.itineraries![0].totalDistance,
                        ),
                      ),
                    if (modesTransport.existCarAndCarPark &&
                        payloadDataPlanState.includeCarSuggestions)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.carAndCarPark!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title: localizationBase.instructionVehicleCar,
                              typeTransport: ModesTransportType.carAndCarPark,
                            ),
                          ));
                        },
                        icon: carSvg(),
                        title: durationFormatString(
                          localizationBase,
                          modesTransport
                              .carAndCarPark!.itineraries![0].duration,
                        ),
                        subtitle: displayDistanceWithLocale(
                          localizationBase,
                          modesTransport
                              .carAndCarPark!.itineraries![0].totalDistance,
                        ),
                      ),
                    if (modesTransport.existOnDemandTaxi)
                      CardTransportMode(
                        onTap: () async {
                          mapModesCubit.setValuesMap(
                            plan: modesTransport.onDemandTaxiPlan!,
                          );
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ModeTransportScreen(
                              title: localization.instructionVehicleTaxi,
                              typeTransport: ModesTransportType.onDemandTaxi,
                            ),
                          ));
                        },
                        icon: onDemandTaxiSvg(),
                        title: durationFormatString(
                            localizationBase,
                            modesTransport
                                .onDemandTaxiPlan!.itineraries![0].duration),
                        subtitle: displayDistanceWithLocale(
                            localizationBase,
                            modesTransport.onDemandTaxiPlan!.itineraries![0]
                                .totalDistance),
                      ),
                  ],
                ),
              )
            : Container();
  }
}
