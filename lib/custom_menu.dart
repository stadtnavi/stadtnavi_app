import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';
import 'package:trufi_core/blocs/preferences/preferences_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/menu/default_pages_menu.dart';
import 'package:trufi_core/models/menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/models/menu/social_media/social_media_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trufi_core/models/menu/social_media/facebook_social_media.dart';
import 'package:trufi_core/models/menu/social_media/instagram_social_media.dart';
import 'package:trufi_core/models/menu/social_media/twitter_social_media.dart';
import 'package:trufi_core/pages/about.dart';
import 'package:trufi_core/pages/feedback.dart';
import 'package:trufi_core/pages/home/home_page.dart';
import 'package:trufi_core/pages/saved_places/saved_places.dart';
import 'package:trufi_core/models/menu/default_item_menu.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/widgets/trufi_drawer.dart';
import 'package:share/share.dart';

import 'custom_buttons/report_defects_button.dart';

String aboutIcon = """
<svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" height="24px" viewBox="0 0 24 24" width="24px" fill="#000000">
    <rect fill="none" height="24" width="24" />
    <g>
        <path d="M4,13c1.1,0,2-0.9,2-2c0-1.1-0.9-2-2-2s-2,0.9-2,2C2,12.1,2.9,13,4,13z M5.13,14.1C4.76,14.04,4.39,14,4,14 c-0.99,0-1.93,0.21-2.78,0.58C0.48,14.9,0,15.62,0,16.43V18l4.5,0v-1.61C4.5,15.56,4.73,14.78,5.13,14.1z M20,13c1.1,0,2-0.9,2-2 c0-1.1-0.9-2-2-2s-2,0.9-2,2C18,12.1,18.9,13,20,13z M24,16.43c0-0.81-0.48-1.53-1.22-1.85C21.93,14.21,20.99,14,20,14 c-0.39,0-0.76,0.04-1.13,0.1c0.4,0.68,0.63,1.46,0.63,2.29V18l4.5,0V16.43z M16.24,13.65c-1.17-0.52-2.61-0.9-4.24-0.9 c-1.63,0-3.07,0.39-4.24,0.9C6.68,14.13,6,15.21,6,16.39V18h12v-1.61C18,15.21,17.32,14.13,16.24,13.65z M8.07,16 c0.09-0.23,0.13-0.39,0.91-0.69c0.97-0.38,1.99-0.56,3.02-0.56s2.05,0.18,3.02,0.56c0.77,0.3,0.81,0.46,0.91,0.69H8.07z M12,8 c0.55,0,1,0.45,1,1s-0.45,1-1,1s-1-0.45-1-1S11.45,8,12,8 M12,6c-1.66,0-3,1.34-3,3c0,1.66,1.34,3,3,3s3-1.34,3-3 C15,7.34,13.66,6,12,6L12,6z" />
    </g>
</svg>
""";

class ImpressumMedia extends SocialMediaItem {
  ImpressumMedia(String url)
      : super(
          url: url,
          buildIcon: (context) => const Icon(Icons.receipt_rounded),
          name: (BuildContext context) {
            return Localizations.localeOf(context).languageCode == 'en'
                ? "Imprint"
                : "Impressum";
          },
        );
}

class YoutubeSocialMedia extends SocialMediaItem {
  YoutubeSocialMedia(String url)
      : super(
          url: url,
          buildIcon: (context) => SvgPicture.string(
            '<svg height="682pt" viewBox="-21 -117 682.66672 682" width="682pt" xmlns="http://www.w3.org/2000/svg"><path d="m626.8125 64.035156c-7.375-27.417968-28.992188-49.03125-56.40625-56.414062-50.082031-13.703125-250.414062-13.703125-250.414062-13.703125s-200.324219 0-250.40625 13.183593c-26.886719 7.375-49.03125 29.519532-56.40625 56.933594-13.179688 50.078125-13.179688 153.933594-13.179688 153.933594s0 104.378906 13.179688 153.933594c7.382812 27.414062 28.992187 49.027344 56.410156 56.410156 50.605468 13.707031 250.410156 13.707031 250.410156 13.707031s200.324219 0 250.40625-13.183593c27.417969-7.378907 49.03125-28.992188 56.414062-56.40625 13.175782-50.082032 13.175782-153.933594 13.175782-153.933594s.527344-104.382813-13.183594-154.460938zm-370.601562 249.878906v-191.890624l166.585937 95.945312zm0 0"/></svg>',
            height: 25,
            width: 25,
            color: Colors.grey,
          ),
          name: (BuildContext context) {
            return Localizations.localeOf(context).languageCode == 'en'
                ? "Follow us on YouTube"
                : "Folge uns auf YouTube";
          },
        );
}

