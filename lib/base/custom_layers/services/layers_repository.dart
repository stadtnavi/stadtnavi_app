import 'dart:async';
import 'dart:convert';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_feature_model.dart';
import 'package:stadtnavi_core/base/models/othermodel/route.dart';
import 'package:stadtnavi_core/configuration/graphql_client.dart';
import 'package:trufi_core/base/utils/graphql_client/graphql_utils.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/bike_rental_station.dart';
// import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
// import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_data_fetch.dart';
import 'package:stadtnavi_core/base/models/othermodel/vehicle_parking.dart';
import 'package:stadtnavi_core/consts.dart';

import 'graphql_operation/fragment/pattern_fragments.dart' as pattern_fragments;
import 'graphql_operation/fragment/stop_fragments.dart' as stops_fragments;
import 'graphql_operation/queries/park_queries.dart' as park_queries;
import 'graphql_operation/queries/pattern_queries.dart' as pattern_queries;
import 'graphql_operation/queries/stops_queries.dart' as stops_queries;
import 'graphql_operation/queries/alerts_queries.dart' as stops_alerts_queries;
import 'graphql_operation/fragment/alerts_fragments.dart'
    as stops_alerts_fragments;
import 'models_otp/pattern.dart';
import 'models_otp/stop.dart';

class RouteAlertData {
  final RouteOtp route;
  final PatternOtp pattern;

  const RouteAlertData({
    required this.route,
    required this.pattern,
  });
}

class LayersRepository {
  static GraphQLClient client = getClient(ApiConfig().openTripPlannerUrl);

  LayersRepository();

  static Future<Stop> fetchStopCached(String idStop) async {
    return _fetchStopByTIme(idStop, 0);
  }

