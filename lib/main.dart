import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:latlong/latlong.dart';
import 'package:stadtnavi_app/custom_layers/layer.dart';
import 'package:stadtnavi_app/custom_social_media/youtube_social_media.dart';
import 'package:stadtnavi_app/map_layers/map_leyers.dart';
import 'package:stadtnavi_app/theme.dart';
import 'package:trufi_core/models/definition_feedback.dart';
import 'package:trufi_core/trufi_app.dart';
import 'package:trufi_core/trufi_configuration.dart';

import 'package:trufi_core/models/social_media/facebook_social_media.dart';
import 'package:trufi_core/models/social_media/instagram_social_media.dart';
import 'package:trufi_core/models/social_media/twitter_social_media.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final trufiCfg = TrufiConfiguration();
  final globalCfg = GlobalConfiguration();
  await globalCfg.loadFromAsset("app_config");

  trufiCfg.map.mapTilerKey = globalCfg.getValue<String>("mapTilerKey");

  // Abbreviations
  trufiCfg.abbreviations.addAll({
    "Avenida": "Av.",
    "Calle": "C.",
    "Camino": "C.º",
  });

  // Animation
  trufiCfg.animation.loading = const FlareActor(
    "assets/images/loading.flr",
    animation: "Trufi Drive",
  );
  trufiCfg.animation.success = const FlareActor(
    "assets/images/success.flr",
    animation: "Untitled",
  );

  // Attribution
  trufiCfg.attribution.representatives.addAll([
    "Christoph Hanser",
    "Samuel Rioja",
  ]);
  trufiCfg.attribution.team.addAll([
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
  ]);
  trufiCfg.attribution.translations.addAll([
    "Gladys Aguilar",
    "Jeremy Maes",
    "Gaia Vitali Roscini",
  ]);
  trufiCfg.attribution.routes.addAll([
    "Trufi team",
    "Guia Cochala team",
  ]);
  trufiCfg.attribution.osm.addAll([
    "Marco Antonio",
    "Noémie",
    "Philipp",
    "Felix D",
    "Valor Naram", // Sören Reinecke
  ]);

  // Email
  trufiCfg.email.feedback = globalCfg.getValue<String>("emailFeedback");
  trufiCfg.email.info = globalCfg.getValue<String>("emailInfo");

  // Image
  trufiCfg.image.drawerBackground = "assets/images/drawer-bg.jpg";

  // Map
  trufiCfg.map.defaultZoom = 13.0;
  trufiCfg.map.offlineMinZoom = 8.0;
  trufiCfg.map.offlineMaxZoom = 14.0;
  trufiCfg.map.offlineZoom = 13.0;
  trufiCfg.map.onlineMinZoom = 1.0;
  trufiCfg.map.onlineMaxZoom = 18;
  trufiCfg.map.onlineZoom = 13.0;
  trufiCfg.map.chooseLocationZoom = 16.0;
  trufiCfg.map.center = LatLng(48.5950, 8.8672);
  trufiCfg.map.southWest = LatLng(-17.79300, -66.75000);
  trufiCfg.map.northEast = LatLng(-16.90400, -65.67400);
  trufiCfg.map.buildMapAttribution = (context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            style: theme.textTheme.caption.copyWith(
              color: Colors.black,
            ),
            text: "© OpenStreetMap Mitwirkende\n",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch("https://www.openstreetmap.org/copyright");
              },
          ),
          TextSpan(
            style: theme.textTheme.caption.copyWith(
              color: Colors.black,
            ),
            text: "Datensätze der NVBW GmbH\n",
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
  };

  // Languages
  trufiCfg.languages.addAll([
    TrufiConfigurationLanguage(
      languageCode: "de",
      countryCode: "DE",
      displayName: "Deutsch",
    ),
    TrufiConfigurationLanguage(
      languageCode: "en",
      countryCode: "US",
      displayName: "English",
      isDefault: true,
    )
  ]);

  // Url
  trufiCfg.url.otpEndpoint = globalCfg.getValue<String>("urlOtpEndpoint");
  trufiCfg.url.adsEndpoint = globalCfg.getValue<String>("urlAdsEndpoint");
  trufiCfg.url.routeFeedback = globalCfg.getValue<String>("urlRouteFeedback");
  trufiCfg.url.donate = globalCfg.getValue<String>("urlDonate");
  trufiCfg.url.website = globalCfg.getValue<String>("urlWebsite");
  trufiCfg.url.facebook = globalCfg.getValue<String>("urlFacebook");
  trufiCfg.url.twitter = globalCfg.getValue<String>("urlTwitter");
  trufiCfg.url.instagram = globalCfg.getValue<String>("urlInstagram");
  trufiCfg.url.share = globalCfg.getValue<String>("urlShare");
  trufiCfg.generalConfiguration.serverType = ServerType.graphQLServer;
  _setupCustomTrufiLocalization();
  // TODO: improve load map tile key
  final String mapTilerKey = globalCfg.getValue<String>("mapTilerKey");
  // Run app
  runApp(TrufiApp(
    theme: stadtnaviTheme,
    customLayers: [
      Layer(LayerIds.publicToilets),
      Layer(LayerIds.charging),
      Layer(LayerIds.bicycleParking),
      Layer(LayerIds.bicycleInfrastructure),
      Layer(LayerIds.lorawanGateways)
    ],
    mapTileProviders: [
      MapLayer(
        MapLayerIds.streets,
        mapTilerKey,
      ),
      MapLayer(
        MapLayerIds.satellite,
        mapTilerKey,
      ),
      MapLayer(
        MapLayerIds.bike,
        mapTilerKey,
      ),
    ],
    feedBack: DefinitionFeedBack(
      FeedBackType.url,
      "https://stadtnavi.de/feedback/",
    ),
    socialMediaItem: [
      FacebookSocialMedia("https://www.facebook.com/stadtnavi/"),
      InstagramSocialMedia("https://www.instagram.com/stadtnavi/"),
      TwitterSocialMedia("https://twitter.com/stadtnavi"),
      YoutubeSocialMedia(
        "https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA",
      ),
    ],
  ));
}

/// This is an example on how to customize your application
/// We override the singleton of [TrufiConfiguration.customTranslations] with
/// the corresponding Map of Locale to TranslationString
void _setupCustomTrufiLocalization() {
  TrufiConfiguration().customTranslations
    ..title = {const Locale("de"): "Stadtnavi", const Locale("en"): "Stadtnavi"}
    ..tagline = {
      const Locale("de"): "Herrenberg",
      const Locale("en"): "Herrenberg"
    };
}
