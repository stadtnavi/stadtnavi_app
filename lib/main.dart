import 'package:flutter/material.dart';
import 'package:stadtnavi_app/configuration_service.dart';
import 'package:stadtnavi_app/custom_layers/layer.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/static_pbf_layer.dart';
import 'package:stadtnavi_app/custom_search_location/online_search_location.dart';
import 'package:stadtnavi_app/custom_social_media/youtube_social_media.dart';
import 'package:stadtnavi_app/map_layers/map_leyers.dart';
import 'package:stadtnavi_app/theme.dart';
import 'package:trufi_core/models/social_media/facebook_social_media.dart';
import 'package:trufi_core/models/social_media/instagram_social_media.dart';
import 'package:trufi_core/models/social_media/twitter_social_media.dart';
import 'package:trufi_core/trufi_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Run app
  runApp(
    TrufiApp(
      theme: stadtnaviTheme,
      configuration: setupTrufiConfiguration(),
      customLayers: [
        cifsLayer,
        ...stopsLayers.values,
        parkingLayer,
        citybikeLayer,
        bikeParkLayer,
        Layer(LayerIds.publicToilets),
        Layer(LayerIds.charging),
        Layer(LayerIds.bicycleParking),
        Layer(LayerIds.bicycleInfrastructure),
        Layer(LayerIds.lorawanGateways)
      ],
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
      ],
    ),
  );
}
