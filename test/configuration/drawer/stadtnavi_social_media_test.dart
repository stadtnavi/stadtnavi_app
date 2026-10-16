import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadtnavi_core/configuration/drawer/stadtnavi_social_media.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';

void main() {
  testWidgets('social media dropdowns build with all configured items', (
    tester,
  ) async {
    const urls = UrlSocialMedia(
      urlFacebook: 'https://example.com/facebook',
      urlInstagram: 'https://example.com/instagram',
      urlTwitter: 'https://example.com/twitter',
      urlWebSite: 'https://example.com',
    );
    final stadtnaviItem = stadtNaviSocialMedia(urls);
    final defaultItem = defaultSocialMedia(urls);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates:
            TrufiBaseLocalization.localizationsDelegates,
        supportedLocales: TrufiBaseLocalization.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                SizedBox(width: 217, child: stadtnaviItem.name(context)),
                SizedBox(width: 217, child: defaultItem.name(context)),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(DropdownButton<SocialMediaItem>), findsNWidgets(2));
  });
}
