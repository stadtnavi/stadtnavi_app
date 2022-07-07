import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  static const _padding = EdgeInsets.only(top: 16.0);
  static const _paddingPart = EdgeInsets.only(top: 24.0);

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
          style: theme.textTheme.subtitle1?.copyWith(
              color: theme.textTheme.bodyText1?.color,
              fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: _padding,
          child: Text(
            isLanguageEn
                ? '$appName $cityName is a travel planning application for the city of $cityName and its surroundings. This service includes public transport, footpaths, cycling, street and parking information, charging infrastructure and sharing offerings. The mobility offerings are connected through intermodal routing.'
                : '$appName $cityName ist eine Reiseplanungs-Anwendung für die Stadt $cityName und Umgebung. Dieser Dienst umfasst ÖPNV, Fußwege, Radverkehr, Straßen- und Parkplatzinformationen, Ladeinfrastruktur und Sharing-Angebote. Mobilitätsangebote werden durch intermodales Routing miteinander vernetzt.',
            style: theme.textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: _paddingPart,
          child: Text(
            isLanguageEn ? 'Contribute' : 'Mitmachen',
            style: theme.textTheme.subtitle1?.copyWith(
                color: theme.textTheme.bodyText1?.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyText1,
              children: [
                TextSpan(
                  text: isLanguageEn
                      ? 'The Stadtwerke Ludwigsburg have developed this app, based on stadtnavi Herrenberg, which was funded by the Federal Ministry of Transport and Digital Infrastructure (BMDV). The stadtnavi app is an open source solution, '
                      : 'stadtnavi Ludwigsburg basiert auf dem BMVI-geförderten Projekt stadtnavi Herrenberg. stadtnavi Anwendung ist eine Open Source Lösung, ',
                ),
                TextSpan(
                  text: isLanguageEn
                      ? 'available via GitHub'
                      : 'auf GitHub verfügbar',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://github.com/stadtnavi/digitransit-ui';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                ),
                TextSpan(
                  text: isLanguageEn
                      ? ', and can be used, customized and further developed by other municipalities to meet individual needs (white lable solution). Participation is welcome!'
                      : ', und kann von anderen Kommunen und Akteuren unter ihrem Namen und Erscheinungsbild verwendet und an individuelle Bedürfnisse angepasst und weiterentwickelt werden (White Label Lösung). Mitmachen ist gewünscht!',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 250,
          child: Image.asset(
            'assets/images/funded-image.png',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: _paddingPart,
          child: Text(
            isLanguageEn ? 'Digitransit platform' : 'Digitransit Plattform',
            style: theme.textTheme.subtitle1?.copyWith(
                color: theme.textTheme.bodyText1?.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: isLanguageEn
              ? Text(
                  'The Digitransit service platform is an open source routing platform developed by HSL and Traficom. It builds on OpenTripPlanner by Conveyal. Enhancements by Transportkollektiv and MITFAHR|DE|ZENTRALE. All software is open source. Thanks to everybody working on this!',
                  style: theme.textTheme.bodyText1,
                )
              : Column(
                  children: [
                    Text(
                      'Dieser Dienst basiert auf der Digitransit Platform und dem Backend-Dienst OpenTripPlanner. Alle Software ist unter einer offenen Lizenzen verfügbar. Vielen Dank an alle Beteiligten.',
                      style: theme.textTheme.bodyText1,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyText1,
                        children: [
                          const TextSpan(
                            text:
                                'Der gesamte Quellcode der Plattform, die aus vielen verschiedenen Komponenten besteht, ist auf ',
                          ),
                          TextSpan(
                            text: 'Github',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://github.com/stadtnavi/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              },
                          ),
                          const TextSpan(
                            text: ' verfügbar.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        Padding(
          padding: _paddingPart,
          child: Text(
            isLanguageEn ? 'Data sources' : 'Datenquellen',
            style: theme.textTheme.subtitle1?.copyWith(
                color: theme.textTheme.bodyText1?.color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: _padding,
          child: RichText(
            text: TextSpan(
              text: isLanguageEn ? 'Map data: © ' : 'Kartendaten: © ',
              style: theme.textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                  text: isLanguageEn
                      ? 'OpenStreetMap Contributors'
                      : 'OpenStreetMap Mitwirkende',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.colorScheme.primary,
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
                  ? 'Public transit data: Datasets by '
                  : 'ÖPNV-Daten: Datensätze der ',
              style: theme.textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                  text: 'NVBW GmbH',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.colorScheme.primary,
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
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: theme.colorScheme.primary,
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
                      ? ', Shapes (d.h. Geometries of transit routes) enhanced with OpenStreetMap data © OpenStreetMap contributors'
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
                ? 'No responsibility is accepted for the accuracy of this information.'
                : 'Alle Angaben ohne Gewähr.',
            style: theme.textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
