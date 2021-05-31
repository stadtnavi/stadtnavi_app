import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_base64.dart';

class AboutSection extends StatelessWidget {
  static const _padding = EdgeInsets.only(top: 16.0);

  const AboutSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLanguageEn = Localizations.localeOf(context).languageCode == 'en';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLanguageEn ? 'About this service' : 'Über diesen Dienst',
          style: theme.textTheme.subtitle1.copyWith(
              color: theme.textTheme.bodyText1.color,
              fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? 'Stadtnavi is a travel planning application for the Herrenberg region. This service includes public transport, footpaths, cycling, car routing (including Park & Ride) and car pooling.\n\nFunded by'
                : 'Stadtnavi ist eine Reiseplannungs-Anwendung für die Region Herrenberg. Dieser Dienst umfasst ÖPNV, Fußwege, Radverkehr, PKW-Routing (inklusive Park & Ride) und Fahrgemeinschaften.\n\nGefördert durch',
            style: theme.textTheme.bodyText1,
          ),
        ),
        SizedBox(
          width: 250,
          child: Image.memory(base64Decode(imageAboutSection)),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Digitransit platform' : 'Digitransit Plattform',
            style: theme.textTheme.subtitle1.copyWith(
                color: theme.textTheme.bodyText1.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? 'This service is based on the Digitransit Platform and the backend service OpenTripPlanner. All software is available under an open license. Thanks to everyone involved.'
                : 'Dieser Dienst basiert auf der Digitransit Platform und dem Backend-Dienst OpenTripPlanner. Alle Software ist unter einer offenen Lizenzen verfügbar. Vielen Dank an alle Beteiligten.',
            style: theme.textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Data sources' : 'Datenquellen',
            style: theme.textTheme.subtitle1.copyWith(
                color: theme.textTheme.bodyText1.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: RichText(
            text: TextSpan(
              text: isLanguageEn ? 'Card data' : 'Kartendaten: © ',
              style: theme.textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                  text: isLanguageEn
                      ? 'OpenStreetMap Contributors'
                      : 'OpenStreetMap Mitwirkende',
                  style: theme.textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://www.openstreetmap.org/#map=7/48.59523/8.86648';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: _padding,
          child: RichText(
            text: TextSpan(
              text: isLanguageEn
                  ? 'ÖPNV-data: Datasets from '
                  : 'ÖPNV-Daten: Datensätze der ',
              style: theme.textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                  text: 'NVBW GmbH',
                  style: theme.textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://www.nvbw.de/open-data';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                ),
                TextSpan(
                  text: isLanguageEn ? ' and ' : ' und der ',
                  style: theme.textTheme.bodyText1,
                ),
                TextSpan(
                  text: 'VVS GmbH',
                  style: theme.textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://www.openvvs.de/dataset/gtfs-daten';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                ),
                TextSpan(
                  text: isLanguageEn
                      ? ', shapes (i.e. geometries of the routes) each enriched with OpenStreetMap data © OpenStreetMap Contributors'
                      : ', Shapes (d.h. Geometrien der Streckenverläufe) jeweils angereichert mit OpenStreetMap-Daten © OpenStreetMap Mitwirkende',
                  style: theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? 'All statements without guarantee.'
                : 'Alle Angaben ohne Gewähr.',
            style: theme.textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
