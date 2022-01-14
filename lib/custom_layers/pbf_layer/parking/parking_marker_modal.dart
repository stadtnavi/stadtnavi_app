import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:trufi_core/widgets/custom_location_selector.dart';

class ParkingMarkerModal extends StatelessWidget {
  final ParkingFeature parkingFeature;
  final void Function() onFetchPlan;
  const ParkingMarkerModal({
    Key key,
    @required this.parkingFeature,
    @required this.onFetchPlan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    final localeName = localization.localeName;
    String spaces;
    if (parkingFeature.carPlacesCapacity != null) {
      if (parkingFeature.availabilityCarPlacesCapacity != null) {
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
    String disabledSpaces;
    if (parkingFeature.totalDisabled != null &&
        parkingFeature.freeDisabled != null) {
      disabledSpaces = localeName == 'en'
          ? "${parkingFeature.freeDisabled} of ${parkingFeature.totalDisabled} wheelchair-accessible parking spaces available"
          : "${parkingFeature.freeDisabled} von ${parkingFeature.totalDisabled} rollstuhlgerechten Parkplätzen vorhanden";
    }
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
                  parkingFeature.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
              if (parkingFeature.openingHours != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    Text(
                      localeName == 'en' ? "OPENING HOURS" : "ÖFFNUNGSZEITEN",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localeName == 'en'
                          ? parkingFeature.openingHours.replaceAll("; ", "\n")
                          : _parseAbbreviationDE(parkingFeature.openingHours
                              .replaceAll("; ", "\n")),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              if (parkingFeature.note != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    Text(
                      parkingFeature.note,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              if (parkingFeature.url != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        launch(parkingFeature.url);
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
          locationData: LocationDetail(
            parkingFeature.name ?? "",
            "",
            parkingFeature.position,
          ),
        ),
      ],
    );
  }

  String _parseAbbreviationDE(String msg) {
    final weekDaysEn = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final weekDaysDe = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    String parsedDe = msg;
    for (var i = 0; i < weekDaysEn.length; i++) {
      parsedDe = parsedDe.replaceAll(weekDaysEn[i], weekDaysDe[i]);
    }
    if (parsedDe.contains('PH off')) {
      parsedDe = parsedDe.replaceAll('PH off', 'Gesetzlicher Feiertag Geschlossen');
    } else {
      parsedDe = parsedDe.replaceAll('PH', 'Gesetzlicher Feiertag');
    }

    return parsedDe;
  }
}
