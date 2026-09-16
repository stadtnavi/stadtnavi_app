/// A location encoded in the same `label::latitude,longitude` form used by
/// digitransit-ui.
class StadtnaviLinkLocation {
  const StadtnaviLinkLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

sealed class StadtnaviDeepLink {
  const StadtnaviDeepLink();
}

final class StadtnaviLocationDeepLink extends StadtnaviDeepLink {
  const StadtnaviLocationDeepLink(this.location);

  final StadtnaviLinkLocation location;
}

/// An unresolved address received from an external map intent.
final class StadtnaviAddressDeepLink extends StadtnaviDeepLink {
  const StadtnaviAddressDeepLink(this.query);

  final String query;
}

final class StadtnaviJourneyDeepLink extends StadtnaviDeepLink {
  const StadtnaviJourneyDeepLink({required this.from, required this.to});

  final StadtnaviLinkLocation from;
  final StadtnaviLinkLocation to;
}

final class StadtnaviStopDeepLink extends StadtnaviDeepLink {
  const StadtnaviStopDeepLink({required this.id, this.initialTab = 0});

  final String id;
  final int initialTab;
}

final class StadtnaviRentalStationDeepLink extends StadtnaviDeepLink {
  const StadtnaviRentalStationDeepLink(this.id);

  final String id;
}

final class StadtnaviPoiDeepLink extends StadtnaviDeepLink {
  const StadtnaviPoiDeepLink({
    required this.category,
    required this.osmId,
    required this.location,
  });

  final String category;
  final String osmId;
  final StadtnaviLinkLocation location;
}

final class StadtnaviChargingStationDeepLink extends StadtnaviDeepLink {
  const StadtnaviChargingStationDeepLink({
    required this.stationId,
    required this.location,
  });

  final String stationId;
  final StadtnaviLinkLocation location;
}

final class StadtnaviParkingDeepLink extends StadtnaviDeepLink {
  const StadtnaviParkingDeepLink({
    required this.id,
    required this.isBicycleParking,
    this.fallbackLocation,
  });

  final String id;
  final bool isBicycleParking;
  final StadtnaviLinkLocation? fallbackLocation;
}

/// Builds and parses URLs shared with the stadtnavi web application.
///
/// The accepted paths mirror the routes in digitransit-ui's `app/routes.js`,
/// `app/stopRoutes.js`, and `app/util/path.js`. Parsing remains deliberately
/// conservative: a route is returned only when the Flutter app has enough
/// information to show equivalent native content.
class StadtnaviWebUrl {
  StadtnaviWebUrl(Uri baseUri) : baseUri = _normalizeBaseUri(baseUri);

  final Uri baseUri;

  static const _coordinatePaths = <String>{
    'baustellen',
    'fahrradparkplaetze',
    'geojson',
    'ladestationen',
    'strassenwetter',
  };

  static const _routeTemplates = <String>[
    '/-/:to',
    '/:from/-',
    '/reiseplan/:from/:to',
    '/reiseplan/:from/:to/:hash',
    '/haltestellen/:id',
    '/haltestellen/:id/:section',
    '/haltestellen/:id/:section/:detail',
    '/station/:id',
    '/parkplaetze/:id',
    '/fahrradparkplaetze/:id',
    '/pois/:code',
    '/baustellen',
    '/fahrradparkplaetze',
    '/geojson',
    '/ladestationen',
    '/strassenwetter',
  ];

  /// Routemaster templates needed to deliver supported web paths to the home
  /// page. Digitransit also exposes language-prefixed versions of each URL.
  static Iterable<String> get routeTemplates sync* {
    for (final template in _routeTemplates) {
      yield template;
      yield '/de$template';
      yield '/en$template';
    }
  }

  Uri locationUri({
    required String label,
    required double latitude,
    required double longitude,
  }) => uriFor(
    StadtnaviLocationDeepLink(
      StadtnaviLinkLocation(
        label: label,
        latitude: latitude,
        longitude: longitude,
      ),
    ),
  );

