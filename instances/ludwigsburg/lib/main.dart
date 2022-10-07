import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ludwigsburg/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';
import 'package:trufi_core/base/widgets/alerts/base_build_alert.dart';
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
  // TODO we need to improve disable fetch method
  WeatherLayer.isdisable = true;
  // TODO we need to improve enableCarpool
  SettingPanel.enableCarpool = false;
  runApp(
    StadtnaviApp(
      appLifecycleReactorHandler: AppLifecycleReactorHandlerNotifications(),
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

class AppLifecycleReactorHandlerNotifications
    implements AppLifecycleReactorHandler {
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  @override
  void onInitState(context) {
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        showTrufiDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('${message.notification!.title}'),
                content: Text('${message.notification!.body}'),
              );
            });
      }
    });
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(context, message.notification!.title ?? "",
            message.notification!.body ?? "");
      }
    });
    handlerOnStartNotifications(context)
        .then((value) => null)
        .catchError((error) {
      print("$error");
    });
  }

  @override
  void onDispose() {
    _onMessageOpenedAppSubscription?.cancel();
    _onMessageSubscription?.cancel();
  }

  Future<void> handlerOnStartNotifications(BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://us-central1-stadtnavi-ludwigsburg.cloudfunctions.net/onStartNotifications'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final notifications = data["notifications"] as List;
      if (notifications.isNotEmpty) {
        final notification = notifications[0];
        showNotification(context, notification["title"], notification["body"]);
      }
    }
  }

  showNotification(BuildContext context, String title, String body) {
    showTrufiDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            OKButton(
              onPressed: () async {
                Navigator.pop(_);
              },
            )
          ],
        );
      },
    );
  }
}