  static Future<Stop> fetchStop(String idStop) async {
    return _fetchStopByTIme(
        idStop, DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  static Future<Stop> stopAlerts({
    required String idStop,
  }) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document: addFragments(
        parseString(stops_alerts_queries.stopAlertsQuery),
        [stops_alerts_fragments.stopAlertsContainer],
      ),
      variables: <String, dynamic>{
        "stopId": idStop,
      },
    );
    // "Validation error (UndefinedVariable@[stop]) : Undefined variable 'stopId'"
    final dataStopsTimes = await client.query(patternQuery);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<RouteAlertData> routeAlerts({
    required String routeId,
    required String patternId,
  }) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document: addFragments(
        parseString(stops_alerts_queries.routeAlertsQuery),
        [
          stops_alerts_fragments.routeAlertsContainer,
          stops_alerts_fragments.routePatternAlertsContainer,
        ],
      ),
      variables: <String, dynamic>{
        "routeId": routeId,
        "patternId": patternId,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final dataStopsTimes = await client.query(patternQuery);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final routeOtp = RouteOtp.fromJson(
        dataStopsTimes.data!['route'] as Map<String, dynamic>);

    final patternOtp = PatternOtp.fromJson(
        dataStopsTimes.data!['pattern'] as Map<String, dynamic>);

    return RouteAlertData(route: routeOtp, pattern: patternOtp);
  }

  static Future<Stop> fetchTimeTable(String idStop, {DateTime? date}) async {
    final WatchQueryOptions listStopTimes = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.timeTableQuery),
          [stops_fragments.timetableContainerStop]),
      variables: <String, dynamic>{
        'stopId': idStop,
        "date": DateFormat('yyyyMMdd').format(date ?? DateTime.now()),
      },
      fetchResults: true,
    );
    final dataStopsTimes = await client.query(listStopTimes);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<Stop> _fetchStopByTIme(String idStop, int startTime) async {
    final WatchQueryOptions listStopTimes = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.stopDataQuery), [
        stops_fragments.fragmentStopCardHeaderContainerstop,
        stops_fragments.stopPageTabContainerStop,
        stops_fragments.departureListContainerStoptimes,
      ]),
      variables: <String, dynamic>{
        'stopId': idStop,
        "numberOfDepartures": 100,
        "startTime": startTime,
        "timeRange": 864000
      },
      fetchResults: true,
    );
    final dataStopsTimes = await client.query(listStopTimes);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<PatternOtp> fetchStopsRoute(String patternId) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document:
          addFragments(parseString(pattern_queries.routeStopListContainer), [
        pattern_fragments.timetableContainerStop,
        addFragments(pattern_fragments.routePageMapPattern, [
          addFragments(pattern_fragments.routeLinePattern,
              [pattern_fragments.stopCardHeaderContainerStop]),
          pattern_fragments.stopCardHeaderContainerStop,
        ])
      ]),
      variables: <String, dynamic>{
        "currentTime": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "patternId": patternId
      },
      fetchResults: true,
    );
    final patternResult = await client.query(patternQuery);
    if (patternResult.hasException && patternResult.data == null) {
      throw Exception("Bad request");
    }
    final patternOtp = PatternOtp.fromJson(
        patternResult.data!['pattern'] as Map<String, dynamic>);

    return patternOtp;
  }

  static final Map<String, _CacheEntry> _cache = {};
  static const Duration cacheDuration = Duration(minutes: 1);

  static Future<CityBikeDataFetch> fetchCityBikesData(String cityBikeId) async {
    final now = DateTime.now();

    if (_cache.containsKey(cityBikeId)) {
      final cacheEntry = _cache[cityBikeId]!;
      if (now.isBefore(cacheEntry.expiration)) {
        return cacheEntry.data;
      }
    }

    final WatchQueryOptions cityBikeQuery = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.citybikeQuery),
          [stops_fragments.bikeRentalStationFragment]),
      variables: <String, dynamic>{
        "id": cityBikeId,
      },
      fetchPolicy: FetchPolicy.noCache,
      fetchResults: true,
    );

    final bikeRentalStation = await client.query(cityBikeQuery);
    if (bikeRentalStation.hasException || bikeRentalStation.data == null) {
      throw Exception("Bad request");
    }

    final bikeRentalStationData = BikeRentalStation.fromJson(
        bikeRentalStation.data!['bikeRentalStation'] as Map<String, dynamic>);

    final fetchedData =
        CityBikeDataFetch.fromBikeRentalStation(bikeRentalStationData);

    _cache[cityBikeId] = _CacheEntry(
      data: fetchedData,
      expiration: now.add(cacheDuration),
    );

    return fetchedData;
  }

  static Future<VehicleParkingDataFetch> fetchPark(String parkId,{String? locale}) async {
    client = updateClient(
      graphQLClient: client,
      endpoint: ApiConfig().openTripPlannerUrl,
      languageEncode: locale,
    );
    final WatchQueryOptions parkingQuery = WatchQueryOptions(
      document: parseString(park_queries.parking),
      variables: <String, dynamic>{
        "parkId": parkId,
      },
      fetchResults: true,
      fetchPolicy: FetchPolicy.noCache,
    );
    final parkingResult = await client.query(parkingQuery);
    if (parkingResult.hasException && parkingResult.data == null) {
      throw Exception("Bad request");
    }
    final parkingData = VehicleParking.fromMap(
        parkingResult.data!['vehicleParking'] as Map<String, dynamic>);

    return VehicleParkingDataFetch.fromVehicleParking(parkingData);
  }

  static Future<PoiFeature> fetchPoi({
    required String osmId,
    required String category,
    required LatLng position,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig().featureDetailsUrl}/collections/public.pois/items.json',
    ).replace(
      queryParameters: {
        'osm_id': osmId,
        'category3': category,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load POI: ${response.statusCode}');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final features = body is Map<String, dynamic> ? body['features'] : null;
    if (features is! List || features.isEmpty) {
      throw Exception('POI not found');
    }
    final feature = features.first;
    if (feature is! Map || feature['properties'] is! Map) {
      throw Exception('Invalid POI response');
    }
    final properties = Map<String, dynamic>.from(
      feature['properties'] as Map,
    );
    String? stringValue(String key) => properties[key]?.toString();
    bool? boolValue(String key) =>
        properties[key] is bool ? properties[key] as bool : null;

    return PoiFeature(
      geoJsonPoint: null,
      id: stringValue('id') ?? '',
      osmId: stringValue('osm_id') ?? osmId,
      address: stringValue('address'),
      brand: stringValue('brand'),
      category1: stringValue('category1') ?? category,
      category2: stringValue('category2') ?? category,
      category3: stringValue('category3') ?? category,
      changingTable: stringValue('changing_table'),
      cuisine: stringValue('cuisine'),
      dog: stringValue('dog'),
      drinkingWater: boolValue('drinking_water'),
      email: stringValue('email'),
      fee: boolValue('fee'),
      fuel: stringValue('fuel'),
      internetAccess: stringValue('internet_access'),
      name: stringValue('name'),
      openingHours: stringValue('opening_hours'),
      operatorName: stringValue('operator'),
      osmType: stringValue('osm_type'),
      outdoorSeating: stringValue('outdoor_seating'),
      phone: stringValue('phone'),
      sauna: stringValue('sauna'),
      swimmingPool: stringValue('swimming_pool'),
      website: stringValue('website'),
      wheelchair: stringValue('wheelchair'),
      position: position,
    );
  }
}

class _CacheEntry {
  final CityBikeDataFetch data;
  final DateTime expiration;

  _CacheEntry({required this.data, required this.expiration});
}
