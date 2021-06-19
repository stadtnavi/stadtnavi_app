import 'package:flutter/material.dart';
import 'package:trufi_core/models/menu/social_media/social_media_item.dart';

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
