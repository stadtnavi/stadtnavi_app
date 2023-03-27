import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';

import 'branding_herrenberg.dart';
import 'static_layer.dart';

const baseDomain = "api.stadtnavi.de";
String openTripPlannerUrl =
    "https://$baseDomain/routing/v1/router/index/graphql";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatedLetsencryptAndroid.workAroundCertificated();
  await initHiveForFlutter();
  await _migrationOldData();
  // TODO we need to improve TransportMode Configuration
  TransportModeConfiguration.configure(transportColors: {
    TransportMode.bicycle: const Color(0xffFECC01),
    TransportMode.walk: const Color(0xffFECC01),
  });
  runApp(
    StadtnaviApp(
      appName: 'stadtnavi',
      appNameTitle: 'stadtnavi|Herrenberg',
      cityName: 'Herrenberg',
      center: LatLng(48.5950, 8.8672),
      otpGraphqlEndpoint: openTripPlannerUrl,
      urlFeedback: 'https://stadtnavi.de/feedback/',
      urlShareApp: 'https://herrenberg.stadtnavi.de/',
      urlRepository: 'https://github.com/trufi-association/trufi-app',
      urlImpressum: 'https://www.herrenberg.de/impressum',
      reportDefectsUri:
          Uri.parse('https://www.herrenberg.de/tools/mvs').replace(
        fragment: "mvPagePictures",
      ),
      layersContainer: customLayersHerrenberg,
      urlSocialMedia: const UrlSocialMedia(
        urlFacebook: 'https://www.facebook.com/stadtnavi/',
        urlInstagram: 'https://www.instagram.com/stadtnavi/',
        urlTwitter: 'https://twitter.com/stadtnavi',
        urlYoutube: 'https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA',
      ),
      trufiBaseTheme: TrufiBaseTheme(
        themeMode: ThemeMode.light,
        brightness: Brightness.light,
        theme: brandingStadtnaviHerrenberg,
        darkTheme: brandingStadtnaviHerrenberg,
      ),
    ),
  );
}

Future<void> _migrationOldData() async {
  List<List<String>> data = [
    ['myPlacesStorage', 'SearchLocationsCubitMyPlaces'],
    ['myDefaultPlacesStorage', 'SearchLocationsCubitMyDefaultPlaces'],
    ['historyPlacesStorage', 'SearchLocationsCubitHistoryPlaces'],
    ['favoritePlacesStorage', 'SearchLocationsCubitFavoritePlaces'],
  ];
  final prefs = await SharedPreferences.getInstance();
  final _box = Hive.box('SearchLocationsCubit');
  for (List<String> element in data) {
    await _migration(
      oldRef: element[0],
      newRef: element[1],
      prefsOld: prefs,
      prefsNew: _box,
    );
  }
  await prefs.clear();
}

Future<void> _migration({
  required String oldRef,
  required String newRef,
  required SharedPreferences prefsOld,
  required Box prefsNew,
}) async {
  try {
    if (kIsWeb) return;
    // Migration datavor version menores a la 1.5.0
    final String? action = prefsOld.getString(oldRef);
    if (!prefsNew.containsKey(newRef) && action != null) {
      final data = (jsonDecode(action) as List<dynamic>)
          .map<TrufiLocation>(
            (dynamic json) =>
                TrufiLocation.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      await prefsNew.put(newRef, jsonEncode(data));
    }
  } catch (e) {
    e;
  }
}
