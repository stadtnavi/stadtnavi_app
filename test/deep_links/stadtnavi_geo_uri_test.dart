import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_geo_uri.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_route_information_parser.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

void main() {
  const geoUri = StadtnaviGeoUri();

  group('coordinate geo URIs', () {
    test('parses a direct coordinate', () {
      final link =
          geoUri.parse(Uri.parse('geo:48.7758,9.1829'))
              as StadtnaviLocationDeepLink;

      expect(link.location.latitude, 48.7758);
      expect(link.location.longitude, 9.1829);
      expect(link.location.label, '48.7758, 9.1829');
    });

    test('ignores a zoom hint', () {
      final link =
          geoUri.parse(Uri.parse('geo:48.7758,9.1829?z=15'))
              as StadtnaviLocationDeepLink;

      expect(link.location.latitude, 48.7758);
      expect(link.location.longitude, 9.1829);
    });

    test('parses coordinates from q', () {
      final link =
          geoUri.parse(Uri.parse('geo:0,0?q=48.7758,9.1829'))
              as StadtnaviLocationDeepLink;

      expect(link.location.latitude, 48.7758);
      expect(link.location.longitude, 9.1829);
    });

    test('parses a coordinate label from q', () {
      final link =
          geoUri.parse(Uri.parse('geo:0,0?q=48.7758,9.1829(Stuttgart)'))
              as StadtnaviLocationDeepLink;

      expect(link.location.label, 'Stuttgart');
    });
  });

  group('address geo URIs', () {
    test('parses an encoded address query', () {
      final link =
          geoUri.parse(
                Uri.parse(
                  'geo:0,0?q=Breitscheidstra%C3%9Fe%2048%2C%2070176%20Stuttgart',
                ),
              )
              as StadtnaviAddressDeepLink;

      expect(link.query, 'Breitscheidstraße 48, 70176 Stuttgart');
    });

    test('decodes unicode address characters', () {
      final link =
          geoUri.parse(
                Uri.parse(
                  'geo:0,0?q=Stra%C3%9Fe%2C%20K%C3%A4ferweg%2C%20K%C3%B6ln%2C%20M%C3%BCnchen',
                ),
              )
              as StadtnaviAddressDeepLink;

      expect(link.query, 'Straße, Käferweg, Köln, München');
    });
  });

  group('invalid geo URIs', () {
    test('rejects malformed, empty, and out-of-range coordinates', () {
      for (final value in <String>[
        'geo:abc,xyz',
        'geo:500,800',
        'geo:500,800?q=Stuttgart',
        'geo:abc,xyz?q=Stuttgart',
        'geo:',
        'geo:0,0',
        'geo:0,0?q=',
        'geo:0,0?q=500,800',
      ]) {
        expect(geoUri.parse(Uri.parse(value)), isNull, reason: value);
      }
    });

    test('rejects duplicate queries and unsupported schemes', () {
      expect(
        geoUri.parse(Uri.parse('geo:0,0?q=Stuttgart&q=Herrenberg')),
        isNull,
      );
      expect(
        geoUri.parse(Uri.parse('https://example.com/?q=Stuttgart')),
        isNull,
      );
      expect(geoUri.parse(Uri.parse('geo:48.7,9.1#fragment')), isNull);
    });
  });

  group('Router integration', () {
    final webUrl = StadtnaviWebUrl(
      Uri.parse('https://herrenberg.stadtnavi.de/'),
    );
    final routeParser = StadtnaviRouteInformationParser(webUrl);

    test('maps a valid geo URI to the existing Home route', () async {
      const original =
          'geo:0,0?q=Breitscheidstra%C3%9Fe%2048%2C%2070176%20Stuttgart';
      final route = await routeParser.parseRouteInformation(
        RouteInformation(uri: Uri.parse(original)),
      );
      final internalUri = Uri.parse(route.fullPath);
      final forwarded =
          internalUri.queryParameters[StadtnaviRouteInformationParser
              .incomingGeoUriParameter];

      expect(internalUri.path, '/Home');
      expect(forwarded, original);
      expect(
        geoUri.parse(Uri.parse(forwarded!)),
        isA<StadtnaviAddressDeepLink>(),
      );
    });

    test('maps an invalid geo URI safely to Home', () async {
      final route = await routeParser.parseRouteInformation(
        RouteInformation(uri: Uri.parse('geo:500,800')),
      );

      expect(route.fullPath, '/Home');
    });
  });
}
