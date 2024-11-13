import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_base64.dart';

class AboutSection extends StatelessWidget {
  static const _padding = EdgeInsets.only(top: 16.0);

  const AboutSection({
    Key? key,
    required this.appName,
    required this.cityName,
  }) : super(key: key);

  final String appName;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLanguageEn = Localizations.localeOf(context).languageCode == 'en';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLanguageEn ? 'About this service' : 'Über diesen Dienst',
          style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? '$appName is a travel planning application for the city of $cityName and its surroundings. This service includes public transport, footpaths, cycling, street and parking information, charging infrastructure and sharing offerings. The mobility offerings are connected through intermodal routing.'
                : '$appName ist eine Reiseplanungs-Anwendung für die Stadt $cityName und Umgebung. Dieser Dienst umfasst ÖPNV, Fußwege, Radverkehr, Straßen- und Parkplatzinformationen, Ladeinfrastruktur und Sharing-Angebote. Mobilitätsangebote werden durch intermodales Routing miteinander vernetzt.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Contribute:' : 'Mitmachen:',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            isLanguageEn
                ? 'The city of $cityName has developed this app, funded by the Federal Ministry of Transport and Digital Infrastructure (BMVI), as model city. The $appName app is an open source solution and can be used, customized and further developed by other municipalities to meet individual needs (white lable solution). Participation is welcome!'
                : 'Die Stadt $cityName hat diese App im Rahmen der Modellstadt, gefördert durch das Bundesministerium für Verkehr und digitale Infrastruktur (BMVI) entwickelt. $appName ist eine Open Source Lösung und kann von anderen Kommunen und Akteuren unter ihrem Namen und Erscheinungsbild verwendet und an individuelle Bedürfnisse angepasst und weiterentwickelt werden (White Label Lösung). Mitmachen ist gewünscht!',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Funded by' : 'Gefördert durch',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 250,
          child: Image.memory(base64Decode(imageAboutSection)),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Digitransit platform' : 'Digitransit Plattform',
            style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? 'This service is based on the Digitransit Platform and the backend service OpenTripPlanner. All software is available under an open license. Thanks to everyone involved.'
                : 'Dieser Dienst basiert auf der Digitransit Platform und dem Backend-Dienst OpenTripPlanner. Alle Software ist unter einer offenen Lizenzen verfügbar. Vielen Dank an alle Beteiligten.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn ? 'Data sources' : 'Datenquellen',
            style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: RichText(
            text: TextSpan(
              text: isLanguageEn ? 'Card data ' : 'Kartendaten: © ',
              style: theme.textTheme.bodyLarge,
              children: <TextSpan>[
                TextSpan(
                  text: isLanguageEn
                      ? 'OpenStreetMap Contributors'
                      : 'OpenStreetMap Mitwirkende',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.primaryColor,
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
              style: theme.textTheme.bodyLarge,
              children: <TextSpan>[
                TextSpan(
                  text: 'NVBW GmbH',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.primaryColor,
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
                  style: theme.textTheme.bodyLarge,
                ),
                TextSpan(
                  text: 'VVS GmbH',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.primaryColor,
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
                  style: theme.textTheme.bodyLarge,
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
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
