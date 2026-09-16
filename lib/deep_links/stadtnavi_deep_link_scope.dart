import 'package:flutter/widgets.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

class StadtnaviDeepLinkScope extends InheritedWidget {
  const StadtnaviDeepLinkScope({
    super.key,
    required this.webUrl,
    required super.child,
  });

  final StadtnaviWebUrl webUrl;

  static StadtnaviWebUrl? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<StadtnaviDeepLinkScope>()
      ?.webUrl;

  @override
  bool updateShouldNotify(StadtnaviDeepLinkScope oldWidget) =>
      webUrl.baseUri != oldWidget.webUrl.baseUri;
}
