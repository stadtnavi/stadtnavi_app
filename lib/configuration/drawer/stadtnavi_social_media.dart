import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/default_item_menu.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';

TrufiMenuItem stadtNaviSocialMedia(UrlSocialMedia defaultUrls) {
  return SimpleMenuItem(
      buildIcon: (context) => const Icon(Icons.rss_feed),
      name: (context) {
        return DropdownButton<SocialMediaItem>(
          icon: Row(
            children: [
              Text(
                TrufiBaseLocalization.of(context).menuSocialMedia,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          selectedItemBuilder: (_) => [],
          underline: Container(),
          onChanged: (SocialMediaItem? value) {
            value?.onClick(context, true);
          },
          items: <SocialMediaItem>[
            if (defaultUrls.urlFacebook != null)
              FacebookSocialMedia(defaultUrls.urlFacebook!),
            if (defaultUrls.urlInstagram != null)
              InstagramSocialMedia(defaultUrls.urlInstagram!),
            if (defaultUrls.urlTwitter != null)
              TwitterSocialMedia(defaultUrls.urlTwitter!),
            if (defaultUrls.urlWebSite != null)
              WebSiteSocialMedia(defaultUrls.urlWebSite!),
            if (defaultUrls.urlYoutube != null)
              YoutubeSocialMedia(defaultUrls.urlYoutube!),
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
      });
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
