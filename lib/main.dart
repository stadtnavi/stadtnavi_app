import 'package:flutter/material.dart';

import 'package:stadtnavi_app/configuration_service.dart';
import 'package:stadtnavi_app/custom_between_fab/report_defects_button.dart';
import 'package:stadtnavi_app/custom_layers/map_layers/map_leyers.dart';
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:stadtnavi_app/custom_search_location/online_search_location.dart';
import 'package:stadtnavi_app/custom_social_media/youtube_social_media.dart';
import 'package:stadtnavi_app/theme.dart';

import 'package:trufi_core/models/social_media/facebook_social_media.dart';
import 'package:trufi_core/models/social_media/instagram_social_media.dart';
import 'package:trufi_core/models/social_media/twitter_social_media.dart';
import 'package:trufi_core/trufi_app.dart';

import 'custom_layers/services/graphl_client/hive_init.dart';
import 'custom_social_media/impressum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  // Run app
  runApp(
    TrufiApp(
      theme: stadtnaviTheme,
      bottomBarTheme: bottomBarTheme,
      configuration: setupTrufiConfiguration(),
      customLayers: customLayers,
      mapTileProviders: [
        MapLayer(MapLayerIds.streets),
        MapLayer(MapLayerIds.satellite),
        MapLayer(MapLayerIds.bike),
      ],
      searchLocationManager: OnlineSearchLocation(),
      socialMediaItem: [
        FacebookSocialMedia("https://www.facebook.com/stadtnavi/"),
        InstagramSocialMedia("https://www.instagram.com/stadtnavi/"),
        TwitterSocialMedia("https://twitter.com/stadtnavi"),
        YoutubeSocialMedia(
          "https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA",
        ),
        ImpressumMedia("https://www.herrenberg.de/impressum"),
      ],
      customBetweenFabBuilder: (contexts) {
        return Column(
          children: const [ReportDefectsButoon()],
        );
      },
    ),
  );
}
