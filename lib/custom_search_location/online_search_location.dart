import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:trufi_core/blocs/location_search_bloc.dart';
import 'package:trufi_core/models/trufi_place.dart';
import 'package:trufi_core/pages/home/plan_map/plan_empty.dart';
import 'package:trufi_core/repository/exception/fetch_online_exception.dart';
import 'package:trufi_core/services/search_location/search_location_manager.dart';

import 'location_model.dart';

class OnlineSearchLocation implements SearchLocationManager {
  static const String searchEndpoint =
      'https://photon.stadtnavi.eu/pelias/v1/search';
  @override
  Future<List<TrufiPlace>> fetchLocations(
    LocationSearchBloc locationSearchBloc,
    String query, {
    String correlationId,
    int limit = 15,
  }) async {
    final Uri request = Uri.parse(
      searchEndpoint,
    ).replace(queryParameters: {
      "text": query,
      "boundary.rect.min_lat": "48.34164",
      "boundary.rect.max_lat": "48.97661",
      "boundary.rect.min_lon": "9.95635",
      "boundary.rect.max_lon": "8.530883",
      "focus.point.lat": "48.5957",
      "focus.point.lon": "8.8675",
      "lang": Intl.getCurrentLocale().split("_")[0],
      "sources": "oa,osm,gtfshb",
      "layers": "station,venue,address,street",
    });

    final response = await _fetchRequest(request);
    if (response.statusCode != 200) {
      throw "Not found locations";
    } else {
      utf8.decode(response.bodyBytes);
      return _parseLocation(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    }
  }

  Future<http.Response> _fetchRequest(Uri request) async {
    try {
      return await http.get(
        request,
      );
    } on Exception catch (e) {
      throw FetchOnlineRequestException(e);
    }
  }

  List<TrufiLocation> _parseLocation(Map<String, dynamic> json) {
    final list = List<LocationModel>.from((json["features"] as List)
        .map((x) => LocationModel.fromJson(x as Map<String, dynamic>)));
    final trufiLocationList =
        list.map<TrufiLocation>((e) => e.toTrufiLocation()).toList();
    return trufiLocationList;
  }

  @override
  Future<LocationDetail> reverseGeodecoding(LatLng location) async {
    final response = await http.get(
      Uri.parse(
        "https://photon.stadtnavi.eu/pelias/v1/reverse?point.lat=${location.latitude}&point.lon=${location.longitude}&boundary.circle.radius=0.1&lang=en&size=1&layers=address&zones=1",
      ),
      headers: {},
    );
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final features = body["features"] as List;
    final feature = features.first;
    final properties = feature["properties"];
    final String street = properties["street"]?.toString();
    final String houseNumbre = properties["housenumber"]?.toString();
    final String postalcode = properties["postalcode"]?.toString() ?? "";
    final String locality = properties["locality"]?.toString() ?? "";
    final String address = street != null ? "$street $houseNumbre, " : "";
    return LocationDetail(
      properties["name"]?.toString(),
      "$address$postalcode $locality",
    );
  }
}
