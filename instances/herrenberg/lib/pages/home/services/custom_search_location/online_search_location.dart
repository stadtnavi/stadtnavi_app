import 'dart:async';
import 'dart:convert';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/services/custom_search_location/search_location_utils.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:trufi_core/repositories/location/interfaces/i_location_search_service.dart';

import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

import 'location_model.dart';

class OnlineSearchLocation implements ILocationSearchService {
  static const String searchEndpoint =
      'https://photon-eu.stadtnavi.eu/pelias/v1/search';

  final Map<String, dynamic>? queryParameters;

  const OnlineSearchLocation({this.queryParameters = const {}});
  @override
  Future<List<TrufiLocation>> fetchLocations(
    String query, {
    int limit = 15,
    String? correlationId,
    String? lang = "en",
  }) async {
    final extraQueryParameters = queryParameters ?? {};
    final Uri request = Uri.parse(searchEndpoint).replace(
      queryParameters: {
        "text": query,
        "boundary.rect.min_lat": "48.34164",
        "boundary.rect.max_lat": "48.97661",
        "boundary.rect.min_lon": "9.95635",
        "boundary.rect.max_lon": "8.530883",
        "focus.point.lat": "48.5957",
        "focus.point.lon": "8.8675",
        "lang": lang,
        "sources": "oa,osm,gtfshb",
        "layers": "station,venue,address,street",
        ...extraQueryParameters,
      },
    );
    final response = await _fetchRequest(request);
    if (response.statusCode != 200) {
      throw "Not found locations";
    } else {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final dataJson = List<Map<String, dynamic>>.from(json["features"]);

      final dataw = uniqByLabel(dataJson);
      final dataSorted = sortSearchResults(
        RegExp(
          r'(^[0-9]+[a-z]?$|^[yuleapinkrtdz]$|(^m[12]?b?$))',
          caseSensitive: true,
        ),
        [...dataw],
        query,
      );
      final trufiLocationList = dataSorted
          .map((x) => LocationModel.fromJson(x).toTrufiLocation())
          .toList();
      return trufiLocationList;
    }
  }

  Future<http.Response> _fetchRequest(Uri request) async {
    try {
      return await http.get(request);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<TrufiLocation> reverseGeodecoding(
    LatLng location, {
    String? lang = "en",
  }) async {
    final response = await http.get(
      Uri.parse(
        "https://photon-eu.stadtnavi.eu/pelias/v1/reverse?point.lat=${location.latitude}&point.lon=${location.longitude}&boundary.circle.radius=0.1&lang=$lang&size=1&layers=address&zones=1",
      ),
      headers: {},
    );
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final features = body["features"] as List;
    final feature = features.first;
    final properties = feature["properties"];
    final String? street = properties["street"]?.toString() ?? "";
    final String? houseNumbre = properties["housenumber"]?.toString() ?? "";
    final String? postalcode = properties["postalcode"]?.toString() ?? "";
    final String? locality = properties["locality"]?.toString() ?? "";
    String streetHouse = "";
    if (street != '') {
      if (houseNumbre != '') {
        streetHouse = "$street $houseNumbre,";
      } else {
        streetHouse = "$street,";
      }
    }
    return TrufiLocation(
      description: properties?["name"]?.toString().trim() ?? 'Not name',
      address: "$streetHouse $postalcode $locality".trim(),
      position: location,
    );
  }
}
