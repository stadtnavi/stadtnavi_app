import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingStateUpdater extends StatefulWidget {
  final ParkingFeature parkingFeature;
  final void Function() onFetchPlan;
  final bool isOnlyDestination;
  const ParkingStateUpdater({
    Key? key,
    required this.parkingFeature,
    required this.onFetchPlan,
    this.isOnlyDestination = false,
  }) : super(key: key);

  @override
  _ParkingStateUpdaterState createState() => _ParkingStateUpdaterState();
}

class _ParkingStateUpdaterState extends State<ParkingStateUpdater> {
  ParkingFeature? updatedParkingFeature;
  bool loading = true;
  String? fetchError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      load();
    });
  }

  @override
  void didUpdateWidget(covariant ParkingStateUpdater oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parkingFeature.id != widget.parkingFeature.id) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          load();
        },
      );
    }
  }

  void load() async {
    if ((widget.parkingFeature.carPlacesCapacity == null ||
            widget.parkingFeature.availabilityCarPlacesCapacity == null) &&
        (widget.parkingFeature.totalDisabled == null ||
            widget.parkingFeature.freeDisabled == null)) {
      setState(() {
        updatedParkingFeature = widget.parkingFeature;
        loading = false;
      });
    } else {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (updatedParkingFeature != null)
          Expanded(
            child: ParkingMarkerModal(
              parkingFeature: updatedParkingFeature!,
              onFetchPlan: widget.onFetchPlan,
              isOnlyDestination: widget.isOnlyDestination,
            ),
          )
        else if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (fetchError != null)
          Text(
            fetchError!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() {
      updatedParkingFeature = null;
      fetchError = null;
      loading = true;
    });
    await LayersRepository.fetchPark(widget.parkingFeature.id ?? '')
        .then((value) {
      setState(() {
        ParkingFeature tempData = widget.parkingFeature;
        if (tempData.carPlacesCapacity != null &&
            tempData.availabilityCarPlacesCapacity != null) {
          tempData = tempData.copyWith(
            availabilityCarPlacesCapacity: value.availability?.carSpaces,
          );
        }
        if (tempData.totalDisabled != null && tempData.freeDisabled != null) {
          tempData = tempData.copyWith(
            freeDisabled: value.availability?.wheelchairAccessibleCarSpaces,
          );
        }
        updatedParkingFeature = tempData;
        loading = false;
      });
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

class ParkingMarkerModal extends StatelessWidget {
  final ParkingFeature parkingFeature;
  final void Function() onFetchPlan;
  final bool isOnlyDestination;
  const ParkingMarkerModal({
    Key? key,
    required this.parkingFeature,
    required this.onFetchPlan,
    this.isOnlyDestination = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    final localeName = localization.localeName;
    String? spaces;
    if (parkingFeature.carPlacesCapacity != null) {
      if (parkingFeature.availabilityCarPlacesCapacity != null &&
          parkingFeature.availabilityCarPlacesCapacity! <=
              parkingFeature.carPlacesCapacity!) {
        spaces = localeName == 'en'
            ? "${parkingFeature.availabilityCarPlacesCapacity} of ${parkingFeature.carPlacesCapacity} parking spaces available"
            : "${parkingFeature.availabilityCarPlacesCapacity} von ${parkingFeature.carPlacesCapacity} Stellplätzen verfügbar";
      } else {
        spaces =
            "${parkingFeature.carPlacesCapacity} ${localeName == 'en' ? 'parking spaces' : 'Stellplätze'}";
      }

      if (parkingFeature.state == "CLOSED") {
        spaces += " (${localeName == 'en' ? 'closed' : 'Geschlossen'})";
      }
    }
    String? disabledSpaces;
    if (parkingFeature.totalDisabled != null &&
        parkingFeature.freeDisabled != null) {
      disabledSpaces = localeName == 'en'
          ? "${parkingFeature.freeDisabled} of ${parkingFeature.totalDisabled} wheelchair-accessible parking spaces available"
          : "${parkingFeature.freeDisabled} von ${parkingFeature.totalDisabled} rollstuhlgerechten Parkplätzen vorhanden";
    }
    final isOpenParking = parkingFeature.sOpeningHours?.isOpenNow() ?? false;
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(
                  parkingMarkerIcons[parkingFeature.type] ?? "",
                ),
              ),
              Expanded(
                child: Text(
                  parkingFeature.name ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (spaces != null)
                Text(
                  spaces,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              if (disabledSpaces != null)
                Text(
                  disabledSpaces,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              if (parkingFeature.note != null && parkingFeature.note != "")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    Text(
                      parkingFeature.note!,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              if (parkingFeature.sOpeningHours != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: OpeningTimeTable(
                    openingHours: parkingFeature.sOpeningHours!,
                    isOpenParking: isOpenParking,
                    currentOpeningTime: parkingFeature.getCurrentOpeningTime(),
                  ),
                ),
              if (parkingFeature.url != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        launch(parkingFeature.url!);
                      },
                      child: Text(
                        localeName == 'en' ? "More info" : "Mehr Infos",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          isOnlyDestination: isOnlyDestination,
          locationData: LocationDetail(
            parkingFeature.name ?? "",
            "",
            parkingFeature.position,
          ),
        ),
      ],
    );
  }
}

class OpeningTimeTable extends StatefulWidget {
  final SimpleOpeningHours openingHours;
  final bool isOpenParking;
  final String? currentOpeningTime;
  const OpeningTimeTable({
    super.key,
    required this.openingHours,
    required this.isOpenParking,
    this.currentOpeningTime,
  });

  @override
  State<OpeningTimeTable> createState() => _OpeningTimeTableState();
}

class _OpeningTimeTableState extends State<OpeningTimeTable> {
  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    final theme = Theme.of(context);
    final isAlwaysOpen = widget.openingHours.inp == '24/7';
    final weekday = DateTime.now().weekday;
    return Column(
      children: [
        ExpansionTile(
          textColor: Colors.black,
          collapsedIconColor: Colors.black,
          iconColor: Colors.red,
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          title: Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${localizationST.commonNow} ",
                style: theme.textTheme.bodyMedium,
              ),
              widget.isOpenParking
                  ? Text(
                      "${localizationST.commonOpen} : ${widget.currentOpeningTime}",
                      style: theme.textTheme.bodyMedium,
                    )
                  : Text(
                      localizationST.commonClosed,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
            ],
          ),
          children: [
            isAlwaysOpen
                ? Text(
                    localizationST.commonOpenAlways,
                  )
                : Column(
                    children: widget.openingHours.openingHours.entries.map(
                      (day) {
                        bool isBold = widget.openingHours.openingHours.keys
                                .toList()[weekday - 1] ==
                            day.key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                SimpleOpeningHours.getDayName(
                                    day.key, localizationST),
                                style: TextStyle(
                                  fontWeight: isBold ? FontWeight.bold : null,
                                ),
                              ),
                              Column(
                                children: day.value.isNotEmpty
                                    ? day.value
                                        .map((e) => Text(
                                              e,
                                              style: TextStyle(
                                                fontWeight: isBold
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                            ))
                                        .toList()
                                    : [Text(localizationST.commonClosed)],
                              )
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ],
    );
  }
}
