import 'dart:async';
import 'package:intl/intl.dart';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';

import 'graphl_client/graphql_client.dart';
import 'graphl_client/graphql_utils.dart';

import 'graphql_operation/fragment/stop_fragments.dart' as stops_fragments;
import 'graphql_operation/queries/stops_queries.dart' as stops_queries;
import 'models_otp/stop.dart';

class LayersRepository {
  final GraphQLClient client = getClient();

  LayersRepository();

  Future<Stop> fetchStopCached(String idStop) async {
    return _fetchStopByTIme(idStop, 0);
  }

  Future<Stop> fetchStop(String idStop) async {
    return _fetchStopByTIme(
        idStop, DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  Future<Stop> fetchTimeTable(String idStop, {DateTime date}) async {
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
        Stop.fromJson(dataStopsTimes.data['stop'] as Map<String, dynamic>);

    return stopData;
  }

  Future<Stop> _fetchStopByTIme(String idStop, int startTime) async {
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
        Stop.fromJson(dataStopsTimes.data['stop'] as Map<String, dynamic>);

    return stopData;
  }
}
