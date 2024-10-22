import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:stadtnavi_core/base/pages/about/about.dart';
import 'package:stadtnavi_core/base/pages/home/home_page.dart';
import 'package:stadtnavi_core/base/pages/parking_information_page/parking_information_page.dart';
import 'package:stadtnavi_core/configuration/drawer/menu_language.dart';
import 'package:stadtnavi_core/configuration/drawer/tile_menu.dart';
import 'package:stadtnavi_core/configuration/drawer/stadtnavi_social_media.dart';

import 'package:trufi_core/base/pages/feedback/feedback.dart';
import 'package:trufi_core/base/pages/feedback/translations/feedback_localizations.dart';
import 'package:trufi_core/base/pages/saved_places/saved_places.dart';
import 'package:trufi_core/base/pages/saved_places/translations/saved_places_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/default_pages_menu.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';

List<List<TrufiMenuItem>> stadtnaviMenuItems({
  required UrlSocialMedia? defaultUrls,
  required String impressumUrl,
  required String appName,
  required String cityName,
  required String urlShareApp,
  required Uri reportDefectsUri,
  List<TrufiMenuItem>? extraItems,
}) {
  return [
    [
      MenuPageItem(
        id: HomePage.route,
        selectedIcon: (context) => Icon(
          Icons.location_on_outlined,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        notSelectedIcon: (context) => const Icon(
          Icons.location_on_outlined,
          color: Colors.grey,
        ),
        name: (context) {
          final localization = TrufiBaseLocalization.of(context);
          return localization.menuConnections;
        },
      ),
      ParkingInformationPage.menuItemDrawer,
      if (extraItems != null) ...extraItems,
      MenuPageItem(
        id: SavedPlacesPage.route,
        selectedIcon: (context) => Icon(
          Icons.star_border,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        notSelectedIcon: (context) => const Icon(
          Icons.star_border,
          color: Colors.grey,
        ),
        name: (context) {
          final localization = SavedPlacesLocalization.of(context);
          return localization.menuYourPlaces;
        },
      ),
    ],
    [
      ReportDefectsButton(
        uri: reportDefectsUri,
      ),
      MenuPageItem(
        id: FeedbackPage.route,
        selectedIcon: (context) => Icon(
          Icons.feedback_outlined,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        notSelectedIcon: (context) => const Icon(
          Icons.feedback_outlined,
          color: Colors.grey,
        ),
        name: (context) {
          final localization = FeedbackLocalization.of(context);
          return localization.menuFeedback;
        },
      ),
    ],
    [
      MenuPageItem(
        id: AboutPage.route,
        selectedIcon: (context) => SvgPicture.string(
          aboutIcon,
          height: 25,
          width: 25,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        notSelectedIcon: (context) => SvgPicture.string(
          aboutIcon,
          height: 25,
          width: 25,
          color: Colors.grey,
        ),
        name: (context) => Localizations.localeOf(context).languageCode == "en"
            ? "About this service"
            : "Über diesen Dienst",
      ),
      if (defaultUrls != null && defaultUrls.existUrl)
        stadtNaviSocialMedia(defaultUrls),
      RateApp(),
      AppShareButtonMenu(
        appName: appName,
        cityName: cityName,
        urlShareApp: urlShareApp,
      ),
    ],
    [menuLanguage(), ImpressumMedia(impressumUrl)]
  ];
}