  /// Generates the canonical digitransit-ui URL for a native destination.
  Uri uriFor(StadtnaviDeepLink deepLink) {
    switch (deepLink) {
      case StadtnaviLocationDeepLink(:final location):
        _validateLocation(location);
        return _routeUri([
          '-',
          '${location.label.trim()}::${location.latitude},${location.longitude}',
        ]);
      case StadtnaviJourneyDeepLink(:final from, :final to):
        _validateLocation(from);
        _validateLocation(to);
        return _routeUri([
          'reiseplan',
          '${from.label.trim()}::${from.latitude},${from.longitude}',
          '${to.label.trim()}::${to.latitude},${to.longitude}',
        ]);
      case StadtnaviStopDeepLink(:final id):
        return _entityUri('haltestellen', id);
      case StadtnaviRentalStationDeepLink(:final id):
        return _entityUri('station', id);
      case StadtnaviParkingDeepLink(:final id, :final isBicycleParking):
        return _entityUri(
          isBicycleParking ? 'fahrradparkplaetze' : 'parkplaetze',
          id,
        );
      case StadtnaviPoiDeepLink(:final category, :final osmId, :final location):
        _validateLocation(location);
        return _routeUri(
          ['pois', category],
          queryParameters: {
            'lat': '${location.latitude}',
            'lng': '${location.longitude}',
            'name': location.label,
            'osmId': osmId,
          },
        );
      case StadtnaviChargingStationDeepLink(:final stationId, :final location):
        _validateLocation(location);
        return _routeUri(
          ['ladestationen'],
          queryParameters: {
            'lat': '${location.latitude}',
            'lng': '${location.longitude}',
            'name': location.label,
            'stationId': stationId,
          },
        );
      case StadtnaviAddressDeepLink():
        throw ArgumentError.value(
          deepLink,
          'deepLink',
          'Unresolved addresses do not have a canonical web URL',
        );
    }
  }

