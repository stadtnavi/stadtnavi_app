import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:stadtnavi_app/offer_carpool/offer_carpool_screen.dart';
import 'package:trufi_core/blocs/configuration/configuration.dart';
import 'package:trufi_core/blocs/configuration/models/transport_configuration.dart';
import 'package:trufi_core/utils/text/outlined_text.dart';
import 'package:trufi_core/blocs/configuration/models/animation_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/attribution.dart';
import 'package:trufi_core/blocs/configuration/models/language_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/map_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/url_collection.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/definition_feedback.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';
import 'package:trufi_core/models/enums/server_type.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_section/about_section.dart';
import 'marker_configuration/custom_marker_configuration.dart';

const baseDomain = "api.stadtnavi.de";
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
    openTripPlannerUrl: "https://$baseDomain/routing/v1/router/index/graphql",
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
    LanguageConfiguration("de", "DE", "Deutsch", isDefault: true),
    LanguageConfiguration("en", "US", "English")
  ];

  Widget aboutSection(context) {
    return const AboutSection();
  }

  final feedbackDefinition = FeedbackDefinition(
    FeedBackType.url,
    "https://stadtnavi.de/feedback/",
  );

  final customTranslations = TrufiCustomLocalizations()
    ..title = {const Locale("de"): "stadtnavi", const Locale("en"): "stadtnavi"}
    ..tagline = {
      const Locale("de"): "Herrenberg",
      const Locale("en"): "Herrenberg"
    };

  return Configuration(
      customTranslations: customTranslations,
      feedbackDefinition: feedbackDefinition,
      aboutSection: aboutSection,
      supportedLanguages: languages,
      serverType: ServerType.graphQLServer,
      teamInformationEmail: "info@trufi.app",
      attribution: attribution,
      animations: AnimationConfiguration(success: null),
      markers: const CustomMarkerConfiguration(),
      transportConf: const TransportConfiguration(showTransportMarker: false),
      map: map,
      urls: urls,
      planItineraryLegBuilder: (context, leg) {
        final theme = Theme.of(context);
        final localization = TrufiLocalization.of(context);
        final localeName = localization.localeName;
        return leg.transportMode == TransportMode.car
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(primary: theme.primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OfferCarpoolScreen(planItineraryLeg: leg),
                    ),
                  );
                },
                child: Text(
                  localeName == "en"
                      ? "Offer carpool"
                      : "Fahrgemeinschaft anbieten",
                ),
              )
            : Container();
      });
}

Widget stadtNaviAttributionBuilder(BuildContext context) {
  final theme = Theme.of(context);
  final languageCode = Localizations.localeOf(context).languageCode;
  final List<Shadow> shadows = outlinedText(
    strokeColor: Colors.white.withOpacity(.3),
    precision: 2,
  );
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
          ),
          text:
              "© OpenStreetMap ${languageCode == 'en' ? "Contributors" : "Mitwirkende"},\n",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.openstreetmap.org/copyright");
            },
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
            shadows: shadows,
          ),
          text: languageCode == 'en' ? "Datasets by " : "Datensätze der ",
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
          ),
          text: "NVBW GmbH",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.nvbw.de/open-data");
            },
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
            shadows: shadows,
          ),
          text: languageCode == 'en' ? " and " : " und ",
        ),
        TextSpan(
          style: theme.textTheme.caption.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
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
