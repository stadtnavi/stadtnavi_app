import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/parking/parking_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingMarkerModal extends StatelessWidget {
  final ParkingFeature parkingFeature;
  const ParkingMarkerModal({Key key, @required this.parkingFeature})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    final localeName = localization.localeName;
    String spaces;
    if (parkingFeature.total != null) {
      if (parkingFeature.free != null) {
        spaces = localeName == 'en'
            ? "${parkingFeature.free} of ${parkingFeature.total} parking spaces available"
            : "${parkingFeature.free} von ${parkingFeature.total} Stellplätzen verfügbar";
      } else {
        spaces =
            "${parkingFeature.total} ${localeName == 'en' ? 'parking spaces' : 'Stellplätze'}";
      }
      if (parkingFeature.state == "closed") {
        spaces += " (closed)";
      }
    }
    String disabledSpaces;
    if (parkingFeature.totalDisabled != null &&
        parkingFeature.freeDisabled != null) {
      disabledSpaces = localeName == 'en'
          ? "${parkingFeature.freeDisabled} of ${parkingFeature.totalDisabled} wheelchair-accessible parking spaces available"
          : "${parkingFeature.freeDisabled} von ${parkingFeature.totalDisabled} rollstuhlgerechten Parkplätzen vorhanden";
    }
    final notes = jsonDecode(parkingFeature.notes ?? "{}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      parkingFeature.openingHours.replaceAll("; ", "\n"),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              if (notes[localeName] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    Text(
                      "${notes[localeName]}",
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
        )
      ],
    );
  }
}
