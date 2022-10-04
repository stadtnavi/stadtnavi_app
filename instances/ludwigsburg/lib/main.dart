import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layer_local_storage.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';

import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';

import 'branding_ludwigsburg.dart';
import 'components/share_itinerary_button.dart';
import 'configuration_routes.dart';
import 'static_layer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatedLetsencryptAndroid.workAroundCertificated();
  await initHiveForFlutter();
  // TODO we need to improve disable fetch method
  WeatherLayer.isdisable = true;
  // TODO we need to improve enableCarpool
  SettingPanel.enableCarpool = false;
  runApp(
    StadtnaviApp(
      appName: 'stadtnavi',
      appNameTitle: 'stadtnavi|ludwigsburg',
      cityName: 'Ludwigsburg',
      center: LatLng(48.895195, 9.188647),
      otpGraphqlEndpoint: openTripPlannerUrl,
      urlFeedback: 'https://stadtnavi.de/feedback/',
      urlShareApp: 'https://stadtnavi.swlb.de/',
      urlRepository: 'https://github.com/trufi-association/trufi-app',
      urlImpressum: 'https://www.ludwigsburg.de/LB2020/impressum.html',
      reportDefectsUri: Uri.parse(
          'https://www.ludwigsburg.de/start/rathaus+und+service/maengelmelder.html'),
      layersContainer: customLayersLudwigsburg,
      urlSocialMedia: const UrlSocialMedia(
        urlFacebook: 'https://de-de.facebook.com/ludwigsburg/',
        urlInstagram:
            'https://www.instagram.com/accounts/login/?next=/ludwigsburg.de/',
      ),
      searchLocationQueryParameters: const {
        "focus.point.lat": "48.895195",
        "focus.point.lon": "9.188647",
      },
      trufiBaseTheme: TrufiBaseTheme(
        themeMode: ThemeMode.light,
        brightness: Brightness.light,
        theme: brandingStadtnaviLudwigsburg,
        darkTheme: brandingStadtnaviLudwigsburg,
      ),
      extraDrawerItems: extraDrawerItems,
      extraRoutes: extraRoutes,
      extraBlocs: extraBlocs,
      extraFloatingMapButtons: extraButtons,
    ),
  );
}
