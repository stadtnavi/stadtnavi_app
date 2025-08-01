import 'dart:developer';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:herrenberg/config_herrenberg_merged.dart';
import 'package:herrenberg/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/notifications/lifecycle_reactor_handler_notifications.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';

import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';

import 'branding_herrenberg.dart';
import 'static_layer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatedLetsencryptAndroid.workAroundCertificated();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.getAPNSToken();
  FirebaseMessaging.instance
      .getToken()
      .then((value) {
        log("getToken: $value");
      })
      .catchError((error) {
        log("catchError");
        print("$error");
      });
  FirebaseInstallations.instance
      .getId()
      .then((value) {
        log("Firebase Installation ID: $value");
      })
      .catchError((error) {
        log("catchError");
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
      // ignore: invalid_return_type_for_catch_error
      .catchError((error) => print("$error"));

  await initHiveForFlutter();
  TransportModeExtension.visibleSettings[TransportMode.funicular] = true;
  defaultTransportModes.add(TransportMode.funicular);
  defaultTransportModes.add(TransportMode.carPool);
  // TODO we need to improve TransportMode Configuration
  TransportModeConfiguration.configure(
    transportColors: {
      TransportMode.bicycle: const Color(0xffFECC01),
      TransportMode.walk: const Color(0xffFECC01),
    },
  );
  await MatomoTracker.instance.initialize(siteId: '2', url: ApiConfig().matomo);
  await ConfigDefault.loadFromRemote(
    jsonUrlFile:
        "https://raw.githubusercontent.com/stadtnavi/stadtnavi_app/refs/heads/main/instances/herrenberg/conf-herrenberg.json",
    deafultConfigData: configHerrenbergMerged,
  );
  runApp(
    CriticalLoader(
      loadData: () async {
        await HBLayerData.loadHbLayers();
      },
      builder:
          (_) => StadtnaviApp(
            appLifecycleReactorHandler: LifecycleReactorHandlerNotifications(
              hasInAppNotifications: true,
              hasPushNotifications: true,
            ),
            appName: 'stadtnavi',
            appNameTitle: 'stadtnavi|Herrenberg',
            cityName: 'Herrenberg',
            center: const LatLng(48.5950, 8.8672),
            co2EmmissionUrl: "https://www.herrenberg.de/Mobilit%C3%A4t/CO2",
            otpGraphqlEndpoint: ApiConfig().openTripPlannerUrl,
            urlFeedback: 'https://stadtnavi.de/feedback/',
            urlShareApp: 'https://herrenberg.stadtnavi.de/',
            urlRepository: 'https://github.com/trufi-association/trufi-app',
            urlImpressum: 'https://www.herrenberg.de/impressum',
            reportDefectsUri: Uri.parse(
              'https://www.herrenberg.de/tools/mvs',
            ).replace(fragment: "mvPagePictures"),
            layersContainer: customLayersHerrenberg,
            urlSocialMedia: const UrlSocialMedia(
              urlFacebook: 'https://www.facebook.com/stadtnavi/',
              urlInstagram: 'https://www.instagram.com/stadtnavi/',
              urlTwitter: 'https://twitter.com/stadtnavi',
              urlYoutube:
                  'https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA',
            ),
            trufiBaseTheme: TrufiBaseTheme(
              themeMode: ThemeMode.light,
              brightness: Brightness.light,
              theme: brandingStadtnaviHerrenberg,
              darkTheme: brandingStadtnaviHerrenberg,
            ),
            alertsFeedIds: const ['hbg'],
          ),
    ),
  );
}

class CriticalLoader extends StatefulWidget {
  final Future<void> Function() loadData;
  final Widget Function(BuildContext) builder;

  const CriticalLoader({
    super.key,
    required this.loadData,
    required this.builder,
  });

  @override
  CriticalLoaderState createState() => CriticalLoaderState();
}

class CriticalLoaderState extends State<CriticalLoader> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      await widget.loadData();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  void _retry() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xff9BBF28),
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    if (_hasError) {
      return MaterialApp(
        home: Scaffold(
          // backgroundColor: Color(0xff9BBF28),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("assets/splash.png", fit: BoxFit.cover),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const Text(
                      //   "Failed to load data",
                      //   style: TextStyle(color: Colors.red),
                      // ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        const Text(
                          "Failed to load data",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _retry,
                          child: const Text("Retry"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.builder(context);
  }
}
