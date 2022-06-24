import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:ludwigsburg/pages/parking_information_page/parking_information_cubit/parking_information_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';

import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/default_pages_menu.dart';
import 'package:trufi_core/base/widgets/alerts/fetch_error_handler.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';

class ParkingInformationPage extends StatefulWidget {
  static const String route = "/ParkingInformation";
  static MenuItem menuItemDrawer = MenuPageItem(
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
    WidgetsBinding.instance?.addPostFrameCallback((duration) {
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
                  isAlwaysShown: true,
                  interactive: true,
                  thickness: 8,
                  showTrackOnHover: true,
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
                      return SizedBox(
                          child: ListTile(
                        leading: SvgPicture.string(
                          parkingMarkerIcons[parking.type] ?? "",
                        ),
                        title: Text(parking.name.toString()),
                        subtitle: spaces != null || disabledSpaces != null
                            ? Text(
                                "${spaces ?? ''}${spaces != null && disabledSpaces != null ? '\n' : ''}${disabledSpaces ?? ''}",
                              )
                            : null,
                        trailing: (parking.markerState() != null)
                            ? (parking.markerState()!)
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                            : null,
                      ));
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
}
