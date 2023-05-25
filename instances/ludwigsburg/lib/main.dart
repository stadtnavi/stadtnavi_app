import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ludwigsburg/firebase_options.dart';
import 'package:ludwigsburg/lifecycle_reactor_handler_notifications.dart';
import 'package:ludwigsburg/tools.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/map_leyers.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.instance.getToken().then((value) {
    print(value);
  }).catchError((error) {
    print("$error");
  });
  await messaging
      .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )
      .catchError((error) => {print("$error")});
  await initHiveForFlutter();
  // TODO we need to improve disable fetch˜ method
  WeatherLayer.isdisable = true;
  // TODO we need to improve enableCarpool
  SettingPanel.enableCarpool = false;
  // TODO we need to improve TransportMode Configuration
  TransportModeConfiguration.configure(transportColors: {
    TransportMode.walk: const Color(0xffFECC01),
    TransportMode.bicycle: const Color(0xffffc200),
  });
  // TODO we need to improve ParkingFeature.calculateAvailavility
  ParkingFeature.calculateAvailavility = calculateParkingAvailavilityLB;

  runApp(
    StadtnaviApp(
      appLifecycleReactorHandler: AppLifecycleReactorHandlerNotifications(
        onStartNotificationsURL:
            'https://us-central1-stadtnavi-ludwigsburg.cloudfunctions.net/onStartNotifications',
      ),
      appName: 'stadtnavi',
      appNameTitle: 'stadtnavi|ludwigsburg',
      cityName: 'Ludwigsburg',
      center: LatLng(48.895195, 9.188647),
      otpGraphqlEndpoint: openTripPlannerUrl,
      urlFeedback: 'mailto:b.hofmann@ludwigsburg.de?subject=Feedback',
      urlShareApp: 'https://stadtnavi.swlb.de/',
      urlRepository: 'https://github.com/trufi-association/trufi-app',
      urlImpressum: 'https://www.ludwigsburg.de/stadtnavi-impressum',
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
      mapTileProviders: [
        MapLayer(MapLayerIds.streets),
        MapLayer(MapLayerIds.satellite),
        MapLayer(MapLayerIds.terrain),
      ],
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
