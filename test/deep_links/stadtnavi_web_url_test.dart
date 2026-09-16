import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_route_information_parser.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

void main() {
  final webUrl = StadtnaviWebUrl(Uri.parse('https://herrenberg.stadtnavi.de/'));

  group('location URL generation', () {
    test('uses the canonical digitransit endpoint format', () {
      final uri = webUrl.locationUri(
        label: 'Stiftskirche Herrenberg',
        latitude: 48.59635,
        longitude: 8.87014,
      );

      expect(
        uri.toString(),
        'https://herrenberg.stadtnavi.de/-/'
        'Stiftskirche%20Herrenberg%3A%3A48.59635%2C8.87014',
      );
      final link = webUrl.parse(uri) as StadtnaviLocationDeepLink;
      expect(link.location.label, 'Stiftskirche Herrenberg');
      expect(link.location.latitude, 48.59635);
      expect(link.location.longitude, 8.87014);
    });

    test('rejects invalid coordinates', () {
      expect(
        () => webUrl.locationUri(label: 'Invalid', latitude: 91, longitude: 8),
        throwsArgumentError,
      );
    });
  });

  group('web URL parsing', () {
    test('parses a real digitransit journey URL', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/reiseplan/'
          'Marktplatz%3A%3A48.5960%2C8.8700/'
          'Bahnhof%3A%3A48.5940%2C8.8620',
        ),
      ) as StadtnaviJourneyDeepLink;

      expect(link.from.label, 'Marktplatz');
      expect(link.from.latitude, 48.596);
      expect(link.to.label, 'Bahnhof');
      expect(link.to.longitude, 8.862);
    });

    test('parses a language-prefixed POI URL', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/de/pois/restaurant'
          '?lat=48.5961&lng=8.8704&name=Gasthaus&osmId=12345',
        ),
      ) as StadtnaviLocationDeepLink;

      expect(link.location.label, 'Gasthaus');
      expect(link.location.latitude, 48.5961);
      expect(link.location.longitude, 8.8704);
    });

    test('parses coordinate-backed map entity URLs', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/ladestationen'
          '?stationId=charger-1&lat=48.59&lng=8.86&name=Lades%C3%A4ule',
        ),
      ) as StadtnaviLocationDeepLink;

      expect(link.location.label, 'Ladesäule');
      expect(link.location.latitude, 48.59);
    });

    test('parses stops and selects the native timetable tab', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/haltestellen/'
          'hbg%3A71083%3A100/fahrplan',
        ),
      ) as StadtnaviStopDeepLink;

      expect(link.id, 'hbg:71083:100');
      expect(link.initialTab, 1);
    });

    test('parses generic shared-mobility station URLs', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/station/'
          'deer-carsharing%3Astation-42',
        ),
      ) as StadtnaviRentalStationDeepLink;

      expect(link.id, 'deer-carsharing:station-42');
    });

    test('parses parking URLs with a coordinate fallback', () {
      final link = webUrl.parse(
        Uri.parse(
          'https://herrenberg.stadtnavi.de/parkplaetze/park-1'
          '?lat=48.6&lng=8.87&name=Parkhaus',
        ),
      ) as StadtnaviParkingDeepLink;

      expect(link.id, 'park-1');
      expect(link.isBicycleParking, isFalse);
      expect(link.fallbackLocation?.label, 'Parkhaus');
    });
  });

  group('unsupported and invalid URLs', () {
    test('rejects unrelated domains and non-HTTPS URLs', () {
      expect(
        webUrl.parse(Uri.parse('https://example.com/-/Place%3A%3A48.5%2C8.8')),
        isNull,
      );
      expect(
        webUrl.parse(
          Uri.parse('http://herrenberg.stadtnavi.de/-/Place%3A%3A48.5%2C8.8'),
        ),
        isNull,
      );
    });

    test('rejects malformed, missing, and out-of-range coordinates', () {
      expect(
        webUrl.parse(
          Uri.parse('https://herrenberg.stadtnavi.de/-/Place%3A%3Anope'),
        ),
        isNull,
      );
      expect(
        webUrl.parse(
          Uri.parse('https://herrenberg.stadtnavi.de/geojson?lat=100&lng=8'),
        ),
        isNull,
      );
      expect(
        webUrl.parse(
          Uri.parse('https://herrenberg.stadtnavi.de/pois/restaurant?osmId=1'),
        ),
        isNull,
      );
    });

    test('rejects current-position journeys and unsupported native pages', () {
      expect(
        webUrl.parse(
          Uri.parse(
            'https://herrenberg.stadtnavi.de/reiseplan/'
            'POS/Bahnhof%3A%3A48.594%2C8.862',
          ),
        ),
        isNull,
      );
      expect(
        webUrl.parse(
          Uri.parse('https://herrenberg.stadtnavi.de/routen/hbg%3A1'),
        ),
        isNull,
      );
      expect(
        webUrl.parse(
          Uri.parse('https://herrenberg.stadtnavi.de/busbahnhoefe/hbg%3A1'),
        ),
        isNull,
      );
    });
  });

  group('platform route normalization', () {
    final parser = StadtnaviRouteInformationParser(webUrl);

    test('normalizes a full platform URL for Routemaster', () async {
      final route = await parser.parseRouteInformation(
        RouteInformation(
          uri: Uri.parse(
            'https://herrenberg.stadtnavi.de/pois/restaurant'
            '?lat=48.59&lng=8.86&name=Restaurant&osmId=42',
          ),
        ),
      );

      expect(
        route.fullPath,
        '/pois/restaurant?lat=48.59&lng=8.86&name=Restaurant&osmId=42',
      );
    });

    test('preserves encoded reserved characters in location labels', () async {
      final route = await parser.parseRouteInformation(
        RouteInformation(
          uri: Uri.parse(
            'https://herrenberg.stadtnavi.de/-/'
            'Caf%C3%A9%20A%2FB%20%23%201%3A%3A48.59%2C8.86',
          ),
        ),
      );
      expect(
        route.fullPath,
        '/-/Caf%C3%A9%20A%2FB%20%23%201%3A%3A48.59%2C8.86',
      );
      final parsed = webUrl.parse(Uri.parse(route.fullPath))
          as StadtnaviLocationDeepLink;

      expect(parsed.location.label, 'Café A/B # 1');
      expect(Uri.parse(route.fullPath).pathSegments, hasLength(2));
    });

    test('routes an unrelated platform origin to home', () async {
      final route = await parser.parseRouteInformation(
        RouteInformation(
          uri: Uri.parse(
            'https://example.com/-/Place%3A%3A48.5%2C8.8',
          ),
        ),
      );

      expect(route.fullPath, '/Home');
    });
  });
}
