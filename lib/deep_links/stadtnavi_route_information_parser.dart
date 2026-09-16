import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

/// Normalizes absolute Universal Link/App Link URLs before Routemaster matches
/// them. Flutter sends the full URL on iOS and Android while Routemaster 1.x
/// matches path-only route templates.
class StadtnaviRouteInformationParser
    extends RouteInformationParser<RouteData> {
  const StadtnaviRouteInformationParser(this.webUrl);

  final StadtnaviWebUrl webUrl;

  @override
  Future<RouteData> parseRouteInformation(RouteInformation routeInformation) {
    final uri = routeInformation.uri;

    if (uri.hasScheme || uri.host.isNotEmpty) {
      if (!webUrl.isAllowedUri(uri)) {
        return SynchronousFuture(
          RouteData('/Home', pathTemplate: '/Home'),
        );
      }
      final normalizedLocation = StringBuffer('/')
        ..writeAll(uri.pathSegments.map(Uri.encodeComponent), '/')
        ..write(uri.hasQuery ? '?${uri.query}' : '')
        ..write(
          uri.hasFragment ? '#${Uri.encodeComponent(uri.fragment)}' : '',
        );
      return SynchronousFuture(
        RouteData(
          normalizedLocation.toString(),
          pathTemplate: normalizedLocation.toString(),
        ),
      );
    }

    return const RoutemasterParser().parseRouteInformation(routeInformation);
  }

  @override
  RouteInformation restoreRouteInformation(RouteData configuration) =>
      const RoutemasterParser().restoreRouteInformation(configuration);
}
