import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layer_local_storage.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';

import 'package:trufi_core/base/utils/graphql_client/hive_init.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';

import 'branding_ludwigsburg.dart';
import 'static_layer.dart';

const baseDomain = "api.stadtnavi.de";
String openTripPlannerUrl =
    "https://$baseDomain/routing/v1/router/index/graphql";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(boxes: [
    ...listPathsHive,
    MapRouteCubit.path,
    MapModesCubit.path,
    SettingFetchCubit.path,
    CustomLayerLocalStorage.path,
  ]);
  runApp(
    StadtnaviApp(
      appName: 'stadtnavi',
      appNameTitle: 'stadtnavi|ludwigsburg',
      cityName: 'Ludwigsburg',
      center: LatLng(48.895195, 9.188647),
      otpGraphqlEndpoint: openTripPlannerUrl,
      urlFeedback: 'https://stadtnavi.de/feedback/',
      urlShareApp: 'https://ludwigsburg.stadtnavi.eu',
      urlRepository: 'https://github.com/trufi-association/trufi-app',
      layersContainer: customLayersLudwigsburg,
      urlSocialMedia: const UrlSocialMedia(
        urlFacebook: 'https://www.facebook.com/stadtnavi/',
        urlInstagram: 'https://www.instagram.com/stadtnavi/',
        urlTwitter: 'https://twitter.com/stadtnavi',
        urlYoutube: 'https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA',
      ),
      // https://www.ludwigsburg.de/LB2020/impressum.html
      // https://maengelmelder.service-bw.de/

      // "focus.point.lat": "48.895195",
      // "focus.point.lon": "9.188647",
      trufiBaseTheme: TrufiBaseTheme(
        themeMode: ThemeMode.light,
        brightness: Brightness.light,
        theme: brandingStadtnaviLudwigsburg,
        darkTheme: brandingStadtnaviLudwigsburgDark,
      ),
    ),
  );
}
