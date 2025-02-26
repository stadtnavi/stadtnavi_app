import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'parking_information_cubit/parking_information_cubit.dart';
import 'parking_overview_map.dart';
import 'package:routemaster/routemaster.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_marker_modal.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/home_page.dart';

import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/default_pages_menu.dart';
import 'package:trufi_core/base/widgets/alerts/fetch_error_handler.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class ParkingInformationPage extends StatefulWidget {
  static const String route = "/Home/ParkingInformation";
  static TrufiMenuItem menuItemDrawer = MenuPageItem(
    id: route,
    selectedIcon: (context) => Icon(
      Icons.location_on_outlined,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    ),
    notSelectedIcon: (context) => const Icon(
      Icons.local_parking,
      color: Colors.grey,
    ),
    name: (context) => Localizations.localeOf(context).languageCode == "en"
        ? "Parking Information List"
        : "Parkinformationsliste",
  );

  const ParkingInformationPage({
    Key? key,
    required this.drawerBuilder,
  }) : super(key: key);

  final WidgetBuilder drawerBuilder;

  @override
  State<ParkingInformationPage> createState() => _ParkingInformationPageState();
}

class _ParkingInformationPageState extends State<ParkingInformationPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final parkingInformationCubit = context.read<ParkingInformationCubit>();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await parkingInformationCubit.refresh();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelCubit = context.read<PanelCubit>();
    final parkingInformationCubit = context.read<ParkingInformationCubit>();
    return BlocBuilder<ParkingInformationCubit, ParkingInformationState>(
      builder: (context, state) {
        final listTransports = state.parkings;
        return Scaffold(
          appBar: AppBar(
            title: Text(Localizations.localeOf(context).languageCode == "en"
                ? "Parking Information List"
                : "Parkinformationsliste"),
            actions: [
              IconButton(
                onPressed: () {
                  if (!state.isLoading) {
                    parkingInformationCubit.loadData().catchError(
                        (error) => onFetchError(context, error as Exception));
                  }
                },
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 10),
            ],
          ),
          drawer: widget.drawerBuilder(context),
          body: Stack(
            children: [
              if (state.error != '')
                Center(
                  child: Text(state.error),
                )
              else
                Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  thickness: 8,
                  trackVisibility: true,
                  child: ListView.builder(
                    itemCount: listTransports.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    itemBuilder: (buildContext, index) {
                      final parking = listTransports[index];
                      final localeName =
                          TrufiBaseLocalization.of(context).localeName;
                      String? spaces;
                      if (parking.carPlacesCapacity != null) {
                        if (parking.availabilityCarPlacesCapacity != null &&
                            parking.availabilityCarPlacesCapacity! <=
                                parking.carPlacesCapacity!) {
                          spaces = localeName == 'en'
                              ? "${parking.availabilityCarPlacesCapacity} of ${parking.carPlacesCapacity} parking spaces available"
                              : "${parking.availabilityCarPlacesCapacity} von ${parking.carPlacesCapacity} Stellplätzen verfügbar";
                        } else {
                          spaces =
                              "${parking.carPlacesCapacity} ${localeName == 'en' ? 'parking spaces' : 'Stellplätze'}";
                        }

                        if (parking.state == "CLOSED") {
                          spaces +=
                              " (${localeName == 'en' ? 'closed' : 'Geschlossen'})";
                        }
                      }
                      String? disabledSpaces;
                      if (parking.totalDisabled != null &&
                          parking.freeDisabled != null) {
                        disabledSpaces = localeName == 'en'
                            ? "${parking.freeDisabled} of ${parking.totalDisabled} wheelchair-accessible parking spaces available"
                            : "${parking.freeDisabled} von ${parking.totalDisabled} rollstuhlgerechten Parkplätzen vorhanden";
                      }
                      final availabilityParking = parking.markerState();
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              panelCubit.setPanel(
                                CustomMarkerPanel(
                                  panel: (
                                    context,
                                    onFetchPlan, {
                                    isOnlyDestination,
                                  }) =>
                                      ParkingStateUpdater(
                                    parkingFeature: parking,
                                    onFetchPlan: () {
                                      _callFetchPlan();
                                    },
                                    isOnlyDestination:
                                        isOnlyDestination ?? true,
                                  ),
                                  position: parking.position,
                                  minSize: 50,
                                ),
                              );
                              showTrufiDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ParkingOverviewMap(
                                  parking: parking,
                                ),
                              );
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            minLeadingWidth: 0,
                            leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: SvgPicture.string(
                                parkingMarkerIcons[parking.type] ?? "",
                              ),
                            ),
                            title: Text(parking.name.toString()),
                            subtitle: spaces != null || disabledSpaces != null
                                ? Text(
                                    "${spaces ?? ''}${spaces != null && disabledSpaces != null ? '\n' : ''}${disabledSpaces ?? ''}",
                                  )
                                : null,
                            trailing: (availabilityParking != null)
                                ? availabilityParking.getImage(size: 25)
                                : null,
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _callFetchPlan() async {
    final localization = TrufiBaseLocalization.of(context);
    final panelCubit = context.read<PanelCubit>();
    final mapRouteCubit = context.read<MapRouteCubit>();
    final locationProvider = GPSLocationProvider();
    final currentLocation = locationProvider.myLocation;
    if (currentLocation != null) {
      await mapRouteCubit.setFromPlace(TrufiLocation(
        description: localization.commonYourLocation,
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      ));
      panelCubit.cleanPanel();
      _cleanNavigatorStore();
    } else {
      await locationProvider.startLocation(context);
    }
  }

  void _cleanNavigatorStore() {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Routemaster.of(context).push(
      HomePage.route,
      queryParameters: {"FetchRoute": "true"},
    );
  }
}
