import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ludwigsburg/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_layer.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
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
  // TODO we need to improve TransportMode Configuration
  TransportModeConfiguration.configure(transportColors: {
    TransportMode.walk: const Color(0xffFECC01),
    TransportMode.bicycle: const Color(0xffffc200),
  });

  runApp(
    StadtnaviApp(
      appLifecycleReactorHandler: AppLifecycleReactorHandlerNotifications(),
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
        showNotification(context, null, message.notification!.title ?? "",
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
        final notificationId = notification["id"];
        if (await showShowNotification(notificationId)) {
          showNotification(context, notificationId, notification["title"],
              notification["body"]);
        }
      }
    }
  }

  Future<bool> showShowNotification(String? id) async {
    if (id == null) return true;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final flag = _prefs.getString(id);
    return flag == null;
  }

  Future makeDoNotShowAgain(String id) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(id, id);
  }

  showNotification(
      BuildContext context, String? id, String title, String body) {
    showTrufiDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            NotShowAgain(
              onPressed: () {
                Navigator.pop(_);
                if (id != null) makeDoNotShowAgain(id).catchError((error) {});
              },
            ),
            const OKButton()
          ],
        );
      },
    );
  }
}

class NotShowAgain extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotShowAgain({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StadtnaviBaseLocalization.of(context);
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Text(
        localization.notShowAgain,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
