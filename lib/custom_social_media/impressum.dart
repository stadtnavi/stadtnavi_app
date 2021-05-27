import 'package:flutter/material.dart';
import 'package:trufi_core/models/social_media/social_media_item.dart';

class ImpressumMedia implements SocialMediaItem {
  final String _url;

  ImpressumMedia(this._url);
  @override
  WidgetBuilder get buildIcon => (context) => const Icon(Icons.receipt_rounded);

  @override
  String getTitle(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en'
        ? "Imprint"
        : "Impressum";
  }

  @override
  String get url => _url;
}