  StadtnaviDeepLink? parse(Uri uri) {
    if (!isAllowedUri(uri)) {
      return null;
    }

    try {
      final segments = List<String>.of(uri.pathSegments);
      if (segments.isNotEmpty &&
          (segments.first == 'de' || segments.first == 'en')) {
        segments.removeAt(0);
      }

      if (segments.length == 2 &&
          (segments.first == '-' || segments.last == '-')) {
        final endpoint = segments.first == '-' ? segments.last : segments.first;
        final location = _parseEndpoint(endpoint);
        return location == null ? null : StadtnaviLocationDeepLink(location);
      }

      if (segments.length >= 3 &&
          segments.length <= 4 &&
          segments.first == 'reiseplan') {
        final from = _parseEndpoint(segments[1]);
        final to = _parseEndpoint(segments[2]);
        if (from == null || to == null) {
          return null;
        }
        return StadtnaviJourneyDeepLink(from: from, to: to);
      }

      if (segments.length >= 2 &&
          segments.length <= 4 &&
          segments.first == 'haltestellen' &&
          segments[1].trim().isNotEmpty) {
        final section = segments.length > 2 ? segments[2] : null;
        final initialTab = switch (section) {
          'fahrplan' => 1,
          'stoerungen' => 2,
          _ => 0,
        };
        return StadtnaviStopDeepLink(id: segments[1], initialTab: initialTab);
      }

      if (segments.length == 2 &&
          segments.first == 'station' &&
          segments[1].trim().isNotEmpty) {
        return StadtnaviRentalStationDeepLink(segments[1]);
      }

      if (segments.length == 2 &&
          (segments.first == 'parkplaetze' ||
              segments.first == 'fahrradparkplaetze') &&
          segments[1].trim().isNotEmpty) {
        return StadtnaviParkingDeepLink(
          id: segments[1],
          isBicycleParking: segments.first == 'fahrradparkplaetze',
          fallbackLocation: _parseQueryLocation(uri),
        );
      }

      if (segments.length == 2 && segments.first == 'pois') {
        final osmId = uri.queryParameters['osmId'];
        if (segments[1].trim().isEmpty || osmId == null || osmId.isEmpty) {
          return null;
        }
        final location = _parseQueryLocation(uri, fallbackLabel: segments[1]);
        return location == null
            ? null
            : StadtnaviPoiDeepLink(
              category: segments[1],
              osmId: osmId,
              location: location,
            );
      }

      if (segments.length == 1 && segments.first == 'ladestationen') {
        final stationId = uri.queryParameters['stationId'];
        final location = _parseQueryLocation(uri);
        if (stationId == null || stationId.isEmpty || location == null) {
          return null;
        }
        return StadtnaviChargingStationDeepLink(
          stationId: stationId,
          location: location,
        );
      }

      if (segments.length == 1 && _coordinatePaths.contains(segments.first)) {
        final location = _parseQueryLocation(uri);
        return location == null ? null : StadtnaviLocationDeepLink(location);
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  bool isAllowedUri(Uri uri) {
    if (!uri.hasScheme && uri.host.isEmpty) {
      return true;
    }
    return uri.scheme.toLowerCase() == 'https' &&
        uri.host.toLowerCase() == baseUri.host.toLowerCase() &&
        uri.port == baseUri.port &&
        uri.userInfo.isEmpty;
  }

  static StadtnaviLinkLocation? _parseEndpoint(String endpoint) {
    if (endpoint == 'POS' || endpoint == '-') {
      return null;
    }
    final separator = endpoint.indexOf('::');
    if (separator < 0) {
      return null;
    }
    final label = endpoint.substring(0, separator).trim();
    final rest = endpoint.substring(separator + 2);
    final slackSeparator = rest.indexOf('::');
    final coordinateText =
        slackSeparator < 0 ? rest : rest.substring(0, slackSeparator);
    final coordinates = coordinateText.split(',');
    if (coordinates.length != 2) {
      return null;
    }
    final latitude = double.tryParse(coordinates[0]);
    final longitude = double.tryParse(coordinates[1]);
    if (latitude == null ||
        longitude == null ||
        !_validCoordinates(latitude, longitude)) {
      return null;
    }
    return StadtnaviLinkLocation(
      label: label.isEmpty ? '$latitude, $longitude' : label,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static StadtnaviLinkLocation? _parseQueryLocation(
    Uri uri, {
    String? fallbackLabel,
  }) {
    final query = uri.queryParameters;
    final latitude = double.tryParse(query['lat'] ?? '');
    final longitude = double.tryParse(query['lng'] ?? query['lon'] ?? '');
    if (latitude == null ||
        longitude == null ||
        !_validCoordinates(latitude, longitude)) {
      return null;
    }
    final label = <String?>[
      query['name'],
      query['address'],
      query['street'],
      query['description'],
      fallbackLabel,
    ].whereType<String>().firstWhere(
          (value) => value.trim().isNotEmpty,
          orElse: () => '$latitude, $longitude',
        );
    return StadtnaviLinkLocation(
      label: label.trim(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  static bool _validCoordinates(double latitude, double longitude) =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  static void _validateLocation(StadtnaviLinkLocation location) {
    if (!_validCoordinates(location.latitude, location.longitude)) {
      throw ArgumentError(
        'Invalid coordinates: ${location.latitude},${location.longitude}',
      );
    }
  }

  Uri _entityUri(String path, String id) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'An entity ID is required');
    }
    return _routeUri([path, id]);
  }

  Uri _routeUri(
    List<String> pathSegments, {
    Map<String, String>? queryParameters,
  }) {
    final path = pathSegments.map(Uri.encodeComponent).join('/');
    final query =
        queryParameters == null
            ? ''
            : '?${Uri(queryParameters: queryParameters).query}';
    return baseUri.resolve('$path$query');
  }

  static Uri _normalizeBaseUri(Uri baseUri) {
    if (baseUri.scheme.toLowerCase() != 'https' || baseUri.host.isEmpty) {
      throw ArgumentError.value(
        baseUri,
        'baseUri',
        'A valid HTTPS web URL is required',
      );
    }
    final path = baseUri.path.endsWith('/') ? baseUri.path : '${baseUri.path}/';
    return baseUri.replace(path: path, query: null, fragment: null);
  }
}
