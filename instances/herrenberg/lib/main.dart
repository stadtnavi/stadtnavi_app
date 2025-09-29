import 'dart:developer';

import 'package:de_stadtnavi_herrenberg_internal/firebase_options.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/localization/language_bloc.dart';
import 'package:trufi_core/default_theme.dart';
import 'package:trufi_core/hive_init.dart';
import 'package:trufi_core/screens/route_navigation/route_navigation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String appLocale = 'en';

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
      });
  FirebaseInstallations.instance
      .getId()
      .then((value) {
        log("Firebase Installation ID: $value");
      })
      .catchError((error) {
        log("catchError");
      });
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Intl.defaultLocale = appLocale;
  await initializeDateFormatting(appLocale);
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MaterialApp(
        localizationsDelegates: AppLocalization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        title: 'stadtnavi|Herrenberg',
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('pt', 'PT'),
          Locale('pt', 'BR'),
          Locale('de', 'DE'),
          Locale('fr', 'FR'),
        ],
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const RouteNavigationScreen(),
      ),
    );
  }
}
