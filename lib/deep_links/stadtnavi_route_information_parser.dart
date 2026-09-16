import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_geo_uri.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

/// Normalizes absolute Universal Link/App Link URLs and Android `geo:` URIs
/// before Routemaster matches them. Flutter sends the full URI on iOS and
/// Android while Routemaster 1.x matches path-only route templates.
class StadtnaviRouteInformationParser
    extends RouteInformationParser<RouteData> {
  const StadtnaviRouteInformationParser(
    this.webUrl, {
    this.geoUriParser = const StadtnaviGeoUri(),
  });

  static const incomingGeoUriParameter = 'incomingGeoUri';

  final StadtnaviWebUrl webUrl;
  final StadtnaviGeoUri geoUriParser;

  @override
  Future<RouteData> parseRouteInformation(RouteInformation routeInformation) {
    final uri = routeInformation.uri;

    if (uri.scheme.toLowerCase() == 'geo') {
      if (geoUriParser.parse(uri) == null) {
        return SynchronousFuture(RouteData('/Home', pathTemplate: '/Home'));
      }
      final internalRoute = Uri(
        path: '/Home',
        queryParameters: {incomingGeoUriParameter: uri.toString()},
      );
      return SynchronousFuture(
        RouteData(internalRoute.toString(), pathTemplate: '/Home'),
      );
    }

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