class CustomAppShareButtonMenu extends MenuItem {
  CustomAppShareButtonMenu()
      : super(
          selectedIcon: (context) =>
              const Icon(Icons.share_outlined, color: Colors.grey),
          notSelectedIcon: (context) =>
              const Icon(Icons.share_outlined, color: Colors.grey),
          name: (context) => MenuItem.buildName(
            context,
            Localizations.localeOf(context).languageCode == 'en'
                ? "Share the app"
                : "App weiterempfehlen",
          ),
          onClick: (context, _) {
            final currentLocale = Localizations.localeOf(context).languageCode;
            Share.share(currentLocale == "en"
                ? """
            Download the stadtnavi app, the public transport app for Herrenberg and its surroundings on https://herrenberg.stadtnavi.de/
            """
                : """
            Hol' dir die stadtnavi App für den öffentlichen Nahverkehr in Herrenberg und Umgebung auf https://herrenberg.stadtnavi.de/
            """);
          },
        );
}

final List<List<MenuItem>> menuItems = [
  [
    MenuPageItem(
      id: HomePage.route,
      selectedIcon: (context) => const Icon(
        Icons.location_on_outlined,
        color: Colors.black,
      ),
      notSelectedIcon: (context) => const Icon(
        Icons.location_on_outlined,
        color: Colors.grey,
      ),
      name: (context) {
        final localization = TrufiLocalization.of(context);
        return localization.menuConnections;
      },
    ),
    MenuPageItem(
      id: SavedPlacesPage.route,
      selectedIcon: (context) => const Icon(
        Icons.star_border,
        color: Colors.black,
      ),
      notSelectedIcon: (context) => const Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      name: (context) {
        final localization = TrufiLocalization.of(context);
        return localization.menuYourPlaces;
      },
    )
  ],
  [
    ReportDefectsButoon(),
    MenuPageItem(
      id: FeedbackPage.route,
      selectedIcon: (context) => const Icon(
        Icons.feedback_outlined,
        color: Colors.black,
      ),
      notSelectedIcon: (context) => const Icon(
        Icons.feedback_outlined,
        color: Colors.grey,
      ),
      name: (context) {
        final localization = TrufiLocalization.of(context);
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
        color: Colors.grey,
      ),
      notSelectedIcon: (context) => SvgPicture.string(
        aboutIcon,
        height: 25,
        width: 25,
        color: Colors.grey,
      ),
      name: (context) => Localizations.localeOf(context).languageCode == "en"
          ? "About this service"
          : "Über diesen Service",
    ),
    SimpleMenuItem(
        buildIcon: (context) => const Icon(Icons.rss_feed),
        name: (context) {
          final theme = Theme.of(context);
          return DropdownButton<SocialMediaItem>(
            icon: Row(
              children: [
                Text(Localizations.localeOf(context).languageCode == "en"
                    ? "Social media"
                    : "Soziale Medien"),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            selectedItemBuilder: (_) => [],
            underline: Container(),
            style: theme.textTheme.bodyText1,
            onChanged: (SocialMediaItem value) {
              value.onClick(context, true);
            },
            items: <SocialMediaItem>[
              FacebookSocialMedia("https://www.facebook.com/stadtnavi/"),
              InstagramSocialMedia("https://www.instagram.com/stadtnavi/"),
              TwitterSocialMedia("https://twitter.com/stadtnavi"),
              YoutubeSocialMedia(
                "https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA",
              ),
            ].map((SocialMediaItem value) {
              return DropdownMenuItem<SocialMediaItem>(
                value: value,
                child: Row(
                  children: [
                    value.notSelectedIcon(context),
                    value.name(context),
                  ],
                ),
              );
            }).toList(),
          );
        }),
    SimpleMenuItem(
      buildIcon: (context) => const Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.grey,
      ),
      name: (context) => MenuItem.buildName(
        context,
        Localizations.localeOf(context).languageCode == "en"
            ? "Rate the app"
            : "App bewerten",
      ),
      onClick: () {
        AppReview.writeReview;
      },
    ),
    CustomAppShareButtonMenu(),
  ],
  [
    SimpleMenuItem(
        buildIcon: (context) => const Icon(Icons.translate),
        name: (context) {
          final values = context
              .read<ConfigurationCubit>()
              .state
              .supportedLanguages
              .map((lang) =>
                  LanguageDropdownValue(lang.languageCode, lang.displayName))
              .toList();
          final theme = Theme.of(context);
          final languageCode = Localizations.localeOf(context).languageCode;
          return DropdownButton<LanguageDropdownValue>(
            style: theme.textTheme.bodyText1,
            value: values
                .firstWhere((value) => value.languageCode == languageCode),
            onChanged: (LanguageDropdownValue value) {
              BlocProvider.of<PreferencesCubit>(context)
                  .updateLanguage(value.languageCode);
            },
            items: values.map((LanguageDropdownValue value) {
              return DropdownMenuItem<LanguageDropdownValue>(
                value: value,
                child: Text(
                  value.languageString,
                  style: theme.textTheme.bodyText1,
                ),
              );
            }).toList(),
          );
        }),
    ImpressumMedia("https://www.herrenberg.de/impressum")
  ],
];
