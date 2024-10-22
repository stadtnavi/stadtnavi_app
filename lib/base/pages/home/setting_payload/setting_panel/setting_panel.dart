import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/base/widgets/custom_switch_tile.dart';
import 'package:stadtnavi_core/base/widgets/speed_expanded_tile.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class SettingPanel extends StatefulWidget {
  static const String route = "/setting-panel";
  static const Divider _divider = Divider(thickness: 2);
  static const Divider _dividerWeight = Divider(thickness: 10);
  // TODO improve availability carpool-funicular
  // static bool enableFunicular = true;

  const SettingPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingPanel> createState() => _SettingPanelState();
}

class _SettingPanelState extends State<SettingPanel> {
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
    final payloadDataPlanCubit = context.read<SettingFetchCubit>();
    if (!stopDefaultButtonEvent) {
      Navigator.of(context).pop(payloadDataPlanCubit.state);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final payloadDataPlanCubit = context.read<SettingFetchCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.commonSettings),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(payloadDataPlanCubit.state);
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SettingFetchCubit, SettingFetchState>(
          builder: (blocContext, state) {
            return Scrollbar(
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  SpeedExpansionTile(
                    title: localization.settingPanelWalkingSpeed,
                    dataSpeeds: WalkingSpeed.values
                        .map(
                          (e) => DataSpeed(
                              e.translateValue(localization), e.speed),
                        )
                        .toList(),
                    textSelected:
                        state.typeWalkingSpeed.translateValue(localization),
                    onChanged: (value) {
                      final WalkingSpeed selected = WalkingSpeed.values
                          .firstWhere((element) =>
                              element.translateValue(localization) == value);
                      payloadDataPlanCubit.setWalkingSpeed(selected);
                    },
                  ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localization.settingPanelAvoidWalking,
                    value: state.avoidWalking,
                    onChanged: (value) => payloadDataPlanCubit.setAvoidWalking(
                        avoidWalking: value),
                  ),
                  SettingPanel._dividerWeight,
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localization.settingPanelTransportModes,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  CustomSwitchTile(
                    title: localizationBase.instructionVehicleBus,
                    secondary: Container(
                      decoration: BoxDecoration(
                        color: TransportMode.bus.color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 35,
                      width: 35,
                      child: TransportMode.bus.getImage(color: Colors.white),
                    ),
                    value: state.transportModes.contains(TransportMode.bus),
                    onChanged: (_) {
                      payloadDataPlanCubit.setTransportMode(TransportMode.bus);
                    },
                  ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localizationBase.instructionVehicleCommuterTrain,
                    secondary: Container(
                      decoration: BoxDecoration(
                          color: TransportMode.rail.color,
                          borderRadius: BorderRadius.circular(5)),
                      height: 35,
                      width: 35,
                      child: TransportMode.rail.getImage(color: Colors.white),
                    ),
                    value: state.transportModes.contains(TransportMode.rail),
                    onChanged: (_) {
                      payloadDataPlanCubit.setTransportMode(TransportMode.rail);
                    },
                  ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localizationBase.instructionVehicleMetro,
                    secondary: Container(
                      decoration: BoxDecoration(
                          color: TransportMode.subway.color,
                          borderRadius: BorderRadius.circular(5)),
                      height: 35,
                      width: 35,
                      child: TransportMode.subway.getImage(color: Colors.white),
                    ),
                    value: state.transportModes.contains(TransportMode.subway),
                    onChanged: (_) {
                      payloadDataPlanCubit
                          .setTransportMode(TransportMode.subway);
                    },
                  ),
                  if (TransportMode.funicular.visible) SettingPanel._divider,
                  if (TransportMode.funicular.visible)
                    CustomSwitchTile(
                      title: localization.instructionVehicleRackRailway,
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: TransportMode.funicular.getImage(),
                      ),
                      value: state.transportModes
                          .contains(TransportMode.funicular),
                      onChanged: (_) {
                        payloadDataPlanCubit
                            .setTransportMode(TransportMode.funicular);
                      },
                    ),
                  if (TransportMode.carPool.visible) SettingPanel._divider,
                  if (TransportMode.carPool.visible)
                    CustomSwitchTile(
                      title: localizationBase.instructionVehicleCarpool,
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: TransportMode.carPool.getImage(),
                      ),
                      value:
                          state.transportModes.contains(TransportMode.carPool),
                      onChanged: (_) {
                        payloadDataPlanCubit
                            .setTransportMode(TransportMode.carPool);
                      },
                    ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localization.instructionVehicleSharing,
                    secondary: SizedBox(
                      height: 35,
                      width: 35,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: FittedBox(child: shareManuSvg),
                      ),
                    ),
                    value: state.transportModes.contains(TransportMode.bicycle),
                    onChanged: (_) {
                      payloadDataPlanCubit
                          .setTransportMode(TransportMode.bicycle);
                    },
                  ),
                  if (state.transportModes.contains(TransportMode.bicycle))
                    Container(
                      margin:
                          const EdgeInsets.only(left: 55, top: 5, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5),
                            child: Text(localization.commonCitybikes,
                                style: theme.textTheme.bodyLarge),
                          ),
                          if (BikeRentalNetwork.cargoBike.visible)
                            CustomSwitchTile(
                              title: localization
                                  .instructionVehicleSharingRegioRad,
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child: BikeRentalNetwork.cargoBike.image,
                              ),
                              value: state.bikeRentalNetworks
                                  .contains(BikeRentalNetwork.cargoBike),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.cargoBike);
                              },
                            ),
                          if (BikeRentalNetwork.taxi.visible)
                            CustomSwitchTile(
                              title: localization.instructionVehicleSharingTaxi,
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child: BikeRentalNetwork.taxi.image,
                              ),
                              value: state.bikeRentalNetworks
                                  .contains(BikeRentalNetwork.taxi),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.taxi);
                              },
                            ),
                          if (BikeRentalNetwork.carSharing.visible)
                            CustomSwitchTile(
                              title: localization
                                  .instructionVehicleSharingCarSharing,
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child: BikeRentalNetwork.carSharing.image,
                              ),
                              value: state.bikeRentalNetworks
                                  .contains(BikeRentalNetwork.carSharing),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.carSharing);
                              },
                            ),
                          if (BikeRentalNetwork.regioradStuttgart.visible)
                            CustomSwitchTile(
                              title: localization
                                  .instructionVehicleSharingRegioRad,
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child:
                                    BikeRentalNetwork.regioradStuttgart.image,
                              ),
                              value: state.bikeRentalNetworks.contains(
                                  BikeRentalNetwork.regioradStuttgart),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.regioradStuttgart);
                              },
                            ),
                          if (BikeRentalNetwork.openbikeHerrenberg.visible)
                            CustomSwitchTile(
                              title: localization
                                  .instructionVehicleSharingRegioRad,
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child:
                                    BikeRentalNetwork.openbikeHerrenberg.image,
                              ),
                              value: state.bikeRentalNetworks.contains(
                                  BikeRentalNetwork.openbikeHerrenberg),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.openbikeHerrenberg);
                              },
                            ),
                          if (BikeRentalNetwork.scooter.visible)
                            CustomSwitchTile(
                              title: "TIER Ludwigsburg",
                              secondary: SizedBox(
                                height: 35,
                                width: 35,
                                child: BikeRentalNetwork.scooter.image,
                              ),
                              value: state.bikeRentalNetworks
                                  .contains(BikeRentalNetwork.scooter),
                              onChanged: (_) {
                                payloadDataPlanCubit.setBikeRentalNetwork(
                                    BikeRentalNetwork.scooter);
                              },
                            ),
                        ],
                      ),
                    )
                  else
                    Container(),
                  CustomSwitchTile(
                    title: localization.settingPanelAvoidTransfers,
                    value: state.avoidTransfers,
                    onChanged: (value) => payloadDataPlanCubit
                        .setAvoidTransfers(avoidTransfers: value),
                  ),
                  SettingPanel._dividerWeight,
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localization.settingPanelMyModesTransport,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  CustomSwitchTile(
                    title: localization.settingPanelMyModesTransportBike,
                    secondary: SizedBox(
                      height: 35,
                      width: 35,
                      child: bikeSvg(),
                    ),
                    value: state.includeBikeSuggestions,
                    onChanged: (value) =>
                        payloadDataPlanCubit.setIncludeBikeSuggestions(
                            includeBikeSuggestions: value),
                  ),
                  SpeedExpansionTile(
                    title: localization.settingPanelBikingSpeed,
                    isSubtitle: true,
                    dataSpeeds: BikingSpeed.values
                        .map(
                          (e) => DataSpeed(e.translateValue(), ''),
                        )
                        .toList(),
                    textSelected: state.typeBikingSpeed.translateValue(),
                    onChanged: (value) {
                      final BikingSpeed selected = BikingSpeed.values
                          .firstWhere(
                              (element) => element.translateValue() == value);
                      payloadDataPlanCubit.setBikingSpeed(selected);
                    },
                  ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localization.settingPanelMyModesTransportParkRide,
                    secondary: SizedBox(
                      height: 35,
                      width: 35,
                      child: parkRideSvg,
                    ),
                    value: state.includeParkAndRideSuggestions,
                    onChanged: (value) =>
                        payloadDataPlanCubit.setParkRide(parkRide: value),
                  ),
                  SettingPanel._divider,
                  CustomSwitchTile(
                    title: localizationBase.instructionVehicleCar,
                    secondary: SizedBox(
                      height: 35,
                      width: 35,
                      child: carSvg(),
                    ),
                    value: state.includeCarSuggestions,
                    onChanged: (value) => payloadDataPlanCubit
                        .setIncludeCarSuggestions(includeCarSuggestions: value),
                  ),
                  SettingPanel._dividerWeight,
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localization.settingPanelAccessibility,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(localization.settingPanelAccessibilityDetails),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
