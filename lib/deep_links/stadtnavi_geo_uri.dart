import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

/// Parses Android's standard `geo:` intents into the same native destinations
/// used by stadtnavi HTTPS deep links.
class StadtnaviGeoUri {
  const StadtnaviGeoUri();

  static final RegExp _coordinatePattern = RegExp(
    r'^([+-]?(?:\d+(?:\.\d*)?|\.\d+))\s*,\s*'
    r'([+-]?(?:\d+(?:\.\d*)?|\.\d+))'
    r'(?:\s*\((.*)\))?$',
  );

  StadtnaviDeepLink? parse(Uri uri) {
    if (uri.scheme.toLowerCase() != 'geo' ||
        uri.hasAuthority ||
        uri.hasFragment) {
      return null;
    }

    try {
      final rawCoordinate = uri.path.trim();
      final baseCoordinateMatch = _coordinatePattern.firstMatch(rawCoordinate);
      if (rawCoordinate.isNotEmpty &&
          (baseCoordinateMatch == null ||
              _coordinateLink(baseCoordinateMatch) == null)) {
        return null;
      }

      final queryValues = uri.queryParametersAll['q'];
      if (queryValues != null) {
        if (queryValues.length != 1) {
          return null;
        }
        final query = queryValues.single.trim();
        if (query.isEmpty) {
          return null;
        }

        final coordinateMatch = _coordinatePattern.firstMatch(query);
        if (coordinateMatch != null) {
          return _coordinateLink(coordinateMatch);
        }

        return StadtnaviAddressDeepLink(query);
      }

      if (baseCoordinateMatch == null) {
        return null;
      }
      final link = _coordinateLink(baseCoordinateMatch);
      if (link case StadtnaviLocationDeepLink(
        :final location,
      ) when location.latitude == 0 && location.longitude == 0) {
        // Android uses 0,0 as a sentinel for query-only geo URIs. Without a
        // non-empty q parameter it does not represent a useful destination.
        return null;
      }
      return link;
    } on FormatException {
      return null;
    }
  }

  static StadtnaviLocationDeepLink? _coordinateLink(RegExpMatch match) {
    final latitude = double.tryParse(match.group(1)!);
    final longitude = double.tryParse(match.group(2)!);
    if (latitude == null ||
        longitude == null ||
        !_validCoordinates(latitude, longitude)) {
      return null;
    }
    final matchedLabel = match.group(3)?.trim();
    final label =
        matchedLabel == null || matchedLabel.isEmpty
            ? '$latitude, $longitude'
            : matchedLabel;
    return StadtnaviLocationDeepLink(
      StadtnaviLinkLocation(
        label: label,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  static bool _validCoordinates(double latitude, double longitude) =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}
