import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:trufi_core/blocs/configuration/configuration.dart';
import 'package:trufi_core/blocs/configuration/models/animation_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/attribution.dart';
import 'package:trufi_core/blocs/configuration/models/language_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/map_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/url_collection.dart';
import 'package:trufi_core/models/definition_feedback.dart';
import 'package:trufi_core/models/enums/server_type.dart';
import 'package:url_launcher/url_launcher.dart';

import 'marker_configuration/custom_marker_configuration.dart';

Configuration setupTrufiConfiguration() {

  // Attribution
  final attribution = Attribution(
    representatives: [
      "Christoph Hanser",
      "Samuel Rioja",
    ],
    team: [
      "Andreas Helms",
      "Annika Bock",
      "Christian Brückner",
      "Javier Rocha",
      "Luz Choque",
      "Malte Dölker",
      "Martin Kleppe",
      "Michael Brückner",
      "Natalya Blanco",
      "Neyda Mili",
      "Raimund Wege",
    ],
    translators: [
      "Gladys Aguilar",
      "Jeremy Maes",
      "Gaia Vitali Roscini",
    ],
    routes: [
      "Trufi team",
      "Guia Cochala team",
    ],
    openStreetMap: [
      "Marco Antonio",
      "Noémie",
      "Philipp",
      "Felix D",
      "Valor Naram",
    ],
  );

  // Urls
  final urls = UrlCollection(
    routeFeedbackUrl:
        "https://trufifeedback.z15.web.core.windows.net/route.html",
    donationUrl: "http://www.trufi.app/donate-inapp",
    openTripPlannerUrl:
        "https://api.dev.stadtnavi.eu/routing/v1/router/index/graphql",
    shareUrl: "https://appurl.io/BOPP7QnKX",
  );

  // Map
  final map = MapConfiguration(
    defaultZoom: 13.0,
    onlineMaxZoom: 18,
    center: LatLng(48.5950, 8.8672),
    southWest: LatLng(-17.79300, -66.75000),
    northEast: LatLng(-16.90400, -65.67400),
    mapAttributionBuilder: stadtNaviAttributionBuilder,
  );

  // Languages
  final languages = [
    LanguageConfiguration("de", "DE", "Deutsch"),
    LanguageConfiguration("en", "US", "English", isDefault: true)
  ];

  final feedbackDefinition = FeedbackDefinition(
    FeedBackType.url,
    "https://stadtnavi.de/feedback/",
  );

  final customTranslations = TrufiCustomLocalizations()
    ..title = {const Locale("de"): "Stadtnavi", const Locale("en"): "Stadtnavi"}
    ..tagline = {
      const Locale("de"): "Herrenberg",
      const Locale("en"): "Herrenberg"
    };

  return Configuration(
    customTranslations: customTranslations,
    feedbackDefinition: feedbackDefinition,
    supportedLanguages: languages,
    serverType: ServerType.graphQLServer,
    teamInformationEmail: "info@trufi.app",
    attribution: attribution,
    animations: AnimationConfiguration(),
    markers: const CustomMarkerConfiguration(),
    map: map,
    urls: urls,
  );
}

Widget stadtNaviAttributionBuilder(BuildContext context) {
  final theme = Theme.of(context);
  final languageCode = Localizations.localeOf(context).languageCode;
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
          ),
          text:
              "© OpenStreetMap ${languageCode == 'en' ? "" : "Mitwirkende"}\n",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.openstreetmap.org/copyright");
            },
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
          ),
          text: languageCode == 'en'
              ? "Datasets by "
              : "Datensätze der NVBW GmbH\n",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.nvbw.de/open-data");
            },
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
          ),
          text: "VVS GmbH",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.openvvs.de/dataset/gtfs-daten");
            },
        ),
      ],
    ),
  );
}
